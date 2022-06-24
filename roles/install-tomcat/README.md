Role Name
==============
install-tomcat

Installs Java JDK8/Tomcat8 or Java JDK11/Tomcat9 onto either Ubuntu or RedHat systems.

Requirements
------------

This roles requires Ubuntu 18.04 thru 20.04 pr RedHat 7/8.

Below variables need to be passed during runtime using ansible-playbook command line

playbookname variable should be as below:
  For Tomcat 8 application- tomcat8
  For Tomcat 9 application- tomcat9 

env- env variable can be as below 
  For Development env-- dev
  For Integeration env -- int
  For Regration env-- reg
  For Stage env -- stage
  For Production env -- prod



 ansible-playbook --vault-password-file=/etc/ansible/.vault_pass --extra-vars '@pass.yml' /etc/ansible/playbooks/main.yml -e playbookname=tomcat9 -e env=dev

Note: 

 1. Choose Container : Install_Tomcat


 2. Update File : /etc/ansible/hosts and add below line:
[Linux]
Servername:port

 3. Update File :/etc/ansible/playbook/main/yml

---
 - hosts: linux
   become: yes
   become_user: root
   roles:
     - role: install-tomcat


Role Variables: These variables listed below are supplied internally within the vars folder and do not need to be specified by the user.
---------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------------------
| 	Variable	|    		Default			| Required | 		Options 	| 		Description 		|
|-------------------------------|-------------------------------| -------- | -------------------------- | --------------------------------------|
| vg 				| tomcat			| Yes	   | tomcat  			| Volume group name for Tomcat LVs	|
| jenkins_user			| jenkins			| Yes	   | jenkins			| jenkins user				|
| jenkins_password		| jenkins			| Yes	   | jenkins			| jenkins password			|
| src_policy_jar		| local_policy.jar		| Yes	   | tomcat9/webapps		| Local policy jar file			|
| webapps_path			| /var/lib/tomcat9/webapps	| Yes	   | tomcat9/webapps		| WebApps path                          |
| varlogservice_path		| /var/lib/tomcat9/webapps	| Yes	   | tomcat9/webapps		| Var log service path			|
| tomcat8_src_tcsystemdxml	| tomcat8.service		| Yes	   | tomcat8.service		| Tomcat8 services file			|
| tomcat9_src_tcsystemdxml	| tomcat9.service		| Yes	   | tomcat8.service		| Tomcat9 services file			|
| src_jdbclibrariesxml		| jdbclibraries.tar.gz		| Yes	   | jdbclibraries.tar.gz	| jdbclibrariesxml file			|
| java_JDK8 			| java-8-openjdk-devel		| Yes	   | java-11-openjdk-devel	| RedHat Java JDK 8 binary file		|
| Ubuntu_JDK8 			| openjdk-8-jdk			| Yes	   | openjdk-8-jdk		| Ubuntu Java JDK 8 binary file		|
| java_JDK11 			| java-11-openjdk-devel		| Yes	   | java-11-openjdk-devel	| RedHat Java JDK 11 binary file	|
| Ubuntu_JDK11			| openjdk-11-jdk		| Yes	   | openjdk-11-jdk		| Ubuntu Java JDK 11 binary file	|
-------------------------------------------------------------------------------------------------------------------------------------------------

Variables passed from the ansible-playbook command line
-------------------------------------------------------

I. It is important to remember the purpose of this playbook:
  A. Install tomcat8 or tomcat9 on either a Ubuntu or RedHat Linux platform
  B. The installation software will be dependent of the version of tomcat:
  C. Tomcat8 implementation will install the following software package on the remote host:
    1. tomcat8 apache web services
    2. Java JDK 8
    3. NTP software
  D. Tomcat9 implementation will install the following software package on the remote host:
    1. tomcat9 apache web services
    2. Java JDK 11
    3. NTP software
  E. In addition, it is important to provide the environment to which this remote Linux host support; those environments being:
    1. Development	Note: Use 'dev' for the $env variable within the ansible-playbook command line
    2. Integregation	Note: Use 'int' for the $env variable within the ansible-playbook command line
    3. Regression	Note: Use 'reg' for the $env variable within the ansible-playbook command line
    4. Stage		Note: Use 'stage' for the $env variable within the ansible-playbook command line
    5. Production	Note: Use 'prod' for the $env variable within the ansible-playbook command line
  F. When invoking the ansible-playbook command, these parameters will then be passed.
  G. All variables listed in the diagram above are supplied internally via the vars main.yml file so they do not need to be supplied as run time.
  H. Additionally the inventory and ansible.cfg files must be modified as well to reflect the host server name and connectivity settings.
  I. Below is an example of how this playbook would be run from the command line using the ansible-playbook command:


  J. To illistrate an example, if we wanted to install tomcat8 on server dev-abm-01.universal.co, we would populate the following variables:

    1. Inventory=your_inventory_file
    2. user=ansible
    3. Playbook=install-tomcat.yml
    4. playbookname=tomcat8
    5. env=dev
    6. ansible_become_pass=ansible_user_password
    7. ansible_ssh_pass=ansible_user_password
    8. ansible_ssh_pass=ansible_user_password
    9. ansible_sudo_pass=ansible_user_password

  K. Make sure that your inventory file looks something like this:

 		linux:
  		  hosts:
    		    dev-abm-01.universal.co:22:
  		  vars:
    		    ANSIBLE_CONFIG: /path/to/ansible.cfg

  L. Your ansible.cfg file should look something like this:

		inventory = /path/to/inventoryfile
		host_key_checking = False
		log_path = /path/to/ansible.log
		system_warnings = False
		deprecation_warnings=False
		[inventory]
		[privilege_escalation]
		[paramiko_connection]
		[ssh_connection]
		[persistent_connection]
		[accelerate]
		[selinux]
		[colors]
		[diff]

  M. Your install-tomcat.yml file should look something like this:

		---
		- hosts: linux
  		  gather_facts: true
  		  roles:
    		    - roles/install-tomcat

  N. Now you are ready to execute the install-tomcat.yml playbook via the ansible-playbook command properly.

Dependencies
------------

TODO: Figure out if we should have a dependecy on windows features

Example Playbook
----------------
```
---

# Create the appropriate tomcatx group and user if it does not already exist.

- name: "Ensure {{ playbookname }} group exists, if not create it"
  group:
    name: "{{ playbookname }}"
    state: present

- name: "Ensure the {{ playbookname }} user exists"
  user:
    name: "{{ playbookname }}"
    shell: /bin/nologin
    group: "{{ playbookname }}"
    append: yes
    home: "/var/lib/{{ playbookname }}"
    state: present

# Check to see if an unused seperate disk is available on the host and about operations if it does not.

- name: Copy FindDisk.ksh file
  copy:
    src: files/FindDisk_Debian.ksh
    dest: /tmp/FindDisk.ksh
    owner: root
    group: root
    mode: 777
  when: ansible_os_family == 'Debian'

- name: Copy FindDisk.ksh file
  copy:
    src: files/FindDisk_RedHat.ksh
    dest: /tmp/FindDisk.ksh
    owner: root
    group: root
    mode: 777
  when: ansible_os_family == 'RedHat'

- name: Execute FindDisk.ksh file
  shell: /tmp/FindDisk.ksh
  register: hdisk

- name: Nuke the /tmp/FindDisk.ksh on the remote host
  file:
    path: /tmp/FindDisk.ksh
    state: absent

- fail:
    msg: "No additional free disk available. hdisk = {{ hdisk.stdout }}"
  when: hdisk.stdout == ""

# Carve out the appropriate filesystems for Tomcat installation.

- name: Create VG
  lvg:
    vg: "{{ vg }}"
    pvs: "{{ hdisk.stdout }}"

- name: Create lv1
  lvol:
    vg: "{{ vg }}"
    lv: "{{ lv1 }}"
    size: "{{ size1 }}"

- name: Create lv2
  lvol:
    vg: "{{ vg }}"
    lv: "{{ lv2 }}"
    size: "{{ size2 }}"

- name: Create lv3
  lvol:
    vg: "{{ vg }}"
    lv: "{{ lv3 }}"
    size: "{{ size3 }}"

- name: Create Filesystem on lv1
  filesystem:
    fstype: xfs
    dev: "/dev/{{ vg }}/{{ lv1 }}"

- name: Create Filesystem on lv2
  filesystem:
    fstype: xfs
    dev: "/dev/{{ vg }}/{{ lv2 }}"

- name: Create Filesystem on lv3
  filesystem:
    fstype: xfs
    dev: "/dev/{{ vg }}/{{ lv3 }}"

- name: Setup Mount points on the first filesystem.
  mount:
    state: mounted
    fstype: xfs
    path: "{{ mp1 }}"
    src: "/dev/mapper/{{ vg }}-{{ lv1 }}"
    opts: defaults
  when: vars[item] is not none
  with_items: lvol0

- name: Setup Mount points on the second filesystem.
  mount:
    state: mounted
    fstype: xfs
    path: "{{ mp2 }}"
    src: "/dev/mapper/{{ vg }}-{{ lv2 }}"
    opts: defaults
  when: vars[item] is not none
  with_items: lvol1

- name: Setup Mount points on the third filesystem.
  mount:
    state: mounted
    fstype: xfs
    path: "{{ mp3 }}"
    src: "/dev/mapper/{{ vg }}-{{ lv3 }}"
    opts: defaults
  when: vars[item] is not none
  with_items: lvol2

- name: Modify the access for the first filesystem
  file:
    path: "{{ mp1 }}"
    owner: "{{ playbookname }}"
    group: "{{ playbookname }}"
    mode: 0755
    state: directory

- name: Modify the access for the second filesystem
  file:
    path: "{{ mp2 }}"
    owner: "{{ playbookname }}"
    group: "{{ playbookname }}"
    mode: 0755
    state: directory

- name: Modify the access for the third filesystem
  file:
    path: "{{ mp3 }}"
    owner: "{{ playbookname }}"
    group: "{{ playbookname }}"
    mode: 0755
    state: directory

# Create necessary symbolic link directories

- name: Create the java bin symbolic link directory
  file:
    path: /usr/lib/jvm/jre/bin
    owner: "{{ playbookname }}"
    group: "{{ playbookname }}"
    mode: '0755'
    state: directory

- name: Create the java lib symbolic link directory
  file:
    path: /usr/lib/jvm/jre/lib
    owner: "{{ playbookname }}"
    group: "{{ playbookname }}"
    mode: '0755'
    state: directory

- name: "Ensure the /var/lib/{{ playbookname }} directory exists"
  file:
    path: "{{ playbookname }}"
    owner: "{{ playbookname }}"
    group: "{{ playbookname }}"
    mode: '0755'
    state: directory

- name: "Ensure the /var/log/service directory exists"
  file:
    path: "files/{{ playbookname }}/{{ varlogservice_path }}"
    owner: "{{ playbookname }}"
    group: "{{ playbookname }}"
    state: directory
    mode: 0775

# The next block of plays concentrates on preliminaries for installing Tomcat8 onto Ubuntu servers.

- name: Install java and Tomcat8 on Ubuntu
  block:

  - name: Ensure the system can use the HTTPS transport for APT.
    stat:
      path: /usr/lib/apt/methods/https
    register: apt_https_transport

  - name: Install APT HTTPS transport.
    apt:
      name: "apt-transport-https"
      state: present
      update_cache: yes
    when: not apt_https_transport.stat.exists

  - name: "Install java version {{ Ubuntu_JDK8 }} for {{ playbookname }} on {{ ansible_os_family }}"
    apt:
      name: "{{ Ubuntu_JDK8 }}"
      state: present

  - name: Find java bin installation directory.
    shell: find / -name java|grep open|grep -v jre
    register: javabindir

  - name: "Create the java symbolic link for {{ playbookname }} on Ubuntu."
    file:
      src: "{{ javabindir.stdout }}"
      dest: /usr/lib/jvm/jre/bin/java
      owner: "{{ playbookname }}"
      group: "{{ playbookname }}"
      state: link

  when: ansible_os_family  == 'Debian' and playbookname == 'tomcat8'

# Install Open JDK8 on RedHat systems

- name: Install java and Tomcat8 on RedHat
  block:

  - name: "Install java version {{ RedHat_JDK8 }} for {{ playbookname }} on {{ ansible_os_family }}"
    yum:
      name: "{{ RedHat_JDK8 }}"
      state: latest

  - name: Find java bin installation directory.
    shell: find / -name java|grep open|grep -v jre
    register: javabindir

  - name: "Create the java symbolic link for {{ playbookname }} on RedHat."
    file:
      src: "{{ javabindir.stdout }}"
      dest: /usr/lib/jvm/jre/bin/java
      owner: "{{ playbookname }}"
      group: "{{ playbookname }}"
      state: link

  when: ansible_os_family == 'RedHat' and playbookname == 'tomcat8'

# Install Tomcat8 on either Ubuntu or RedHat; OS type doesn't matter.

- name: "Install tomcat8 into /var/lib/tomcat8"
  unarchive:
    src: files/apache-tomcat-8.5.39.tar.gz
    dest: /var/lib/tomcat8/
    creates: "/var/lib/{{ playbookname }}/bin"
    extra_opts: [--strip-components=1]
    owner: "{{ playbookname }}"
    group: "{{ playbookname }}"
  when: playbookname == 'tomcat8'

# Install both Open JDK11 and Tomcat9 on Ubuntu or RedHat; OS type doesn't matter.

- name: Set up preliminaries for installation of tomcat8 onto Ubuntu.
  block:

   - name: "Install java version {{ java_JDK11 }} in RedHat"
     yum:
       name: "{{ java_JDK11 }}"
       state: latest
     when: ansible_os_family  == 'RedHat' and playbookname == 'tomcat9'

   - name: "Install java version {{ Ubuntu_JDK11 }} in Debian"
     yum:
       name: "{{ Ubuntu_JDK11 }}"
       state: latest
     when: ansible_os_family  == 'Debian' and playbookname == 'tomcat9'

   - name: Find java bin installation directory.
     shell: find / -name java|grep open|grep -v jre
     register: javabindir

   - name: Create a symbolic link
     file:
       src: "{{ javabindir.stdout }}"
       dest: /usr/lib/jvm/jre/bin/java
       owner: "{{ playbookname }}"
       group: "{{ playbookname }}"
       state: link

   - name: "Install tomcat9 into /var/lib/tomcat9"
     unarchive:
       src: files/apache-tomcat-9.0.41.tar.gz
       dest: /var/lib/tomcat9/
       creates: "/var/lib/{{ playbookname }}/bin"
       extra_opts: [--strip-components=1]
       owner: "{{ playbookname }}"
       group: "{{ playbookname }}"

  when: playbookname == 'tomcat9'

# The remainder of the plays can be run unconditionally from OS version and software version.
# -------------------------------------------------------------------------------------------

# Make sure the entire /var/lib/tomcatx directory structure is owned recurresively by tomcatx.

- name: "Change folder permissions on /var/lib/{{ playbookname }} recursively"
  file:
    path: /var/lib/{{ playbookname }}
    owner: "{{ playbookname }}"
    group: "{{ playbookname }}"
    mode: 0775
    state: directory
    recurse: yes

# Find the path where Java is installed and put the local policy and US Export Policy jar files there.

- name: Find security folder
  raw: "find /usr -name blacklisted.certs|sed 's/blacklisted.certs//g'"
  register: security

- name: "Installing the local policy jar for java"
  copy:
    src: "files/{{ src_policy_jar }}"
    dest: "{{ security.stdout }}/"

- name: "Installing the US Export Policy jar for java"
  copy:
    src: "files/{{ src_us_export_policy }}"
    dest: "{{ security.stdout }}/"

# Create the jenkins group if it doesn't already exist.

- name: "Ensure jenkins_user group exists, if not create it"
  group:
    name: "{{ jenkins_user}}"
    state: present

# Create the jenkins user if it doesn't already exist.

- name: "Ensure the jenkins user exists, if not create it"
  user:
    name: "{{ jenkins_user }}"
    shell: /bin/bash
    group: "{{ jenkins_user}}"
    append: yes
    home: "/home/{{ jenkins_user }}"
    state: present

# Add the jenkins user to the appropriate sudo group based on OS type.

- name: "Add user jenkins to sudo group"
  shell: "usermod -a -G sudo jenkins"
  when: ansible_os_family == 'Debian'

- name: "Add user jenkins to sudo group"
  shell: "usermod -a -G wheel jenkins"
  when: ansible_os_family == 'RedHat'

# Copy the appropriate environmental server.xml and context.xml files into the /var/lib/tomcatx/conf directory.

- name: "Install the {{ env }} server.xml file into /var/lib/{{ playbookname }}/conf directory."
  copy:
    src: "files/{{ env }}/{{ env }}.server.xml"
    dest: "/var/lib/{{ playbookname }}/conf/server.xml"
    owner: "{{ playbookname }}"
    group: "{{ playbookname }}"
    mode: 0600

- name: "Install the {{ env }} context.xml file into /var/lib/{{ playbookname }}/conf directory."
  copy:
    src: "files/{{ env }}/{{ env }}.context.xml"
    dest: "/var/lib/{{ playbookname }}/conf/context.xml"
    owner: "{{ playbookname }}"
    group: "{{ playbookname }}"
    mode: 0600

# Installs the 4 requires sqljdbc libarires for our JNDI connections to work under /var/lib/tomcatx/lib directory.

- name: "Install the 4 requires sqljdbc libarires for our JNDI connections to work under /var/lib/{{ playbookname }}/lib"
  unarchive:
   src: "files/{{ src_jdbclibrariesxml }}"
   dest: "/var/lib/{{ playbookname }}/lib"
   owner: "{{ playbookname }}"
   group: "{{ playbookname }}"
   mode: 0640

# This play will generate an error if App Dynamics is not installed and it will be ignored on purpose.

- name: Check if app dynamics is installed
  shell: systemctl status appd-machine
  register: appd_result
  ignore_errors: True

# Copy the appropriate environmental setenv.sh file into the /var/lib/tomcatx/bin directory when App Dynamics is not installed.

- name: "Install the {{ env }} no-appd-installed setenv.sh file under /var/lib/{{ playbookname }}/bin directory"
  copy:
    src: "files/{{ env }}/{{ env }}.noappdsetenv.sh"
    dest: "/var/lib/{{ playbookname }}/bin/setenv.sh"
    owner: "{{ playbookname }}"
    group: "{{ playbookname }}"
    mode: 0760
  when: appd_result is failed

# Copy the appropriate environmental setenv.sh file into the /var/lib/tomcatx/bin directory when App Dynamics is installed.

- name: "Install the {{ env }} yes-appd-installed setenv.sh file under /var/lib/{{ playbookname }}/bin directory"
  copy:
    src: "files/{{ env }}/{{ env }}.yesappdsetenv.sh"
    dest: "/var/lib/{{ playbookname }}/bin/setenv.sh"
    owner: "{{ playbookname }}"
    group: "{{ playbookname }}"
    mode: 0760
  when: appd_result is succeeded

# Enable port 61000 on the remote host based on OS type.

- name: Enable port 61000 for tomcat communications in UFW
  ufw:
   rule: allow
   port: 61000
   proto: tcp
  when: ansible_os_family == 'Debian'

- name: "Enable port 61000 for tomcat communicatinos in firewalld"
  firewalld:
    port: 61000/tcp
    zone: public
    permanent: yes
    state: enabled
  when: ansible_os_family == 'RedHat'

# Reload the firewall daemon on RedHat systems.

- name: "Reload firewalld to enable the public zone addition of 61000/tcp"
  service:
    name: firewalld
    state: reloaded
  when: ansible_os_family == 'RedHat'

# Install the appropriate systemctl service file based on Tomcat version.

- name: "Install the {{ playbookname }} systemctl service file"
  copy:
    src: "files/{{ playbookname }}/{{ tomcat8_src_tcsystemdxml }}"
    dest: "/etc/systemd/system/{{ playbookname }}.service"
    owner: root
    group: root
    mode: 0755
  when: playbookname == 'tomcat8'

- name: "Install the {{ playbookname }} systemctl service file"
  copy:
    src: "files/{{ playbookname }}/{{ tomcat9_src_tcsystemdxml }}"
    dest: "/etc/systemd/system/{{ playbookname }}.service"
    owner: root
    group: root
    mode: 0755
  when: playbookname == 'tomcat9'

# Enable the tomcatx service.

- name: "Enable the {{ playbookname }} service"
  ignore_errors: True
  service:
    name: "{{ playbookname }}.service"
    enabled: yes

# Ensure the /var/lib/tomcatx/webapps dir is mode 0770 so jenkins can deploy and manage apps there.

- name: "Ensure the /var/lib/{{ playbookname }}/webapps dir is mode 0770 so jenkins can deploy and manage apps there"
  file:
    path: "files/{{ playbookname }}/{{ webapps_path }}"
    owner: "{{ playbookname }}"
    group: "{{ playbookname }}"
    state: directory
    mode: 0770

# Set up the ntp daemon on the appropriate OS platform.

- name: Setting up ntp on RedHat
  block:

  - name: "Installing ntp daemon"
    yum:
      name: ntp

  - name: "Setup ntp"
    template:
      src: files/ntp.conf
      dest: /etc/ntp.conf
      mode: 0644

  - name: "Ensure ntpd is running and enabled"
    service:
      name: ntpd
      state: restarted
      enabled: yes

  when: ansible_os_family  == 'RedHat'

- name: Setting up ntp on Ubuntu
  block:

  - name: Install ntp on Ubuntu
    apt:
      name: ntp
      state: present

  - name: "Setup ntp"
    template:
      src: files/ntp.conf
      dest: /etc/ntp.conf
      mode: 0644

  - name: "Ensure ntpd is running and enabled"
    service:
      name: ntp
      state: restarted
      enabled: yes

  when: ansible_os_family  == 'Debian'

# Fire up Tomcat.

- name: "Ensure {{ playbookname }} is running and enabled"
  service:
    name: "{{ playbookname }}"
    state: restarted
    enabled: yes

# Copy the TC Native libraries to the /var/lib/tomcat9/lib directory when Tomcat9 is being installed.

- name: Perform steps associated to just tomcat9 installation
  block:

  - name: Copy libtcnative-1.a file
    copy:
      src: files/libtcnative-1.a
      dest: /var/lib/tomcat9/lib/libtcnative-1.a
      owner: tomcat9
      group: tomcat9
      mode: 777

  - name: Copy libtcnative-1.la file
    copy:
      src: files/libtcnative-1.la
      dest: /var/lib/tomcat9/lib/libtcnative-1.la
      owner: tomcat9
      group: tomcat9
      mode: 777

  - name: Copy libtcnative-1.so.0.2.25 file
    copy:
      src: files/libtcnative-1.so.0.2.25
      dest: /var/lib/tomcat9/lib/libtcnative-1.so.0.2.25
      owner: tomcat9
      group: tomcat9
      mode: 777

  - name: Create a symbolic link for libtcnative-1.so
    file:
      src: /var/lib/tomcat9/lib/libtcnative-1.so.0.2.25
      dest: /var/lib/tomcat9/lib/libtcnative-1.so
      owner: tomcat9
      group: tomcat9
      state: link

  - name: Create a symbolic link for libtcnative-1.so.0
    file:
      src: /var/lib/tomcat9/lib/libtcnative-1.so.0.2.25
      dest: /var/lib/tomcat9/lib/libtcnative-1.so.0
      owner: tomcat9
      group: tomcat9
      state: link

  when: playbookname == 'tomcat9'

```

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).
# Hello
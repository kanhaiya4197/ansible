install-java
==============

Installs Java JDK8 or Java JDK11 onto either Ubuntu or RedHat systems.

Requirements
------------

This roles requires Ubuntu 14.04 thru 20.04 pr RedHat 7/8.

Role Variables: These variables listed below are supplied internally within the vars folder and do not need to be specified by the user.
---------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------------------
| 	Variable	|    		Default			| Required | 		Options 	| 		Description 		|
|-----------------------|---------------------------------------| -------- | -------------------------- | --------------------------------------|
| Ubuntu_JDK11 		| openjdk-11-jdk			| Yes	   | openjdk-11-jdk		| Ubuntu Java JDK 11 binary file	|
| RedHat_JDK11 		| java-11-openjdk-devel			| Yes	   | java-11-openjdk-devel	| RedHat Java JDK 11 binary file        |
| Ubuntu_JDK8 		| openjdk-8-jdk				| Yes	   | openjdk-8-jdk		| Ubuntu Java JDK 8 binary file		|
| RedHat_JDK8 		| java-1.8.0-openjdk-devel		| Yes	   | java-1.8.0-openjdk-devel	| RedHat Java JDK 8 binary file         |
-------------------------------------------------------------------------------------------------------------------------------------------------

Variables passed from the ansible-playbook command line
-------------------------------------------------------

I. It is important to remember the purpose of this playbook:
  A. Install java JDK 8 or java JDK 11 on either a Ubuntu or RedHat Linux platform
  B. Tomcat8 implementation will install the following software package on the remote host:
    1. Java JDK 8
    2. Java JDK 11
  C. When invoking the ansible-playbook command, three parameters will be passed.
    1. Server Name
    2. Ansible Password
    3. Java version
  D. All variables listed in the diagram above are supplied internally via the vars main.yml file so they do not need to be supplied as run time.
  E. Additionally the inventory and ansible.cfg files must be modified as well to reflect the host server name and connectivity settings.
  F. Below is an example of how this playbook would be run from the command line using the ansible-playbook command:

  ansible-playbook -i $Inventory -u $user -b --become-method=sudo $Playbook -e playbookname=$playbook -e env=$env -e ansible_password=$Pwd

  J. To illistrate an example, if we wanted to install tomcat8 on server dev-abm-01.universal.co, we would populate the following variables:

    1. Inventory=your_inventory_file
    2. user=ansible
    3. Playbook=install-tomcat.yml
    4. playbookname=tomcat8
    5. env=dev
    6. ansible_become_pass=ansible_user_password (Linux only)
    7. ansible_ssh_pass=ansible_user_password (Linux only)
    8. ansible_ssh_pass=ansible_user_password (Linux only)
    9. ansible_sudo_pass=ansible_user_password (Linux only)
    10. ansible_password=ansible_user_password (Windows only)

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
    		    - roles/install-java

  N. Now you are ready to execute the install-tomcat.yml playbook via the ansible-playbook command properly.

Dependencies
------------

TODO: Figure out if we should have a dependecy on windows features

Example Playbook
----------------
```
---

- debug:
    msg: "env = {{ env }}"

- name: "Install java version {{ Ubuntu_JDK8 }} in Debian"
  apt:
    name: "{{ Ubuntu_JDK8 }}"
    state: present
  when: ansible_os_family == 'Debian' and env == 'java8'

- name: "Install java version {{ Ubuntu_JDK11 }} in Debian"
  apt:
    name: "{{ Ubuntu_JDK11 }}"
    state: latest
  when: ansible_os_family == 'Debian' and env == 'java11'

- name: "Install java version {{ RedHat_JDK8 }} in RedHat"
  yum:
    name: "{{ RedHat_JDK8 }}"
    state: latest
  when: ansible_os_family == 'RedHat' and env == 'java8'

- name: "Install java version {{ RedHat_JDK11 }} in RedHat"
  yum:
    name: "{{ RedHat_JDK11 }}"
    state: latest
  when: ansible_os_family == 'RedHat' and env == 'java11'

- name: Create symbolic link
  block:

  - name: Find java bin installation directory.
    shell: find / -name java|grep open|grep -v jre
    register: javabindir

  - name: Check if link exists
    stat:
      path: /usr/lib/jvm/jre/bin/java
    register: doeslinkexist

  - name: Create the java symbolic link for java on Ubuntu.
    file:
      src: "{{ javabindir.stdout }}"
      dest: /usr/lib/jvm/jre/bin/java
      state: link
    when: doeslinkexist.stat.exists == False

  when: ansible_os_family == 'RedHat' or ansible_os_family == 'Debian'

- name: Create the c:\Temp directory if it doesn't already exist
  win_file:
    path: c:\Temp
    state: directory
  when: ansible_os_family == 'Windows'

- name: Install Java JDK 8 on remote host
  block:

  - name: Copy java Developers Kit version 8 executable to Windows server
    win_copy:
      src: files/jdk-8u271-windows-x64.exe
      dest: C:\Temp\jdk-8u271-windows-x64.exe

  - name: Install Java Developer Kit version 8 on Windows
    raw: 'c:\Temp\jdk-8u271-windows-x64.exe /s ADDLOCAL="ToolsFeature,SourceFeature"'

  - name: Set Java_home on Windows
    win_environment:
      state: present
      name: JAVA_HOME
      value: 'c:\program files\java\jdk1.8.0_271'
      level: machine

  - name: Add Java to path on Windows
    win_path:
      elements:
        - 'c:\program files\java\jdk1.8.0_271\bin'

  - name: Nuke the Java 8 installation file from the remote host
    win_file:
      path: C:\Temp\jdk-8u271-windows-x64.exe
      state: absent

  when: ansible_os_family == 'Windows' and env == 'java8'

- name: Install Java JDK 11 on remote host
  block:

  - name: Copy java Developers Kit version 11 executable to Windows server
    win_copy:
      src: files/jdk-11.0.10_windows-x64_bin.exe
      dest: C:\Temp\jdk-11.0.10_windows-x64_bin.exe

  - name: Install Java Developer Kit version 11 on Windows
    raw: 'c:\Temp\jdk-11.0.10_windows-x64_bin.exe /s ADDLOCAL="ToolsFeature,SourceFeature"'

  - name: Set Java_home on Windows
    win_environment:
      state: present
      name: JAVA_HOME
      value: 'C:\Program Files\Java\jdk-11.0.10'
      level: machine

  - name: Add Java to path on Windows
    win_path:
      elements:
        - 'C:\Program Files\Java\jdk-11.0.10\bin'

  - name: Nuke the Java 11 installation file from the remote host
    win_file:
      path: C:\Temp\jdk-11.0.10_windows-x64_bin.exe
      state: absent

  when: ansible_os_family == 'Windows' and env == 'java11'

```

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).

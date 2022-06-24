INSTALL-IIS
=========

Installs IIS and configures your web application. Also sets up optional Windows features.
Install dotnet 3.5 framework, dotnet hosting, dotnet sdk, dotnet runtime, and aspdotnetcore runtime

Requirements
------------

This roles requires Windows Server 2016 or Windows Server 2019.

Role Variables
--------------

| Variable       | Default | Required | Options | Description |
| -------------- | ----------- | -------- | ------- | ------- |
| tmpdir | | N | C:\temp | Used for keeping Temporary files |
| dotnetver | | N | 5.0.15 | Used for adding dotnet runtime |
| dotnetsdkver | | N | 5.0.406 | Used for adding dotnet hosting |
| aspdotnetver | | N | 5.0.15 | Used for adding dotnet hosting |
| dotnet6ver | | N | 6.0.5 | Used for adding dotnet runtime |
| dotnet6sdkver | | N | 6.0.203 | Used for adding dotnet hosting |
| aspdotnet6ver | | N | 6.0.5 | Used for adding dotnet hosting |
| dotnethostingurl | | N | https://download.visualstudio.microsoft.com/download/pr/d7d20e41-4bee-4f8a-a32c-278f0ef8ce1a/f5a0c59b42d01b9fc2115615c801866c/dotnet-hosting-{{ dotnetver }}-win.exe | Used for Downloading .net bundle |
| dotnetruntimeurl | | N | https://download.visualstudio.microsoft.com/download/pr/744a5a4b-c931-4365-9762-5154e999af13/51553f5bfe24e1f7d54abbfbb94d0c4c/dotnet-runtime-{{ dotnetver }}-win-x64.exe | Used for Downloading .net bundle |
| dotnetsdkurl | | N | https://download.visualstudio.microsoft.com/download/pr/f92c52da-2ef6-44f2-a296-487f94c2c37a/258dc2e61ff8bec7d90aee3ca1e7d8a3/dotnet-sdk-{{ dotnetsdkver }}-win-x64.exe | Used for Downloading .net bundle |
| aspdotnetruntimeurl | | N |   aspdotnetruntimeurl: https://download.visualstudio.microsoft.com/download/pr/69b4d158-fadb-46d0-8b28-6c4ba2968926/c4d93beeb194b73c134b3c2824499467/aspnetcore-runtime-{{ aspdotnetver }}-win-x64.exe
 | Used for Downloading .net bundle |
| dotnet6hostingurl | | N | https://download.visualstudio.microsoft.com/download/pr/ae1014c7-a005-4a0e-9062-b6f3056ded09/da5d731f5ead9e385427a77412b88fb0/dotnet-hosting-{{ dotnet6ver }}-win.exe | Used for Downloading .net bundle |
| dotnet6runtimeurl | | N | https://download.visualstudio.microsoft.com/download/pr/b395fa18-c53b-4f7f-bf91-6b2d3c43fedb/d83a318111da9e15f5ecebfd2d190e89/dotnet-runtime-{{ dotnet6ver }}-win-x64.exe | Used for Downloading .net bundle |
| dotnet6sdkurl | | N | https://download.visualstudio.microsoft.com/download/pr/c4de68d7-15fb-418a-ac11-fb51212cd16d/029648aa5eec8aed3800883620ec5d9e/dotnet-sdk-{{ dotnet6sdkver }}-win-x64.exe | Used for Downloading .net bundle |
| aspdotnet6runtimeurl | | N | https://download.visualstudio.microsoft.com/download/pr/042e2559-fe53-4793-b385-665b7c1ca6d5/308ffacc925383207a8f1a27a1df8bdc/aspnetcore-runtime-{{ aspdotnet6ver }}-win-x64.exe | Used for Downloading .net bundle |

| iis_app_pool_name | 'DefaultAppPool' | Y | | The name of the app pool to create or update and associate with the site|
| install_dotnet_hosting | true | N | true, false | Install the .Net hosting package |
| install_aspdotnetcore | false | N | true, false | Install the asp.Net core hosting package |
| dotnet_ver | 5 | N | 5, 6 | Define the .net version to use |
| iis_app_pool_name | 'DefaultAppPool' | Y | | The name of the app pool to create or update and associate with the site|
| Customiiswebapppoolneeded | false | N | true, false | If custom apppoll is needed |

#Custom Needs
  #Customiiswebapppoolneeded: "true" #True or False It will be called in Runtime. 
  #ServiceAccountUsername: "administrator" #It will be called in Runtime.
  #ServiceAcccountPassword: "********" #It will be called in Runtime.

Role Variables
--------------

ansible-playbook --vault-password-file=/etc/ansible/.vault_pass --extra-vars '@pass.yml' /etc/ansible/playbooks/main.yml -vvv -e dotnet_ver=6 -e install_aspdotnetcore=true -e install_dotnet_hosting=true -e Customiiswebapppoolneeded=false

For Custom Config :
ansible-playbook --vault-password-file=/etc/ansible/.vault_pass --extra-vars '@pass.yml' /etc/ansible/playbooks/main.yml -vvv -e dotnet_ver=6 -e install_aspdotnetcore=true -e install_dotnet_hosting=true -e Customiiswebapppoolneeded=true -e ServiceAccountUsername=administrator -e ServiceAcccountPassword=xxxxxxxxx



Use the following variables to create or update the app pool used by the site:

- iis_app_pool_attributes: Additional attributes for configuration of the app pool; default is '', which will not specify any additional attributes.

Use the following variables to configure basic IIS site options:

- iis_site_name: Name of the IIS site; default is 'Default Web Site'.
- iis_site_id: Numeric site ID, can only be specified when creating a new site; default is '', which omits the site ID.
- iis_site_ip: IP address to listen for connections; default is '*', which listens on all addresses.
- iis_site_port: Port to listen for connections; default is 80.
- iis_site_ssl: Enable the site to handle SSL traffic; default is false. Use the binding options below to specify the hostname, protocol and certificate information for the SSL site.
- iis_site_hostname: Primary hostname for the site, default is '', which will respond to any hostname not configured for another site on the same IP and port.
- iis_site_path: Directory containing the files served by this site, will be created if it does not yet exist. Default is 'C:\inetpub\wwwroot', which is the usual default path configured when IIS is installed.
- iis_site_parameters: Additional parameters for site configuration; default is '', which will not specify any additional parameters.
- iis_site_state: The state of the site; default is 'started'. 'absent' may be used to remove a site.
- iis_site_web_config: Local path to a Jinja template that will be used to create a web.config file in iis_site_path. Default is "", which does not create a web.config file.
- iis_site_web_config_force: Always write a web.config file even if one already exists; default is true.

Use the following variables to specify additional hostnames, addresses or ports where the site should be served. The iis_binding_* variables provide defaults for all bindings that may be override for each item in iis_bindings.

- iis_binding_host_header: Additional hostname for bindings, default is ''.
- iis_binding_ip: Additional IP address to listen for connections; default is '*'.
- iis_binding_port: Additional port to listen for connections; default is 80.
- iis_binding_protocol: Protocol to use for connections; default is 'http'. Supported values are 'http', 'https' and 'ftp'.
- iis_binding_state: The state of the binding; default is 'present'. Use 'absent' to remove a binding.
- iis_binding_certificate_store_name: Certificate store name containing SSL certificate; default is 'My'.
- iis_binding_certificate_hash: Certificate hash of SSL certificate; default is '', which doesn't specify a certificate.
- iis_bindings: A list of items specifying site bindings, where each item may use any of the following keys to override the defaults above:
  - host_header
  - ip
  - port
  - protocol
  - state
  - certificate_store_name
  - certificate_hash

Use the following variables to override the filesystem permissions set on the site path:

- iis_acl_path: Path to update ACL, default is iis_site_path. Specify "" (an empty string) to skip ACL updates.
- iis_acl_user: IIS user group; default is 'IIS_IUSRS'.
- iis_acl_rights: Rights to assign to user or group; default is 'FullControl'.
- iis_acl_type: ACL type; default is 'allow'.
- iis_acl_state: ACL state; default is 'present'.
- iis_acl_inherit: ACL inheritance options; default is 'ContainerInherit, ObjectInherit'.
- iis_acl_propagation: ACL propagation options; default is 'None'.

Dependencies
------------

TODO: Figure out if we should have a dependecy on windows features

Example Playbook
----------------
```
- hosts: windows
  vars_prompt:
    - name: "app_pool_password"
      prompt: "Enter password for app pool identity: "
      private: yes

  roles:
    - role: install-iis #remove 'Default Web Site'
      iis_site_name: 'Default Web Site'
      iis_site_state: absent

    - role: install-iis #add 'Firm.Api' webapp
      dotnetver: '5.0.15'
      iis_site_name: 'Firm.Api'
      iis_site_path: 'C:\websites\Firm.Api'
      iis_app_pool_name: 'Firm.Api'
      iis_app_pool_attributes:
        - managedPipelineMode: Integrated
        - processModel.identityType: ApplicationPoolIdentity
        - processModel.userName: 'srv_firm_app@universal.co'
        - processModel.password: '{{app_pool_password}}'
        - processModel.loadUserProfile: false
      iis_binding_ip: '*'
      iis_bindings:
        - port: 80
        - ip: '*'
        - protocol: 'http' #SSL Term at F5

```

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).

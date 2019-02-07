# consulting-lab

A repository containing collection of resources used by consultants in their lab environments.  


RH Consultants are often faced with the situation where they need to test and lab with quite extensive scenarios that requires a customer like environment and should interact with many different components.
Things like:
- Locked down networks and proxies
- High Availability and 
- IdM/LDAP authentication
- Doing things at scale

While most of the stuff you find in here can be used adhoc, there is also an idea of spinning up a complete lab in short amount of time.  
The lab is based around the idea that you have a very _large_ host that will act as your hypervisor, firewall, proxy for the virtual networks.    
As of right now this is performed with libvirt and iptables and configured using multiple Ansible roles in combination.  

The goal is for you to be able to describe the labenvironment in a configuration file and press the button.   
For the automation we use ansible. We model the environment using ansible variables.    
Since it's a lot to configure we try to keep the defaults sensible and plenty.  

You find more in-depth instructions on how to create your own lab below (or link?)

## Roles in this repository

| role                   | description                                                    |
| ---------------------- | -------------------------------------------------------------- |
| cdnmirror              | sets up a simple CDN mirror on a VM                            |
| reposync               | creates a rhel7 repomirror on the labhost                      |
| hetzner-post-provision | role used for post provision tasks                             |
| hetzner-provision      | initial provision tasks when hetzner machine is in rescue mode |
| iptables               |
| knockd                 |
| libvirt                |
| libvirt_network        |
| mdadm-sync             |
| motd                   | sets a motd on the target machine                              |
| openvpn                | sets up a static openvpn server                                |
| reboot                 | reboots the target machine and waits for it come back          |
| rhel-iso-download      |
| subman                 |
| users                  | creates local users                                            |
| squid                  | install a squid proxy                                          |
| vm-template            | creates an up-to-date rhel7.6 template image                   |
| vm-create		 | creates VM's using template created by vm-template		  |

## Setup you environment in inventory/labenv

Were trying out the concept of merging two files to become a flattend inventory.
It consists of two parts: the `inventory/labenv` and the `inventory/connections`.

`inventory/labenv` is in the YAML format, which allows us to add lists and dicts in a nicer way than INI files.
For some it's nicer to keep the whole environment within one file, instead of spreading it out over group_vars and host_vars.  
However, each to his own and nothing stopping you from using the separate vars folders.


`inventory/connections` is manipulated by the `vm-create` role.  
When it creates a new host, the connection details are added here for future connections!
More on that later.

### inventory/labenv

Ansible reads variables from multiple places before a playbook run.  
You can define them in the inventory, the group_vars, host_vars, vars inside the playbook and withing the role vars/.  
If there are conflicting vars from the different sources, the reverse order of the above applies. [Variable precedence](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#variable-precedence-where-should-i-put-a-variable)
When the playbook runs, the variables are read in and then flattened.

The same thing can kinda be said about inventories. They can come from several files and will at run time be flattened into a single inventory.

`inventories/labenv` is a place to define your lab environment if you want.  
As seen with [openshift-ansible](https://github.com/openshift-ansible/) for instance it can be used to define both nodes and the variables that control the setup of the OpenShift cluster.  
You can think if the inventory/labenv in the same way.  
Since we might end up with quite a lot lists and dictionaries for the setup, it can makes sense to use the YAML format instead. 

We start by defining all the _required_ vars to get an lab environment in the way it's intended.
```

all:
  vars:
    # for the subman role. Used by both the labhost and potential vm's
    # necessary in order to sync Red Hat repositories which are used to create a baseline VM template
    rh_username: consultant@redhat.com
    rh_password: supersecret
    
    # users role. Creates users on both the labhost and the VM template
    users:
    - name: labuser
      public_key: "ssh-rsa AAAAB3NzaC1yU+olD43JLpDj35L+vx02TvVScBhseSWwCCsATZBxEpIg5bXF6WjJL8PTzNA+xY5+OoPM1d+JasFb28M+Gxj9pjD4xFT/MR5Rvaor/GiooX+7jxZubi6b0sEfvkgLkCol2y69ptAhIEAk+qzKwBVseuyGjOQrjbK0KQXFy6xfOyFZwqK/ofz"
    
    # libvirt_networks roles. Define the virtual networks that should be created
    libvirt_networks:
    - name: mgmt
      type: open_network
      subnet: 10.5.0.0/24
    
    - name: net1
      type: open_network
      subnet: 10.101.0.0/24
    
    - name: net2
      type: open_network
      subnet: 10.102.0.0/24
```
In INI style this would look like:
```
[all:vars]
rh_username="consultant@redhat.com"
rh_password="supersecret"

users=[{name=labuser,public_key=ssh-rsa AAAAB3NzaC1yU+olD43JLpDj35L+vx02TvVScBhseSWwCCsATZBxEpIg5bXF6WjJL8PTzNA+xY5+OoPM1d+JasFb28M+Gxj9pjD4xFT/MR5Rvaor/GiooX+7jxZubi6b0sEfvkgLkCol2y69ptAhIEAk+qzKwBVseuyGjOQrjbK0KQXFy6xfOyFZwqK/ofz"}

libvirt_networks=[{name="mgmt",type="open_network",subnet="10.5.0.0/24"},{name="net1",type="open_network",subnet="10.101.0.0/24"},{name="net2",type="open_network",subnet="10.102.0.0/24"}]
```

Virtual Machines:

Add VM's to the following section.
These are recorded as host entries in the ansible inventory just like you would do with any host.
Here we put the host entires under the group `vms:`.

_with INI style, this would look like:_ 
```
[vms]
host1

The difference here is that they do not exist _yet_. 
Once created, they will end up in the `inventory/connections` file with correct connection information.

During the VM creation, the `vm-create` role looks for certain _hostvars_.
Here we assign variables _under_ the host object.
If you assign an ipaddress, this will be given to the VM statically and then used with the host object in `inventory/connections`.

``` 
  #####################
  # Virtual Machines
  #####################
  children:
    vms:
      hosts:
        host1:
          name: "host1"
          cpu: "1"
          memory: "2048"
          network: "mgmt"
          ip_address: "10.5.0.21"
```
In INI style it would look like
```
[vms]
host1 name="host1",cpu="1",memory="2048",network="mgmt",ip_address="10.5.0.21"

``

WIP: Not implemented. And not sure it's a good idea yet.
 we can also define any roles within this repositories that should be executed on the VM once it's up.
This is not how we normally would use Ansible, where we are used to create a playbook with `hosts:` and `roles:`.
Here we have the option of running roles on any VM we create and in that way create a baseline of sorts.
It works the way that `vm-create` 
So this is somewhat of a hack, but enable

NOTE: You can then run the `adhoc/create-all-vms.yml` playbook to create all VM's found in the VM group.

### inventory/connections

This is file is dynamically controlled by the vm-create role.
After we've created a VM we want to be able to run future playbooks to it.
Since it's during bootstrap and we don't have any DNS in place and we might be running the setup from a host that can't directly reach the virtual networks we have this a workaround.

At the top we have 
```
[vms:vars]
ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p -q labhost" -o ServerAliveInterval=300 -o ServerAliveCountMax=2 -o StrictHostKeyChecking=no'
```

This variables forces Ansible to use the labhost as a jumpserver to reach the VM's that we create.

When the vm-create role runs, it will add a host entry to the `[vms]` group automatically.
We will then be able to connect to VM either right away, or on our next playbook run without touching anything.

```
[vms:vars]
ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p -q labhost" -o ServerAliveInterval=300 -o ServerAliveCountMax=2 -o StrictHostKeyChecking=no'

[vms]
myvm1 ansible_
```

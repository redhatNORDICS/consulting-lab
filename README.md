# consulting-lab
A repository containing resources used by consultants in their lab environments

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


## Setup you environment in inventory/labenv

Trying out the concept of merging two files to become a flattend inventory.
It consists of two parts: the `inventory/labenv` and the `inventory/connections`.

`inventory/connections` is manipulated by the `vm-create` role.  
When it creates a new host, the connection details are added here for future connections!

`inventory/labenv` is in the YAML format, which allows us to add lists and dicts in a nicer way than INI files.  
And to some it's nicer to keep the whole environment within one file, instead of spreading it out over group_vars and host_vars.  
However, each to his own and nothing stopping you from using the separate vaars folders.

Add VM's to the following section: 
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

You can then run the `adhoc/create-all-vms.yml` playbook to create these hosts.


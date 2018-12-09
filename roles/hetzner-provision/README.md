hetzner-provision
=========

use this role to automate the OS installation of your hetzner server.
It will write a config file and run the installmedia script against it.
Once complete, it will reboot the server and you can continue with actually configuring your lab.

Requirements
------------

Make sure to include your public key of the ansible host using the Hetzner interface.
Hetzner installer will add it automatically to the provision

Role Variables
--------------

The hetzner installer  expects you to edit a installer configuration file before running the installer.
This role will automate that step, but we still need to provide the essentials, being:
- The partitioning table
- The hostname of the lab host

These have default values set, but can be overridden. 

Default hostname is: `labhost`. 
If you do have a primary domain set, then the domain will be appended. (not implemented)

By default the role configures LVM in RAID 1 mode.
It create a volume group called vg_rhel
```
partion table:
/boot - 512mb ext4 
/     - 20gb lvm/xfs 
/root - 2gb lvm/xfs
/home - 20gb lvm/xfs
swap  - 10gb 
/var  - the remainder
```
Most of the space is allocated to /var since it's where libvirt will allocate most of it's stuff.

If you don't want the default you have to specify your own.
Easiest right now is to modify the template `roles/hetzner-provision/templates/hetzner.config

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: username.rolename, x: 42 }

License
-------

BSD

Author Information
------------------
Red Hat Nordics


libvirt
=======

This role is to setup and manage the KVM part of the labhost.
It does the following:
- Configure libvirt and ensure it's running
- Adds users to the proper groups so libvirt/qemu can be used with your user credentials
  External role dependency to the users role setup.
- Opens necessary ports so you can 


## Networks

To configure the networks we use a seperate role `libvirt_networks` <link>.

## Users

This role expects that a `users:` list has been defined.
We do this in the `config`/`common` role.
So one would typically set up a playbook with the libvirt role after the common/config:

```
- hosts: labhost
  roles:
  - config
  - libvirt
```







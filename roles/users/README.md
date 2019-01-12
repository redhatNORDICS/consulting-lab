Labhost Users
=============

Yet-another-users role. 

Meant to be kept as simple as possible. (possibly: and to be used with all the VM's you spin up.)

Creates the list of users on the machine, deploys the ssh keys, gives them sudoers privs.
Defaults to putting the user into sudoers with NOPASSWD

*Run this before the ssh role* as it will disable root login
*Also, before hardening as it .. *

Requirements
------------

Any pre-requisites that may not be covered by Ansible itself or the role should be mentioned here. For instance, if the role uses the EC2 module, it may be a good idea to mention in this section that the boto package is required.

Role Variables
--------------

Looks for the `users` list, containing a user dict.

`name:` 	Name and uid for the user  
`sudo:` 	(default: true)  
`nopasswd:` 	(default: true)  
`public_key:`	(string) the public key of the user. Will be added to authorized_keys 
		Should be formatted like: `ssh-rsa A4AAT3NzaC1yc2EAAAADAQABAAABAQCy7mCSSm7Nh1pA2WuurTdbGmiY6RyqxbAXNMZAo9df/kHwJIfFKQQIoZPyvgfbW3P+hoFTL1x1SkOFQLSKCGg6DIQwMhbxMMkhUvoeg8mMiGikdD3uPGqlWb0gjf8HaWhyaFsmwUSrC6WqgAsd9nHF682Cx4yU+olD43JLpDj35L+vx02TvVScBhseSWwCCsATZBxEpIg/BtMyT5bXF6WjJL8PTzNA+xY5+OoPM1d+JasFb28M+Gxj9pjD4xwweorihweetAhIEAk+qzKwBVseuyGjOQrjbK0KQXFy6xfOyFZwqK/ofz`  

```
users:
- name: rhconsultant1
  sudo: true
  nopasswd: true
  public_key: "ssh-rsa A4AAT3NzaC1yc2EAAAA..."

- name: rhconsultant2
  public_key: "ssh-rsa A4AAT3NzaC1yc2EAAAA..."
```
Dependencies
------------

A list of other roles hosted on Galaxy should go here, plus any details in regards to parameters that may need to be set for other roles, or variables that are used from other roles.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

```
# playbook.yml

- hosts: labhost
  roles:
  - users
```
```
# group_vars/labhost
users:
- name: rhconsultant1
  sudo: true
  nopasswd: true
  public_key: "ssh-rsa A4AAT3NzaC1yc2EAAAA..."
```

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).

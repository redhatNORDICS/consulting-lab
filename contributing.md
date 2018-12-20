Contributing (WIP)
============

Everyone is encouraged to contribute in order to build the best personal lab possible.
If you find that you need to run some specific techk or that you need to modify your lab in a certain way, there is a good chance that others might do too. 

Important to have in mind that the roles and playbooks we contribute here should be built with the Consultant Lab in mind.
It should easily be consumed within the Lab Environment. 

and to use the available helper tools whenever possible (such as the virtual machine role).
If you find that the support role doesn't cover your use case, try to expand it instead of creating a workaround in your role.

Bonus points if you provide a teardown playbook! 

PR against master
-----------------

.. and always keep master in a working state. 
When 

Style Guide
-----------

- Remove role folders from the role directory if they are not used?
  
- prefix your role vars with something smart
  If your role is configuring an OpenShift environment and is called `ocp`, then `ocp_` would be a good candidate.. (wow obvious) 
  Imagine that the role variables will be overridden on the playbook level where many different variables are mixed.
  It's nice to easily be able to distinguish what role the variable belongs to:
```
# /my.lab.env
---
- hosts: labhost
  vars:
    labhost_hostname: labhost
    labhost_domain: example.com
    fw_strict: true
    squid_port: 8080
    fw_flavour: iptables
    ocp_version: 3.9
    ocp_use_satellite: true

  roles:
  - labhost
  - fw
  - squid
  - satellite
  - ocp 
```

Different Ansible versions
--------------------------

When working on your role, it's good to include the Ansible version you have used to test.
There can be subtle differences in modules from version to version, and should one need to troubleshoot why something is acting up it's a good lead if the ansible versions differ.

Just include it somewhere in the README.md of the role. 
```
ansible --version
ansible 2.7.2
```
Ansible Versions tested: 2.7.2, 2.4

Testing
-------

Bah, idk


RFE/Issues/Bugs
----------

We use the github issue tracker. If you notice a bug and don't have a PR for it, please open a GitHub issue for it.
Please be both verbose and consice about it. Include log output etc. 

Should you see an issue and know how to fix it/implement the feature, just drop a comment that you are working on it.
This way we can team up better.


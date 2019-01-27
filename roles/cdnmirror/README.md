cdnmirror
=========

A role that sets up a simple mirror of CDN content

The role is intended to be run on a small dedicated VM

Role Variables
--------------

Variables that needs to be set are

* rh_username
* rh_password

Repos to sync can be overridden with the repos variable

```
repos: rhel-7-server-rpms rhel-7-server-extras-rpms rhel-7-server-rh-common-rpms
```

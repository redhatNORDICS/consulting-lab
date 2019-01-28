cdnmirror
=========

A role that sets up a simple mirror of CDN content

The role is intended to be run on a small dedicated VM

Role Variables
--------------

**Mandatory** variables that needs to be set are

| variable    | default value |
| ----------- | ------------- |
| rh_username | null          |
| rh_password | null          |



Repos to sync can be overridden with the repos variable

| variable | default value                                                             |
| -------- | ------------------------------------------------------------------------- |
| repos    | rhel-7-server-rpms rhel-7-server-extras-rpms rhel-7-server-rh-common-rpms |

Example how to override

```
repos: rhel-7-server-rpms rhel-7-server-extras-rpms rhel-7-server-rh-common-rpms 
```

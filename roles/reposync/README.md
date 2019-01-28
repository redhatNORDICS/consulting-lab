Labhost Reposync
================

Role to sync RHEL repo and publish it within your lab environment.

The original purpose of this is to provide the latest rhel-7-server-rpms to the VM template.  
So that when we create our template VM, it will be fully updated during the kickstart <link to ks and row>.

Also, if you don't plan to use Satellite in your environment, this is could be your poor-mans Satellite keeping the Red Hat repos locally in your environment. But right now this role is not really suited for that purpose. Have a look at [opuk.repomgmt](https://gitlab.com/opuk/opuk.repomgmt) instead.

Based on [Rydekull/redhat-repo-creator](https://github.com/Rydekull/redhat-repo-creator) and [opuk.repomgmt](https://gitlab.com/opuk/opuk.repomgmt).

The role should work for both CentOS and RHEL, but it requires that subscription-manager is registered and have attached a valid subscription that provides entitlement for RHEL.  
This is taken care of by the [`subman` role](/roles/subman/)

What it does
============
The role is split into 2 _phases_, because the reposync is long running job which can easily take up to 30 mins to complete (~4.5GB rpms). 
So to complete the reposync you have to call on this role twice but with different tags. 
First by using it with the tag `setup` and later when we have completed all the inbetween steps that we want to do, we call on it again with the tag `final`. 

```
- hosts: labhost
  roles:
  - subman
  - reposync
    tags: setup
  - inbetween-role1 
  - inbetween-role2
  - reposync
    tags: final
```

_This funcionality of only running final when supplying the tag `final` is done with the special tag [`never`](https://docs.ansible.com/ansible/latest/user_guide/playbooks_tags.html#special-tags)`

# main.yml 

Installs apache and repo utilities. 

Ensures that `rhel-7-server-rpms` repo is enabled.  

Configures Apache to publish the repo.  

Performs a reposync with _only_ the latest packages of `rhel-7-server-rpms`  
_Since this is a long running job we want to detach from this long running job and continue with different tasks. 
We do this with:_
```
- name: start reposync
  command: reposync -p "/var/www/html/pub/repos/" --repoid=rhel-7-server-rpms -m -n
  async: 5
  poll: 0
  register: reposync_job

```
_We register the job in the var `reposync_job`.  
This way we can catch it at the end of our playbook run and perform the last steps in the final.yml.


# final.yml

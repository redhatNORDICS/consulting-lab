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
------------
The role is split into 2 _phases_, because the reposync is long running job which can easily take up to 30 mins to complete (~4.5GB rpms). 
So to complete the reposync you have to call on this role twice but with different `phase:` values. 
First by using it with the `phase: setup` and later when we have completed all the inbetween steps that we want to do, we call on it again with  `phase: final`.  
_Note: Tags may seem as the go-to functionality for this sorta thing. But as there is no way (afaik) to set a tag from the playbook itself. It has to bu supplied on the commandline. Ultimatly this means we can't use tags for calling the role sequenced as we want._

```
- hosts: labhost
  roles:
  - subman
  - role: reposync
    vars:
      phase: setup
  - inbetween-role1 
  - inbetween-role2
  - role: reposync
    vars:
      phase: final
```

### main.yml 

Launches either setup.yml or final.yml depending on the value of `phase:`

### setup.yml

Installs apache and repo utilities. 

Ensures that `rhel-7-server-rpms` repo is enabled.  

Configures Apache to publish the repo.  

Performs a reposync with _only_ the latest packages of `rhel-7-server-rpms`  
_Since this is a long running job we want to detach from this long running job and continue with different tasks. 
We do this with:_
```
- name: start reposync
  command: reposync -p "/var/www/html/pub/repos/" --repoid=rhel-7-server-rpms -m -n
  async: 7200
  poll: 0
  register: reposync_job

```
We register the job in the var `reposync_job`.  
This way we can catch it at the end of our playbook run and perform the last steps in the final.yml.


### final.yml

Waits in the async job to complete.

```
# (300*10)/60=50min
- name: Wait for the reposync job to finish
  async_status: 
    jid: "{{ reposync_job.ansible_job_id }}"
  register: job_result
  until: job_result.finished
  retries: 300
  delay: 10 
```

Then run the `createrepo` utility to create the required metadata.

End result
----------

When the role have been run with both sequences you should have a rhel-7-server-repo published on the labhost itself.  
`http://localhost/repos/rhel-7-server-rpms/`

Note that we do not add any iptable rules for this.  The repo is not served publically but only to the lab environment.  
Any host on any libvirt network we create are allowed to talk to their gateway, where the repo is served.

So one can now configure a yum repo on the gateway address. 
```
# network: mgmt
# ip: 10.15.0.124
# gw: 10.15.0.1

# cat /etc/yum.repos.d/labhost.repo
[labhost-rhel7]
name=labhost-rhel7
baseurl=http://10.15.0.1/rhel-7-server-rpms/
enabled=1
gpgcheck=0


# yum repolist
Loaded plugins: product-id, search-disabled-repos, subscription-manager
This system is not registered with an entitlement server. You can use subscription-manager to register.
repo id                                                                                               repo name                                                                                              status
labhost-rhel7                                                                                         labhost-rhel7                                                                                          5,375
repolist: 5,375
```


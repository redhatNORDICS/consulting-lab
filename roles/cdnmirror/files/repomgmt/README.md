
## Description

repomgmt is a simple frontend for reposync and createrepo.



## Installation steps

Copy files from this repository:
```
bin/*            => /usr/bin/
sbin/*           => /usr/local/sbin/
sysconfig/*      => /etc/sysconfig/
share/repomgmt/* => /usr/share/repomgmt/
```
Remember to make all scripts executable.


## System configuration

Add excludes to /etc/yum.conf to your liking, for instance:

```
exclude=*i686,abrt*,libreoffice*,firefox*,kde-wallpapers,kde-l10n*,inkscape,gimp*,virt-p2v*noarch,xulrunner
```

## Example usage

### step 1

Configure ```proxy_hostname```, ```proxy_port```, ```proxy_user```, ```proxy_password``` in ```/etc/rhsm/rhsm.conf```.


### step 2

Register your system and list available subscriptions:
```
subscription-manager register
subscription-manager list --available > subscription-list.txt
subscription-manager unregister
```


### step 3

Find the pool ID to be consumed in subscription-list.txt.
Edit ```/etc/sysconfig/repoconfig``` so that:
- REPO_LIST matches the list of repositories to dump
- ARC_USR matches your access.redhat.com username
- ARC_PWD matches your access.redhat.com passwd
- ARC_POOL matches the pool to be consumed.

### step 4

Install dependencies:
```
yum -y install yum-utils httpd createrepo python-mako
```


### step 5

Launch ```repo-sync.sh```, ```repo-cleanup.sh``` and ```repo-createrepo.sh``` to download the packages


## Notes

* always use ```update.sh``` instead of ```yum update``` to update the system hosting the repositories
* publishing the resulting repositories can be done with genyumrepofiles.py (see bin/ and share/repomgmt) provided you have a working DNS
  

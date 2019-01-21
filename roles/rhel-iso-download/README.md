RHEL ISO Download
=================

Small role to download a RHEL ISO from Red Hat CDN. 
It requires that the host it runs on is registered with subscription-manager and attached a subscription that provde the proper entitlements for downloading the ISO.
The entitlement that is required is simply Red Hat Enterprise Linux. 

This step is taken care of by the `subman`role (link). 
We can make this role include this role by default, but we are not doing this right now. 
Instead you have to make sure that this role is called after subman

```
- hosts: labhost
  become: true
  roles:
  - subman
  - rhel-iso-download
```

Vars
----

Right now we default to download the rhel-server-7.6-x86_64.iso, but you can download a different iso by overriding the var `image_file`. 
```
image_file: rhel-server-7.4-x86_64-dvd.iso
```

The default download destination is `/var/lib/libvirt/images/`. You can override this with the var `image_destination:`. 
```
image_destination: /home/me/isos/
image_file: rhel-server-7.4-x86_64.iso
```


There is a adhoc playbook for you to use that shows how to run this role independently: 
link to ahdoc



```
subscription-manager 

```



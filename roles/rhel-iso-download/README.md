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

Right now, the default file to download is `rhel-server-7.6-x86_64.iso`, but you can download a different image by overriding the var `image_filename`.  
Suggestions:  
- rhel-server-7.5-x86_64-dvd.iso  
- rhel-server-7.4-x86_64-dvd.iso  
- rhel-server-7.6-x86_64-kvm.qcow2  

```
image_filename: rhel-server-7.4-x86_64-dvd.iso
```

The default download destination is `/var/lib/libvirt/images/`.  
You can override this with the var `image_dest_dir:`
```
image_dest_dir: /home/me/isos/
image_filename: rhel-server-7.4-x86_64.iso
```

Asyncronous download is disabled by default, but can be turned on with `rhel_iso_async:`  
```
image_dest_dir: /home/me/isos/
image_filename: rhel-server-7.4-x86_64.iso
rhel_iso_async: true
```

There is a adhoc playbook for you to use that shows how to run this role independently: 
[download_iso.yml](/adhoc/download_iso.yml)




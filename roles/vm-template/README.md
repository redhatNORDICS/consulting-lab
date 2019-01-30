Labhost vm-template
===================

This role will create an up to date RHEL7.6 image that can be used as an template for new VM's.
It's created using the RHEL 7 boot.iso and the local repository created by [`reposync`](roles/reposync/).
The process is fully automated with a Kickstart [file](roles/vm-template/templates/rhel.ks). 

Once complete you can use the image with libvirt clone.  
The image should be prepared with the users supplied with the [`users` role](roles/users/).  
So if you've supplied a `public_key:` for your user, it should be in the user authorized_keys, meaning that you can SSH to your clone right away and you can configure it using Ansible.

Usage
-----

Checkout the [adhoc playbook](adhoc/create-vm-template.yml) of how to use it.  

The role requires that [`subman`](roles/subman/) and [`reposync`](roles/reposync/) completes.

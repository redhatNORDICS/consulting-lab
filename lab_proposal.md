# Consultant Lab on OVH/Hetzner

As platform consultants I believe many of us have done the task of setting up a Lab environment in one of the providers.
One requires quite a lot of computing power (relativly speaking) to run a complete OCP cluster + additional resources such as Satellite, Ansible Tower etc.

Allthough fun exercise, it's a time consuming task and I do believe we all started to write some playbooks/roles to automate it.
So why not combine our strength?

## Why? 

It's fun!
It's  very, very useful!
All can collectly contribute.

I want to think of it as a sort of new start for collab in Nordics, a project where all invited to contribute and share
and each can bring their own experiences.
Imagine if this should take off properly, and we could take it further to say an OCP like repo.. how you can spin up different OCP setups within the lab.

## The vision

A Nordic Hailstorm of sorts.. but with a large focus on the lab!
The possibility to rent a server from Hetzner or OVH and quickly setup a fully functioning Lab environment.
Ansible repository that contains different levels.
The first one being: Setting up the Lab. 

Prepping the Hypervisor with:
- subman (if rhel) 
- common packages
- KVM/libvirt:
  - networks
  - user rights
  - volume dir
- ssh
- OpenVPN / knockd + routing/NAT
- basic hardening

Additional levels that could be thrown in etc. 
- PXE server / repomgmt (bicycle) 
- Satellite
- IDM
- Ansible Tower

More heavy roles like:
- RHEV
- OSP
- OCP 

## Some interesting challenges

Standard way to describe the virtual env:
How networks should be designed

Standard way to provision new Hosts in the virtual  env:
Satellite?
Or when you wanna opt out of Satellite,
virt-install magic

many more?


## Structure

The repo lives at github.com/redhatNORDICS/.
Everyones can submit PR's, gotta have one reviewer.



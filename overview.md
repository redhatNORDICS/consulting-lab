# Consulting Lab

The Red Hat Nordics Consultant lab.
This repo contains a set of ansible playbooks and roles that will configure a bare-metal server from a chosen provider into a fully fledged lab environment.
The Lab environment should consist of a KVM hypervisor and an environment that similates what most of us see from day to day at our customers such as restricted and dedicated networks, HTTP proxy.
It should also provide you with a way to securely connect to it wherever you are (VPN and knock porting).

The different components are provided as ansible roles and you can choose what you want to use.
Eg. you might not want to setup the HTTP proxy lockdown, so don't include it in your playbook.

## Overview

The Lab is built on top of a dedicated server in one of the providers.
It acts as the Hypervisor, Firewall, Edge Router and VPN.

### libvirt
The most basic and straightforward setup is to use libvirtd, but you should be able to choose additional Virtualization Platforms (RHEV, OSP).

(choose a setup for RHEV and OSP either directly ontop of the Labhost or nested virtualization)

### Network

_Replace with a proper diagram_ 
```
                                     
                                   |                  _ ??? 
                             ______|____             |
                        _____|         |             |_ infra/mgmt (172.y.y.y/yy)
Internet -----------    |eth0| iptables|      virt_br|
                        |____| /pfsense|             |_ ocp (172.x.x.x/xx)
                             |_________|             |
                                   | squid           |_ public ( 35.46.57.66/30 )  
                                   | openvpn
```

# Setup

Build up your playbook, and in the end your environment, using the roles that this repo provides.
It helps to think of it in different layers.
1. Provider
2. Libvirt setup 
3. Network 

4. Infra resources (IdM, Satellite)

Here is an example playbook that uses different roles to setup a complete environment:

```
- hosts: labhost
  roles:
  - hetzner_provision
  - common
  - hardening
  - fw
  - openvpn
  - knockd
  - squid
  - libvirt
  - network
  - ipa

```
And we have the following in the playbook group_vars where we override the role defaults and the mandatory vars:
```
# cat group_vars/main.yml
labhost_type: hetzner
domain: mylab.org

common_extra_pkgs:
- telnet
- tree

fw_type: iptables
fw_strict: true
fw_nat: true

knockd_port_sequence: "tcp:9323,udp:8756,tcp:4325"

network_subnets:
- name: ocp
  range: 172.54.0.0/24
  
network_dns: 8.8.8.8
network_
network_satellite: true

ipa_override_libvirt_network_dns: true

```

To the playbook we have the following inventory:
```
---
[labhost]
35.65.34.12

[satellite]
satellite.
```


## Provider (Hetzner/OVH)

Choose a provider. 
For this lab setup we've focused on either Hetzner or OVH.
If you should like to roll with another provider, there shouldn't be anything stopping you from using the roles and playbooks for that.
We will see that the roles work as long as it's a EL distro and certain requirements are met.

### Hetzner

Order a server on Hetzner. 
Make sure to add your sssh public key before setup and the Hetzner installer will add it to the root .ssh/authorized_keys
After setup you will recieve the IP address of your server.
As the mail explains, it's now in the Hetzner rescue system. It's from this runtime that you configure your installation using the custom tool.
 
We have a playbook that configures this step for you: link

### OVH




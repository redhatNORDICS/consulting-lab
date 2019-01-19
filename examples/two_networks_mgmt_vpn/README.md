2 networks, 1 mgmt network, VPN
===============================

Run against a Hetzner host that has _either_ been put into Rescue/New installation mode or have been configured with a Centos7 image.

The playbook will set up your host with Centos7 and installs the basics, configures users and installs and configures OpenVPN.

After VPN has been configured it will install and configure libvirt and 3 virtual networks that are by default locked down.

At the end of playbook run you should be able to get started with provisioning VM's.

Last step (yet to be implemented) is to shut the door for wide open SSH, and requires you to use the VPN from now on. 

How to use this example
-----------------------

***Clone the repo to your workstation or from where you want to run the playbook from and then enter the example dir.***
```
$ git clone https://github.com/redhatNORDICS/consulting-lab.git
Cloning into 'consulting-lab'...
remote: Enumerating objects: 144, done.
remote: Total 144 (delta 0), reused 0 (delta 0), pack-reused 144
Receiving objects: 100% (144/144), 33.54 KiB | 2.10 MiB/s, done.
Resolving deltas: 100% (29/29), done.

$ cd consulting-lab/examples/two_networks_mgmt_vpn/
```

***Make sure that labhost is resolvable:***

The inventory consist of one host, labhost
``` 
# ./inventory
labhost

```

_Either_, add the ip address of your labhost directly in the ansible inventory file:
```
# ./inventory

labhost ansible_host=12.13.14.15
```

***or***, add the alias in your /etc/hosts file. This might come in handy when you wanna ssh and whatnot later. 
```
# /etc/hosts

12.13.14.15 labhost
```

***Modify the group_vars/labhost***

- Set the network ranges you want to use
- Add your user to the user dict, including your pub key
```
users:
- name: me
  public_key: "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDVCzcQ24XJE9lW92mLNmOOXQXC8bDgaC7JmUKbv2kKh6+AIPnWuIXBuU+zVJrrgzmFT8eiqseOAB6jKNv0VcC1oq6vbeDoSBEaSlh2d+mbWIapYsVYW6zdxq6tzvgB3nuRniblDiGlU0Dne9XRSqKJrgHG+yrK34OhdRPChVZ7AEQhjtYImCCBQpUcz15VfTXkWSDj7TKIzxhm7LuhdhRaAuM74DaYBcZideWVHFlgSTyuEYGToUl4S2ddvD+qZwiY0NOXJzezgn1SBB1UZzSGdtbVtpnZ/iGd7AbV/QlmVSrL+lm9LqknPmMCOeBGaCbEYXVNDCHe0CpB+WNojV9Z me@workstation"

```

  
**_If you want it really end to end, and want to automate the hetzner install, you can add the `hetzner-provision` role before all other roles._**
  
```
- hosts: labhost
  user: root
  gather_facts: true
  roles:
  - hetzner-provision  <------
  - role: mdadm-sync
    vars: 
      stop_sync: true
  - users
  - openvpn
  - libvirt
  - libvirt_network
  - iptables
  - knockd
  - role: mdadm-sync
    vars: 
      start_sync: true
```


Run it! 

```
$ ansible-playbook -i inventory setup_lab.yml -v
```




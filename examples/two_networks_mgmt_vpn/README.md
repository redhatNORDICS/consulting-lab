2 networks, 1 mgmt network, VPN
===============================

Bah long name.. 

Split into two playbooks.

**1st_step.yaml**:  

Run against a Hetzner host put into Rescue mode.
Sets up a Hetzner host with Centos7 and installs the basics, configures users and installs and configures OpenVPN and shuts the door.

**2st_step.yaml**:
After VPN has been configured the next step requires you to be connected to the VPN. 
It run against the OpenVPN gateway instead of the public ip.

This configures libvirt and the networks.
At the end of playbook run you should be able to get started with provisioning VM's.


OpenVPN
=========

Role to configure OpenVPN on the labhost

Current limitations:  
**Important that this is run before the libvirt and libvirt_network roles so that the iptables rules are added in the right order!**  
Hopefully we can make this a bit more robust in the future.

*Single client only.*  
Right now we use one secret and one client only.  
To allow more users we have to set up a proper key infra to handout multiple signed keys.  
There are many roles out that the that does the job.  
eg. https://github.com/kyl191/ansible-role-openvpn

How it works
------------

The role will configure a OpenVPN server, the client configuration and create a secret that is used when connecting.
Forwarding will be configured so that the VPN network (`openvpn_network:`) can reach all networks.  
The server and client config will pick up the `libvirt_networks` and add them as routes in the configs.  
The virtual networks however must however configure the FORWARD rules when they are created, but this `libvirt_network` does this for you.  
So in this way the openvpn role and the libvirt_network role depend on each otheres variables to be specified.   
And due to the FORWARD rules, it's important that the openvpn role is run before the libvirt_networks.  

Client config and the secret will be copied over to your ansible host and be placed in:
 `~/openvpnconfig/<inventory hostname>/`

If you are using NetworkManager, you can simply import this vpn config.  
**You may want to enable the `Use this connection only for resources on its network` option to only route traffic meant for the labenvironment through the VPN.**

Requirements
------------

Any pre-requisites that may not be covered by Ansible itself or the role should be mentioned here. For instance, if the role uses the EC2 module, it may be a good idea to mention in this section that the boto package is required.

Role Variables
--------------

Overridable defaults:  
`openvpn_network`: The network that you want OpenVPN to allocate. Default is set to 10.99.99.0  
`openvpn_network_gw`: The address OpenVPN will use for the server and the next-hop for the client. Default is set to 10.99.99.1  
`openvpn_network_client`: The address OpenVPN client will use. Default is set to 10.99.99.2  

Dependencies
------------

A list of other roles hosted on Galaxy should go here, plus any details in regards to parameters that may need to be set for other roles, or variables that are used from other roles.

Example Playbook
----------------

NOTE: openvpn before the libvirt_networks

The role defaults will do, you don't have to specify any vars for it to work. 

```
- hosts: labhost
  roles:
  - openvpn
  - libvirt
  - libvirt_networks
```

Group vars example where both openvpn and libvirt_networks vars are present:

```
# group_vars/labhost
libvirt_networks:
- name: mgmt
  type: nat_network_dhcp
  address: 10.0.0.0
  interface_address: 10.0.0.1
  netmask: 255.255.255.0
  prefix: 24
  dhcp_range_start: 10.0.0.100
  dhcp_range_stop: 10.0.0.254

- name: ocp
  type: nat_network_dhcp
  address: 192.168.132.0
  interface_address: 192.168.132.1
  netmask: 255.255.255.0
  prefix: 24
  dhcp_range_start: 192.168.132.2
  dhcp_range_stop: 192.168.132.254

openvpn_network: 192.168.10.0
openvpn_network_gw: 192.168.10.1
openvpn_network_client: 192.168.10.2

```

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).

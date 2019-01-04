libvirt_network
===============

Tested Ansible version: 
- 2.7.2

Requires: libxml

Role to configure and manage the libvirt netowrks.
See the libvirt role for configuring libvirt/KVM on the labhost, which should be run prior to using this role.

- Configures the virtual networks
  You can choose between different network "types". 
- Integrates with the firewall role. (wip)

## Network

As desribed in <insert link here>, libvirt_network creates the networks and the bridges that your VM's connect to.
The labhost/KVM host acts as the gateway to all these networks.
You can choose between X different network modes.

Libvirt uses dnsmasq for DHCP and DNS management. 
You can use and configure these using the `libvirt_network['dhcp']` and `libvirt_network['dns'].
Especially interesting is the option to specify a PXE boot server. This is very useful for Satellite scenarios where you want to do your provisioning using Satellite and PXE. 

## Firewall integraiton

WIP

## Network definition Variables 

`libvirt_networks: ` This is the list that the role loops over to create the networks. Each entry is a dictionary containing mandatory and optional variables.
The vars are as follows:

`name:` The name of the network. You will see this in your virt console. We also use this to name the interface(?) 
`type:` Choose the network type. Decides what template file to use. Right now you can choose between:
- `nat_network_dhcp` NAT network with DHCP.
- `nat_network` NAT network without DHCP
- `isolated_network` Isolated network. You have to setup a proxy to reach external resources.

`interface_address:` The IP of the gateway. Used to determine the subnet range.
`netmask:` (optional) Defaults to 255.255.255.0. Have to specify decimal mask, prefix not supported.





One single network:
```
libvirt_networks:
- name: default
  type: nat_network_dhcp
  interface_address: 192.168.122.1
  dhcp_range_start: 192.168.122.2
  dhcp_range_stop: 192.168.122.254
  netmask: 255.255.255.0
```

Two networks (different types):
libvirt_networks:
- name: default
  type: nat_network_dhcp
  interface_address: 192.168.122.1
  dhcp_range_start: 192.168.122.2
  dhcp_range_stop: 192.168.122.254
  netmask: 255.255.255.0

- name: mgmt 
  type: nat_network
  interface_address: 192.168.122.1
  dhcp_range_start: 192.168.122.2
  dhcp_range_stop: 192.168.122.254
```



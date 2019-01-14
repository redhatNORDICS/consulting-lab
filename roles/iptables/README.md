Labhost iptables
================

Creates the basic structure of keeping networks restricted.

The idea here is that we use "Open" networks with libvirt, and then create the forwarding ourselves.
Each network will have Chains for the incoming traffic from each network.


The math becomes 
```
n = no. of libvirt_networks
amount of chains = n * ( n - 1)

```

So if you have three networks:
- mgmt
- net1
- net2

The following FORWARD chains will be created:
net1-to-mgmt: Traffic flowing from net1 to mgmt
net2-to-mgmt: Traffic flowing from net2 to mgmt

mgmt-to-net1: Traffic flowing from mgmt to net1
net2-to-net1: Traffic flowing from net2 to net1

mgmt-to-net2: Traffic flowing from mgmt to net2
net1-to-net2: Traffic flowing from net1 to net2


These chains comes empty, so by default nothing is Opened.
When we do want to allow a specific port from one network to the other, we can simply append it to the proper chain.
Say we want open for a webserver on mgmt to hosts on net1, we can do the following:
```
iptables -A net1-to-mgmt -d 10.15.0.50 -p tcp -m tcp --dport 80 -j ACCEPT -m comment --comment "Allow port 80"
```

Labhost knockd
==============

Normally we want to use the VPN connection to access our environment.
But this is not always possible unfortunatly.
There are many client sites that doesn't allow connecting to external VPN's on their networks.

To still access our closed down environment port-knocking is very useful.
The idea here is that you "knock" on a set of ports in certain sequence and something will happen.
In our case we want to open up SSH for the knocking IP.

The door is left open for small window of time, but enough for you to establish as SSH connection.
And our iptables allows established connections.


Ahh, but not all clients allow outgoing ssh connections either.. 
Usually this block is on port level. No outgoing traffic on port 22.
Therefor you can with this role configure an additional SSH port that hopefully isn't blocked.
The default here is to use port 443. (we are not running a webserver on the labhost right?)


Requirements
------------

The labhost needs access to repos containing the following packages (if RHEL, the role will enabled Optional repo):
- libpcap-decel
- gcc
- rpm-build


and an internet connection to download the knockd source.

Role Variables
--------------

The role as of now does not allow much customization.  
If you have a need for something additional, please go ahead and make a PR.

You configure the sequence by using the following vars.  
`knockd_nic` has a default set to `{{ ansible_default_ipv4.interface }}`.  
You have to configure the sequence however! 

```
knockd_nic: "eth1"
knockd_1seq: "1234:udp"
knockd_2seq: "1234:tcp"
knockd_3seq: "1234:udp"
```
In the use-case described above when you can't even connect out on port 22 and want to use a more common port that might not be blocked you can specify:  
`knockd_ssh_alternate_port: 443 `

This will append the port to the SSH config so the sshd daemon listens on both 22 and the one you've specified.


Dependencies
------------

A list of other roles hosted on Galaxy should go here, plus any details in regards to parameters that may need to be set for other roles, or variables that are used from other roles.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: labhost
      roles:
      - knockd
      

Using port-knocking after setup
===============================

After running the role it should've configured knockd to be running and listening on the given sequence.
To try it out you can use the following script:  
```
#udp port
nc -z --send-only -u labhost 1234 -v
#tcp port
nc -z --send-only labhost 4234  -v
#udp port
nc -z --send-only -u labhost 1234 -v
ssh user@labhost 

```

Looking at the syslog we can see the following happening when running it:
```
Jan 04 21:45:13 labhost knockd[2064]: 94.100.100.100: opencloseSSH: Stage 1
Jan 04 21:45:14 labhost knockd[2064]: 94.100.100.100: opencloseSSH: Stage 2
Jan 04 21:45:14 labhost knockd[2064]: 94.100.100.100: opencloseSSH: Stage 3
Jan 04 21:45:14 labhost knockd[2064]: 94.100.100.100: opencloseSSH: OPEN SESAME
Jan 04 21:45:14 labhost knockd[2081]: opencloseSSH: running command: /sbin/iptables -I INPUT 1 -s 94.100.100.100 -p tcp --dport ssh -j ACCEPT
Jan 04 21:45:24 labhost knockd[2081]: 94.100.100.100: opencloseSSH: command timeout
Jan 04 21:45:24 labhost knockd[2081]: opencloseSSH: running command: /sbin/iptables -D INPUT 1
```

It adds the iptables rule and allows our IP on port 22. 
(need to add the additional port aswell... --dports )
After the 10second timeout, it runs the iptables rule deletiong sealing the door behind it.


Allright, now you can get onto the Labhost and can ssh everywhere and set up tunnels.
Here is a sshuttle command that will.. WIP


License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).

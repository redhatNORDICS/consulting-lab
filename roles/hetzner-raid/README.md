mdadm sync stop/start
=================

When you reprovision your hetzner host, the first thing you are going to notice is 
that it's performing very slowly. This is due to md resyncing your raid setup.

You don't really have time for it to do this right now, so you wanna pause it and let it catch up after your are done with your changes. 

This role does just that.

Use it like this

```
- name: pause the mdadm sync
  import_role:
    name: hetzner-raid
  vars:
    stop_sync: true

... do all the things


- name: resume the sync
  import_role:
    name: hetzner-raid
  vars:
    start_sync: true
```

Role Name
=========

Simple role to handle reboots.
Using ansible `wait_for_connection` to determine when the host is up again

Based on https://github.com/opuk/ansible-opuk-reboot

Role Description & Usage
----------------

When included in a play, the target host will be rebooted.
During the reboot, the ansible control node will start polling for SSH to be available again using `wait_for_connection`.

The `wait_for_connection` is a action plugin and will always be run from the Ansible control/master node (https://github.com/ansible/ansible/issues/36519#issuecomment-367362879)
.. so it will always be your ansible node that *checks* if the server is back.

Should you need to reboot a different server from the one you `hosts: target`, then simply delegate the role to the other server with `delegate_to:`.
NOTE that it will still be the ansible control node that polls for the new target to come back. 

Should you want the check to be done by a different host than your Ansible control node,
you can do that by setting the `reboot_poller: ` variable. 
Then a SSH port check will be performed from that node to the target. 
(The reasons for this are limited.. but should you need it in say a jumpbox scenario, it could prove useful)


Requirements
------------

Role Variables
--------------

defaults: (these can be overridden anywhere)
```
# What message should be sent out on reboot
reboot_message: "Ansible triggered reboot"

# How long the maximum wait should be before giving up reconnecting (in seconds)
reboot_wait: 600

# How long to wait between every poll
reboot_sleep: 1

# How long before we start polling
reboot_delay: 20

# How long before a poll should give up
reboot_connection_timeout: 5
```

Optional:
```
# Specify which host should do the polling 
reboot_poller: jumpbox
```

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:
```

    - hosts: labhost
      roles:
         - { role: reboot, reboot_message: "It's going DOWN", reboot_wait: 1200  }

    - hosts: labhost
      tasks:
      - import_role:
          name: reboot
        vars:
          reboot_message: "It's going DOWN!"
          reboot_wait: 1200

    # Delegation, the new_vm will be rebooted and will be polled from the Ansible Control node
    - hosts: labhost
      tasks:
      - import_role:
          name: reboot
        delegate_to: "{{ new_vm }}"

    # Different poller
    - hosts: labhost
      tasks:
      - import_role:
          name: reboot
        vars:
          reboot_poller: my_jumpbox 

```

License
-------

BSD

Author Information
------------------

Red Hat Nordics


# System authorization information
auth --enableshadow --passalgo=sha512
# Use network installation
url --url="http://172.199.199.1/rhel-7-server-rpms/"
# Use graphical install

# Run the Setup Agent on first boot
firstboot --disable
ignoredisk --only-use=sda
# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'
# System language
lang en_US.UTF-8

# Network information
network  --bootproto=dhcp --device=eth0 --activate
network  --hostname=template.example.com

# Root password
rootpw --iscrypted $6$FWK/vE66ZMLsfZgT$Jxc8VK9aJhfxb30O5kFITOLlQnZHTejchdBznjOKpUJVgLp45z/PNI/Qd7efqd6dcU0x./QnAwuVN/4NkR31X0
# System services
services --disabled="chronyd"
# System timezone
timezone Europe/Stockholm --isUtc --nontp
# System bootloader configuration
bootloader --append=" crashkernel=auto" --location=mbr --boot-drive=sda
autopart --type=lvm
# Partition clearing information
clearpart --none --initlabel
shutdown

%packages
@^minimal
@core
kexec-tools

%end

%addon com_redhat_kdump --enable --reserve-mb='auto'

%end

%anaconda
pwpolicy root --minlen=6 --minquality=1 --notstrict --nochanges --notempty
pwpolicy user --minlen=6 --minquality=1 --notstrict --nochanges --emptyok
pwpolicy luks --minlen=6 --minquality=1 --notstrict --nochanges --notempty
%end
%post
{% for user in users %}
useradd {{ user.name }}
mkdir /home/{{ user.name }}/.ssh
echo '{{ user.public_key }}' >> /home/{{ user.name }}/.ssh/authorized_keys
chown {{ user.name }}:{{ user.name }} -R /home/{{ user.name }}/.ssh/
chmod 0600 /home/{{ user.name }}/.ssh/authorized_keys
chmod 0700 /home/{{ user.name }}/.ssh/
echo "{{ user.name }} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/users 
{% endfor %}
%end


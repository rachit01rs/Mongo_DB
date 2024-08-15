

--------------------------------------------------------------------------
----------------------------rabin/rabin123---------------------------------
--------------------------------------------------------------------------
-- 1 All Nodes on VM (Server Storage)
root@percona-mongodb-pri:~# df -Th
/*
Filesystem                        Type   Size  Used Avail Use% Mounted on
tmpfs                             tmpfs  388M  1.5M  387M   1% /run
/dev/mapper/ubuntu--vg-ubuntu--lv xfs     24G  8.1G   16G  34% /
tmpfs                             tmpfs  1.9G     0  1.9G   0% /dev/shm
tmpfs                             tmpfs  5.0M     0  5.0M   0% /run/lock
/dev/mapper/ubuntu--vg-data_lv    xfs     24G  204M   24G   1% /data
/dev/sda2                         xfs    2.0G  301M  1.7G  15% /boot
tmpfs                             tmpfs  388M  4.0K  388M   1% /run/user/1000

*/

-- 1 All Nodes on VM (Server Kernal version)
root@percona-mongodb-pri:~# uname -msr
/*
Linux 5.15.0-118-generic x86_64
*/

-- 1 All Nodes on VM (Server Release)
root@percona-mongodb-pri:~# cat /etc/lsb-release
/*
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=22.04
DISTRIB_CODENAME=jammy
DISTRIB_DESCRIPTION="Ubuntu 22.04.4 LTS"
*/

-- 1 All Nodes on VM (Server Release)
root@percona-mongodb-pri:~# cat /etc/os-release
/*
PRETTY_NAME="Ubuntu 22.04.4 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.4 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
*/


-- Step 1 -->> On All Nodes
root@percona-mongodb-pri:~# vi /etc/hosts
/*
127.0.0.1 localhost
127.0.1.1 mongodb

# Public
192.168.120.7 percona-mongodb-pri.com percona-mongodb-pri
192.168.120.9 percona-mongodb-sec.com percona-mongodb-sec
192.168.120.10 percona-mongodb-arb.com percona-mongodb-arb
*/

-- Step 2 -->> On Node 1 (Ethernet Configuration)
root@percona-mongodb-pri:~# vi /etc/netplan/00-installer-config.yaml
/*
# This is the network config written by 'subiquity'
network:
  ethernets:
    ens33:
      addresses:
      - 192.168.120.7/24
      nameservers:
        addresses:
        - 8.8.8.8
        search: []
      routes:
      - to: default
        via: 192.168.120.254
  version: 2
*/

-- Step 2.1 -->> On Node 2 (Ethernet Configuration)
root@percona-mongodb-sec:~# vi /etc/netplan/00-installer-config.yaml
/*
# This is the network config written by 'subiquity'
#
network:
  ethernets:
    ens33:
      addresses:
      - 192.168.120.9/24
      nameservers:
        addresses:
        - 8.8.8.8
        search: []
      routes:
      - to: default
        via: 192.168.120.254
  version: 2
*/

-- Step 2.2 -->> On Node 3 (Ethernet Configuration)
root@percona-mongodb-arb:~# vi /etc/netplan/00-installer-config.yaml
/*
# This is the network config written by 'subiquity'
network:
  ethernets:
    ens33:
      addresses:
      - 192.168.120.10/24
      nameservers:
        addresses:
        - 8.8.8.8
        search: []
      routes:
      - to: default
        via: 192.168.120.254
  version: 2
*/

-- Step 3 -->> On All Nodes (Restart Network)
root@percona-mongodb-pri:~# systemctl restart network-online.target

-- Step 4 -->> On All Nodes (Set Hostname)
root@percona-mongodb-pri:~# hostnamectl | grep hostname
/*
 Static hostname: percona-mongodb-pri.com/percona-monogdb-sec.com/percona-mongodb-arb.com
*/

-- Step 4.1 -->> On All Nodes
root@percona-mongodb-pri:~# hostnamectl --static
/*
percona-mongodb-pri.com.np
*/

-- Step 4.2 -->> On All Nodes
root@percona-mongodb-pri:~# hostnamectl
/*
 Static hostname: percona-mongodb-pri.com
 Pretty hostname: perconadb_pri.com
       Icon name: computer-vm
         Chassis: vm
      Machine ID: a14a33f5a7f245adabbcbf2997c4c128
         Boot ID: 19aa05cb83414f878506872fdc753a4c
  Virtualization: vmware
Operating System: Ubuntu 22.04.4 LTS
          Kernel: Linux 5.15.0-118-generic
    Architecture: x86-64
 Hardware Vendor: VMware, Inc.
  Hardware Model: VMware Virtual Platform


*/
 

 -- Step 4.3 -->> On Node 1
root@percona-mongodb-pri:~# hostnamectl set-hostname percona-mongodb-pri.com

-- Step 4.3.1 -->> On Node 2
root@percona-mongodb-pri:~# hostnamectl set-hostname percona-mongodb-sec.com 

-- Step 4.3.2 -->> On Node 3
root@percona-mongodb-pri:~# hostnamectl set-hostname percona-mongodb-arb.com

-- Step 4.4 -->> On Node 1
root@percona-mongodb-pri:~# hostnamectl
/*
 Static hostname: percona-mongodb-pri.com
       Icon name: computer-vm
         Chassis: vm
      Machine ID: a14a33f5a7f245adabbcbf2997c4c128
         Boot ID: 55ea40c512cf428081243b5dbec7bb14
  Virtualization: vmware
Operating System: Ubuntu 22.04.4 LTS
          Kernel: Linux 5.15.0-118-generic
    Architecture: x86-64
 Hardware Vendor: VMware, Inc.
  Hardware Model: VMware Virtual Platform

*/

-- Step 4.4.1 -->> On Node 2
root@percona-mongodb-sec:~#  hostnamectl
/*
 Static hostname: percona-mongodb-sec.com
       Icon name: computer-vm
         Chassis: vm
      Machine ID: 792e932f6dbb4ff28ae3b899e622bf26
         Boot ID: bbfb4b66fe8a480fb3160f60719db77c
  Virtualization: vmware
Operating System: Ubuntu 22.04.4 LTS
          Kernel: Linux 5.15.0-118-generic
    Architecture: x86-64
 Hardware Vendor: VMware, Inc.
  Hardware Model: VMware Virtual Platform


*/

-- Step 4.4.2 -->> On Node 3
root@percona-mongodb-arb:~# hostnamectl
/*
 
 Static hostname: percona-mongodb-arb.com
       Icon name: computer-vm
         Chassis: vm
      Machine ID: ee1264b631bf4a6ab541de52e5dce266
         Boot ID: 8501fdd0b2c142579437fb0ad4f56f80
  Virtualization: vmware
Operating System: Ubuntu 22.04.4 LTS
          Kernel: Linux 5.15.0-118-generic
    Architecture: x86-64
 Hardware Vendor: VMware, Inc.
  Hardware Model: VMware Virtual Platform


*/



-- Step 5 -->> On All Nodes (IPtables Configuration)
root@percona-mongodb-pri/percona-monogdb-sec/percona-mongodb-arb:~# iptables -F
root@percona-mongodb-pri/percona-monogdb-sec/percona-mongodb-arb:~# iptables -X
root@percona-mongodb-pri/percona-monogdb-sec/percona-mongodb-arb:~# iptables -t nat -F
root@percona-mongodb-pri/percona-monogdb-sec/percona-mongodb-arb:~# iptables -t nat -X
root@percona-mongodb-pri/percona-monogdb-sec/percona-mongodb-arb:~# iptables -t mangle -F
root@percona-mongodb-pri/percona-monogdb-sec/percona-mongodb-arb:~# iptables -t mangle -X
root@percona-mongodb-pri/percona-monogdb-sec/percona-mongodb-arb:~# iptables -P INPUT ACCEPT
root@percona-mongodb-pri/percona-monogdb-sec/percona-mongodb-arb:~# iptables -P FORWARD ACCEPT
root@percona-mongodb-pri/percona-monogdb-sec/percona-mongodb-arb:~# iptables -P OUTPUT ACCEPT
root@percona-mongodb-pri/percona-monogdb-sec/percona-mongodb-arb:~# iptables -L -nv

root@percona-mongodb-pri:~# ifconfig
/*

ens33: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.120.7  netmask 255.255.255.0  broadcast 192.168.120.255
        inet6 fe80::20c:29ff:fe54:ee0d  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:54:ee:0d  txqueuelen 1000  (Ethernet)
        RX packets 864  bytes 374403 (374.4 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 707  bytes 90631 (90.6 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 274  bytes 25875 (25.8 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 274  bytes 25875 (25.8 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0


*/

-- Step 5.1 -->> On Node 2
root@percona-mongodb-sec:~# ifconfig
/*
ens33: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.120.9  netmask 255.255.255.0  broadcast 192.168.120.255
        inet6 fe80::20c:29ff:fe81:6b14  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:81:6b:14  txqueuelen 1000  (Ethernet)
        RX packets 3101  bytes 4066160 (4.0 MB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 1475  bytes 133393 (133.3 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 230  bytes 20093 (20.0 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 230  bytes 20093 (20.0 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0


*/

-- Step 5.2 -->> On Node 3
root@percona-mongodb-arb:~# ifconfig
/*

ens33: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.120.10  netmask 255.255.255.0  broadcast 192.168.120.255
        inet6 fe80::20c:29ff:fea8:b523  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:a8:b5:23  txqueuelen 1000  (Ethernet)
        RX packets 3102  bytes 4066883 (4.0 MB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 1233  bytes 124179 (124.1 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 231  bytes 20176 (20.1 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 231  bytes 20176 (20.1 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0



*/

-- Step 6 -->> On All Nodes (Firew Configuration)
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~# apt install firewalld

-- Step 6.1 -->> On All Nodes
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~# systemctl enable firewalld

-- Step 6.2 -->> On All Nodes
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~# systemctl start firewalld


-- Step 6.3 -->> On All Nodes
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~# systemctl status firewalld
/*
 ● firewalld.service - firewalld - dynamic firewall daemon
     Loaded: loaded (/lib/systemd/system/firewalld.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2024-08-13 04:43:47 UTC; 22s ago
       Docs: man:firewalld(1)
   Main PID: 1638 (firewalld)
      Tasks: 2 (limit: 4513)
     Memory: 24.1M
        CPU: 233ms
     CGroup: /system.slice/firewalld.service
             └─1638 /usr/bin/python3 /usr/sbin/firewalld --nofork --nopid

Aug 13 04:43:47 percona-mongodb-pri.com systemd[1]: Starting firewalld - dynamic firewall daemon...
Aug 13 04:43:47 percona-mongodb-pri.com systemd[1]: Started firewalld - dynamic firewall daemon.

*/

-- Step 6.4 -->> On All Nodes
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~# sudo firewall-cmd --zone=public --add-port=27017/tcp --permanent
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~# sudo firewall-cmd --zone=public --add-port=27017/udp --permanent
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~# sudo firewall-cmd --zone=public --add-port=22/tcp --permanent
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~# sudo firewall-cmd --zone=public --add-port=22/udp --permanent

-- Step 6.5 -->> On All Nodes
rroot@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~#  firewall-cmd --list-all
/*
public
  target: default
  icmp-block-inversion: no
  interfaces:
  sources:
  services: dhcpv6-client ssh
  ports:
  protocols:
  forward: yes
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:

*/

-- Step 7 -->> On All Nodes (Server ALL RMP Updates)
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~# sudo apt update && sudo apt upgrade -y

-- Step 8 -->> On All Nodes (Selinux Configuration)
-- Making sure the SELINUX flag is set as follows.
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~# sudo apt install policycoreutils selinux-basics selinux-utils -y
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~# sudo selinux-activate
/*
Activating SE Linux
Sourcing file `/etc/default/grub'
Sourcing file `/etc/default/grub.d/init-select.cfg'
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-5.15.0-118-generic
Found initrd image: /boot/initrd.img-5.15.0-118-generic
Found linux image: /boot/vmlinuz-5.15.0-113-generic
Found initrd image: /boot/initrd.img-5.15.0-113-generic
Found linux image: /boot/vmlinuz-5.15.0-94-generic
Found initrd image: /boot/initrd.img-5.15.0-94-generic
Warning: os-prober will not be executed to detect other bootable partitions.
Systems on them will not be added to the GRUB boot configuration.
Check GRUB_DISABLE_OS_PROBER documentation entry.
done
SE Linux is activated.  You may need to reboot now.

*/

-- Step 8.1 -->> On All Nodes
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~# getenforce
/*
Disabled
*/

-- Step 8.2 -->> On All Nodes
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~# sestatus
/*
SELinux status:                 disabled
*/

-- Step 8.3 -->> On All Nodes
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~# init 6
-- Step 8.4 -->> On Node 1
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~# vi /etc/selinux/config
/*
# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
# enforcing - SELinux security policy is enforced.
# permissive - SELinux prints warnings instead of enforcing.
# disabled - No SELinux policy is loaded.
SELINUX=permissive
# SELINUXTYPE= can take one of these two values:
# default - equivalent to the old strict and targeted policies
# mls     - Multi-Level Security (for military and educational use)
# src     - Custom policy built from source
SELINUXTYPE=default

# SETLOCALDEFS= Check local definition changes
SETLOCALDEFS=0
*/



-- Step 8.5 -->> On Node 1
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~# getenforce
/*
Permissive
*/

-- Step 8.6 -->> On Node 1
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~# sestatus
/*
SELinux status:                 enabled
SELinuxfs mount:                /sys/fs/selinux
SELinux root directory:         /etc/selinux
Loaded policy name:             default
Current mode:                   permissive
Mode from config file:          permissive
Policy MLS status:              enabled
Policy deny_unknown status:     allowed
Memory protection checking:     requested (insecure)
Max kernel policy version:      33

*/

-- Step 9 -->> On Node 1
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~# firewall-cmd --list-all
/*
public
  target: default
  icmp-block-inversion: no
  interfaces:
  sources:
  services: dhcpv6-client ssh
  ports: 27017/tcp 27017/udp 22/tcp 22/udp
  protocols:
  forward: yes
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:

*/

-- Step 10 -->> On Node 1
root@percona-mongodb-pri:~# hostnamectl
/*
 Static hostname: percona-mongodb-pri.com
       Icon name: computer-vm
         Chassis: vm
      Machine ID: a14a33f5a7f245adabbcbf2997c4c128
         Boot ID: 118803c7b7314f899c74eebe6b8b9cb8
  Virtualization: vmware
Operating System: Ubuntu 22.04.4 LTS
          Kernel: Linux 5.15.0-118-generic
    Architecture: x86-64
 Hardware Vendor: VMware, Inc.
  Hardware Model: VMware Virtual Platform

*/

-- Step 10.1 -->> On Node 2
root@percona-mongodb-sec:~# hostnamectl
/*
 Static hostname: percona-mongodb-sec.com
 Pretty hostname: perconadb_sec.com
       Icon name: computer-vm
         Chassis: vm
      Machine ID: a42817fff3b04812b8a276524fc3c296
         Boot ID: 8609faf181e549208a3de77c46c31e1b
  Virtualization: vmware
Operating System: Ubuntu 22.04.4 LTS
          Kernel: Linux 5.15.0-118-generic
    Architecture: x86-64
 Hardware Vendor: VMware, Inc.
  Hardware Model: VMware Virtual Platform


*/

-- Step 10.2 -->> On Node 3
root@percona-mongodb-arb:~# hostnamectl
/*
 Static hostname: percona-mongodb-arb.com
 Pretty hostname: perconadb_arb.com
       Icon name: computer-vm
         Chassis: vm
      Machine ID: 7231d7c3b1d74454bc948564b792ed84
         Boot ID: d0c98c769798487294791a3b3f17a92a
  Virtualization: vmware
Operating System: Ubuntu 22.04.4 LTS
          Kernel: Linux 5.15.0-118-generic
    Architecture: x86-64
 Hardware Vendor: VMware, Inc.
  Hardware Model: VMware Virtual Platform


*/

-- Step 11 -->> On All Nodes (Assign role to mongodb User)
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~# sudo adduser mongodb
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~# sudo usermod -aG sudo mongodb

-- Step 11.1 -->> On All Nodes 
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~# sudo usermod -aG root mongodb

-- Step 11.2 -->> On All Nodes 
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~# rsync --archive --chown=mongodb:mongodb ~/.ssh /home/mongodb

-- Step 11.3 -->> On Node 1
root@percona-mongodb-pri:~# ssh mongodb@192.168.120.7
/*
The authenticity of host '192.168.120.7 (192.168.120.7)' can't be established.
ED25519 key fingerprint is SHA256:2zlb1Jp0RD6jNdihrktAVHE9xD9o9LWPERmCX5mLsEE.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '192.168.120.7' (ED25519) to the list of known hosts.
mongodb@192.168.120.7's password:
Welcome to Ubuntu 22.04.4 LTS (GNU/Linux 5.15.0-118-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Tue Aug 13 05:06:09 AM UTC 2024

  System load:  0.0                Processes:              249
  Usage of /:   36.5% of 23.98GB   Users logged in:        1
  Memory usage: 12%                IPv4 address for ens33: 192.168.120.7
  Swap usage:   0%

 * Strictly confined Kubernetes makes edge and IoT secure. Learn how MicroK8s
   just raised the bar for easy, resilient and secure K8s cluster deployment.

   https://ubuntu.com/engage/secure-kubernetes-at-the-edge

Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status


*/

-- Step 11.3.1 -->> On Node 2
root@percona-mongodb-sec:~# ssh mongodb@192.168.120.9
/*
The authenticity of host '192.168.120.9 (192.168.120.9)' can't be established.
ED25519 key fingerprint is SHA256:2zlb1Jp0RD6jNdihrktAVHE9xD9o9LWPERmCX5mLsEE.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '192.168.120.9' (ED25519) to the list of known hosts.
rabin@192.168.120.9's password:
Welcome to Ubuntu 22.04.4 LTS (GNU/Linux 5.15.0-118-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Mon Aug 12 06:46:45 AM +0545 2024

  System load:  0.0                Processes:              270
  Usage of /:   58.5% of 23.98GB   Users logged in:        1
  Memory usage: 14%                IPv4 address for ens33: 192.168.120.9
  Swap usage:   0%

 * Strictly confined Kubernetes makes edge and IoT secure. Learn how MicroK8s
   just raised the bar for easy, resilient and secure K8s cluster deployment.

   https://ubuntu.com/engage/secure-kubernetes-at-the-edge

Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

1 additional security update can be applied with ESM Apps.
Learn more about enabling ESM Apps service at https://ubuntu.com/esm


Last login: Mon Aug 12 06:39:43 2024 from 192.168.120.1


*/

-- Step 11.3.2 -->> On Node 3
root@percona-mongodb-arb:~# ssh mongodb@192.168.120.10
/*
he authenticity of host '192.168.120.10 (192.168.120.10)' can't be established.
ED25519 key fingerprint is SHA256:2zlb1Jp0RD6jNdihrktAVHE9xD9o9LWPERmCX5mLsEE.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '192.168.120.10' (ED25519) to the list of known hosts.
rabin@192.168.120.10's password:
Welcome to Ubuntu 22.04.4 LTS (GNU/Linux 5.15.0-118-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Mon Aug 12 06:48:12 AM +0545 2024

  System load:  0.0                Processes:              270
  Usage of /:   58.6% of 23.98GB   Users logged in:        1
  Memory usage: 14%                IPv4 address for ens33: 192.168.120.10
  Swap usage:   0%

 * Strictly confined Kubernetes makes edge and IoT secure. Learn how MicroK8s
   just raised the bar for easy, resilient and secure K8s cluster deployment.

   https://ubuntu.com/engage/secure-kubernetes-at-the-edge

Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

1 additional security update can be applied with ESM Apps.
Learn more about enabling ESM Apps service at https://ubuntu.com/esm


Last login: Mon Aug 12 06:39:44 2024 from 192.168.120.1

*/

-- Step 11.4 -->> On All Nodes
mongodb@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~$ exit

-- Step 12 -->> On All Nodes (LVM Partition Configuration - Before Status)
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~# df -Th
/*
Filesystem                        Type   Size  Used Avail Use% Mounted on
tmpfs                             tmpfs  388M  1.6M  387M   1% /run
/dev/mapper/ubuntu--vg-ubuntu--lv xfs     24G   15G   10G  59% /
tmpfs                             tmpfs  1.9G     0  1.9G   0% /dev/shm
tmpfs                             tmpfs  5.0M     0  5.0M   0% /run/lock
/dev/sda2                         xfs    2.0G  301M  1.7G  15% /boot
/dev/mapper/ubuntu--vg-data_lv    xfs     24G  1.8G   23G   8% /data
tmpfs                             tmpfs  388M  4.0K  388M   1% /run/user/1000

*/

-- Step 13 -->> On Node 1 (LVM Partition Configuration - Before Status)
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~# lsblk
/*
percona-mongodb-pri# lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
loop0                       7:0    0 63.9M  1 loop /snap/core20/2105
loop1                       7:1    0   87M  1 loop /snap/lxd/29351
loop2                       7:2    0   87M  1 loop /snap/lxd/28373
loop3                       7:3    0 70.2M  1 loop /snap/powershell/269
loop4                       7:4    0 63.9M  1 loop /snap/core20/2318
loop5                       7:5    0 70.2M  1 loop /snap/powershell/271
loop6                       7:6    0 40.4M  1 loop /snap/snapd/20671
loop7                       7:7    0 38.8M  1 loop /snap/snapd/21759
sda                         8:0    0   50G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    2G  0 part /boot
└─sda3                      8:3    0   48G  0 part
  ├─ubuntu--vg-ubuntu--lv 253:0    0   24G  0 lvm  /
  └─ubuntu--vg-data_lv    253:1    0   24G  0 lvm  /data
sr0                        11:0    1 1024M  0 rom

*/

-- Step 14 -->> On All Nodes (Create Backup Directories)
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:/# mkdir -p /data/backupstore/mongodbFullBackup
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:/# chown -R mongod:mongod /data/backupstore/mongodbFullBackup/
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:/# chmod -R 775 /data/backupstore/mongodbFullBackup/


-- Step 15 -->> On All Nodes
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:/# ll  /data/backupstore/
/*
drwxr-xr-x. 3 root    root    31 Aug 13 05:11 ./
drwxr-xr-x. 3 root    root    25 Aug 13 05:11 ../
drwxrwxr-x. 2 mongod mongod  6 Aug 13 05:11 mongodbFullBackup/


*/

-- Step 16 -->> On All Nodes (Create Data/Log Directories)
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:/# mkdir -p /data/datastore/mongodb
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:/# mkdir -p /data/datastore/log
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:/# chown -R mongod:mongod /data/datastore/mongodb/
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:/# chown -R mongod:mongod /data/datastore/log/
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:/# chmod -R 777 /data/datastore/mongodb/
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:/# chmod -R 777 /data/datastore/log/

-- Step 17 -->> On All Nodes
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:/# ll /data/datastore/
/*
drwxr-xr-x. 4 root    root    32 Aug 13 05:13 ./
drwxr-xr-x. 4 root    root    42 Aug 13 05:13 ../
drwxrwxrwx. 2 mongodb mongodb  6 Aug 13 05:13 log/
drwxrwxrwx. 2 mongodb mongodb  6 Aug 13 05:13 mongod/


*/


-- Step 18 -->> On Node 1 (Verfy the ssh connection)
root@percona-mongodb-pri:~# ssh mongodb@192.168.120.7

-- Step 18.1 -->> On Node 2 (Verfy the ssh connection)
root@percona-mongodb-sec:~# ssh mongodb@192.168.120.9

-- Step 18.2 -->> On Node 3 (Verfy the ssh connection)
root@percona-mongodb-arb:~# ssh mongodb@192.168.120.10
--------------------------------------------------------------------------------------------------------------------------------------------
Configuration of Percona server for Mongodb

-- Step 19 -->> On All Nodes (Configure Percona repository)
-- Step 19.1 -->> On All Nodes (Fetch percona-release packages from Percona web)
mongodb@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~$ sudo wget https://repo.percona.com/apt/percona-release_latest.$(lsb_release -sc)_all.deb
/*
--2024-08-13 05:16:15--  https://repo.percona.com/apt/percona-release_latest.jammy_all.deb
Resolving repo.percona.com (repo.percona.com)... 147.135.54.159, 2604:2dc0:200:69f::2
Connecting to repo.percona.com (repo.percona.com)|147.135.54.159|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 16510 (16K) [application/x-debian-package]
Saving to: ‘percona-release_latest.jammy_all.deb’

percona-release_latest.jammy_all.deb   100%[=========================================================================>]  16.12K  --.-KB/s    in 0s

2024-08-13 05:16:16 (246 MB/s) - ‘percona-release_latest.jammy_all.deb’ saved [16510/16510]

*/


-- Step 19.2 -->> On All Nodes (Install the downloaded package with dpkg:)
mongodb@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~$ sudo dpkg -i percona-release_latest.$(lsb_release -sc)_all.deb
/*
Selecting previously unselected package percona-release.
(Reading database ... 149095 files and directories currently installed.)
Preparing to unpack percona-release_latest.jammy_all.deb ...
Unpacking percona-release (1.0-29.generic) ...
Setting up percona-release (1.0-29.generic) ...
grep: /etc/apt/sources.list.d/percona*: No such file or directory
ERROR: Invalid filename format: percona*
* Enabling the Percona Release repository
Get:1 http://security.ubuntu.com/ubuntu jammy-security InRelease [129 kB]
Hit:2 http://np.archive.ubuntu.com/ubuntu jammy InRelease
Get:3 http://repo.percona.com/prel/apt jammy InRelease [18.7 kB]
Get:4 http://np.archive.ubuntu.com/ubuntu jammy-updates InRelease [128 kB]
Hit:5 http://np.archive.ubuntu.com/ubuntu jammy-backports InRelease
Get:6 http://repo.percona.com/prel/apt jammy/main amd64 Packages [654 B]
Fetched 276 kB in 2s (118 kB/s)
Reading package lists... Done
* Enabling the Percona Telemetry repository
Hit:1 http://np.archive.ubuntu.com/ubuntu jammy InRelease
Hit:2 http://repo.percona.com/prel/apt jammy InRelease
Hit:3 http://np.archive.ubuntu.com/ubuntu jammy-updates InRelease
Hit:4 http://security.ubuntu.com/ubuntu jammy-security InRelease
Get:5 http://repo.percona.com/telemetry/apt jammy InRelease [12.8 kB]
Hit:6 http://np.archive.ubuntu.com/ubuntu jammy-backports InRelease
Get:7 http://repo.percona.com/telemetry/apt jammy/main Sources [550 B]
Get:8 http://repo.percona.com/telemetry/apt jammy/main amd64 Packages [383 B]
Fetched 13.7 kB in 4s (3,746 B/s)
Reading package lists... Done
* Enabling the PMM2 Client repository
Hit:1 http://np.archive.ubuntu.com/ubuntu jammy InRelease
Hit:2 http://np.archive.ubuntu.com/ubuntu jammy-updates InRelease
Hit:3 http://security.ubuntu.com/ubuntu jammy-security InRelease
Get:4 http://repo.percona.com/pmm2-client/apt jammy InRelease [18.7 kB]
Hit:5 http://np.archive.ubuntu.com/ubuntu jammy-backports InRelease
Hit:6 http://repo.percona.com/prel/apt jammy InRelease
Hit:7 http://repo.percona.com/telemetry/apt jammy InRelease
Get:8 http://repo.percona.com/pmm2-client/apt jammy/main amd64 Packages [2,937 B]
Fetched 21.6 kB in 3s (7,213 B/s)
Reading package lists... Done
The percona-release package now contains a percona-release script that can enable additional repositories for our newer products.

Note: currently there are no repositories that contain Percona products or distributions enabled. We recommend you to enable Percona Distribution repositories instead of individual product repositories, because with the Distribution you will get not only the database itself but also a set of other componets that will help you work with your database.

For example, to enable the Percona Distribution for MySQL 8.0 repository use:

  percona-release setup pdps8.0

Note: To avoid conflicts with older product versions, the percona-release setup command may disable our original repository for some products.

For more information, please visit:
  https://docs.percona.com/percona-software-repositories/percona-release.html


*/

-- Step 19.3 -->> On All Nodes (Enable the repository:)
mongodb@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~$ sudo percona-release enable psmdb-70 release
/*
* Enabling the Percona Server for MySQL - PS 7.0 repository
Hit:1 http://security.ubuntu.com/ubuntu jammy-security InRelease
Hit:2 http://repo.percona.com/pmm2-client/apt jammy InRelease
Hit:3 http://np.archive.ubuntu.com/ubuntu jammy InRelease
Hit:4 http://repo.percona.com/prel/apt jammy InRelease
Hit:5 http://np.archive.ubuntu.com/ubuntu jammy-updates InRelease
Get:6 http://repo.percona.com/psmdb-70/apt jammy InRelease [12.8 kB]
Hit:7 http://np.archive.ubuntu.com/ubuntu jammy-backports InRelease
Hit:8 http://repo.percona.com/telemetry/apt jammy InRelease
Get:9 http://repo.percona.com/psmdb-70/apt jammy/main Sources [2,413 B]
Get:10 http://repo.percona.com/psmdb-70/apt jammy/main amd64 Packages [8,247 B]
Fetched 23.5 kB in 3s (7,444 B/s)
Reading package lists... Done


*/


-- Step 19.4 -->> On All Nodes (sudo apt update)
mongodb@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~$ sudo apt update
/*

Hit:1 http://np.archive.ubuntu.com/ubuntu jammy InRelease
Hit:2 http://np.archive.ubuntu.com/ubuntu jammy-updates InRelease
Hit:3 http://security.ubuntu.com/ubuntu jammy-security InRelease
Hit:4 http://repo.percona.com/pmm2-client/apt jammy InRelease
Hit:5 http://np.archive.ubuntu.com/ubuntu jammy-backports InRelease
Hit:6 http://repo.percona.com/prel/apt jammy InRelease
Hit:7 http://repo.percona.com/psmdb-70/apt jammy InRelease
Hit:8 http://repo.percona.com/telemetry/apt jammy InRelease


*/

-- Step 20 -->> On All Nodes (Install Percona Server for MongoDB:)
mongodb@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~$ sudo apt install percona-server-mongodb
--Note (By default, Percona Server for MongoDB stores data files in /var/lib/mongodb/ and configuration parameters in /etc/mongod.conf.)
/*
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following packages were automatically installed and are no longer required:
  linux-headers-5.15.0-1059-intel-iotg linux-image-5.15.0-1059-intel-iotg linux-intel-iotg-headers-5.15.0-1059 linux-modules-5.15.0-1059-intel-iotg
  linux-modules-extra-5.15.0-1059-intel-iotg
Use 'sudo apt autoremove' to remove them.
The following additional packages will be installed:
  libsasl2-modules-gssapi-mit percona-mongodb-mongosh percona-server-mongodb-mongos percona-server-mongodb-server percona-server-mongodb-tools
  percona-telemetry-agent
The following NEW packages will be installed:
  libsasl2-modules-gssapi-mit percona-mongodb-mongosh percona-server-mongodb percona-server-mongodb-mongos percona-server-mongodb-server
  percona-server-mongodb-tools percona-telemetry-agent
0 upgraded, 7 newly installed, 0 to remove and 2 not upgraded.
Need to get 192 MB of archives.
After this operation, 550 MB of additional disk space will be used.
Do you want to continue? [Y/n] y
Get:1 http://repo.percona.com/psmdb-70/apt jammy/main amd64 percona-mongodb-mongosh amd64 2.2.10.jammy [46.5 MB]
Get:2 http://np.archive.ubuntu.com/ubuntu jammy-updates/main amd64 libsasl2-modules-gssapi-mit amd64 2.1.27+dfsg2-3ubuntu1.2 [31.5 kB]
Get:3 http://repo.percona.com/psmdb-70/apt jammy/main amd64 percona-telemetry-agent amd64 1.0.1-1.jammy [10.1 MB]
Get:4 http://repo.percona.com/psmdb-70/apt jammy/main amd64 percona-server-mongodb-mongos amd64 7.0.12-7.jammy [31.5 MB]
Get:5 http://repo.percona.com/psmdb-70/apt jammy/main amd64 percona-server-mongodb-server amd64 7.0.12-7.jammy [73.9 MB]
Get:6 http://repo.percona.com/psmdb-70/apt jammy/main amd64 percona-server-mongodb-tools amd64 7.0.12-7.jammy [29.6 MB]
Get:7 http://repo.percona.com/psmdb-70/apt jammy/main amd64 percona-server-mongodb amd64 7.0.12-7.jammy [19.9 kB]
Fetched 192 MB in 37s (5,179 kB/s)
Preconfiguring packages ...
Selecting previously unselected package libsasl2-modules-gssapi-mit:amd64.
(Reading database ... 157658 files and directories currently installed.)
Preparing to unpack .../0-libsasl2-modules-gssapi-mit_2.1.27+dfsg2-3ubuntu1.2_amd64.deb ...
Unpacking libsasl2-modules-gssapi-mit:amd64 (2.1.27+dfsg2-3ubuntu1.2) ...
Selecting previously unselected package percona-mongodb-mongosh.
Preparing to unpack .../1-percona-mongodb-mongosh_2.2.10.jammy_amd64.deb ...
Unpacking percona-mongodb-mongosh (2.2.10.jammy) ...
Selecting previously unselected package percona-telemetry-agent.
Preparing to unpack .../2-percona-telemetry-agent_1.0.1-1.jammy_amd64.deb ...
Unpacking percona-telemetry-agent (1.0.1-1.jammy) ...
Selecting previously unselected package percona-server-mongodb-mongos.
Preparing to unpack .../3-percona-server-mongodb-mongos_7.0.12-7.jammy_amd64.deb ...
Adding system user `mongod' (UID 120) ...
Adding new group `mongod' (GID 126) ...
Adding new user `mongod' (UID 120) with group `mongod' ...
Creating home directory `/home/mongod' ...
Unpacking percona-server-mongodb-mongos (7.0.12-7.jammy) ...
Selecting previously unselected package percona-server-mongodb-server.
Preparing to unpack .../4-percona-server-mongodb-server_7.0.12-7.jammy_amd64.deb ...
Unpacking percona-server-mongodb-server (7.0.12-7.jammy) ...
Selecting previously unselected package percona-server-mongodb-tools.
Preparing to unpack .../5-percona-server-mongodb-tools_7.0.12-7.jammy_amd64.deb ...
Unpacking percona-server-mongodb-tools (7.0.12-7.jammy) ...
Selecting previously unselected package percona-server-mongodb.
Preparing to unpack .../6-percona-server-mongodb_7.0.12-7.jammy_amd64.deb ...
Unpacking percona-server-mongodb (7.0.12-7.jammy) ...
Setting up percona-mongodb-mongosh (2.2.10.jammy) ...
Setting up percona-server-mongodb-tools (7.0.12-7.jammy) ...
Setting up percona-telemetry-agent (1.0.1-1.jammy) ...
Created symlink /etc/systemd/system/multi-user.target.wants/percona-telemetry-agent.service → /lib/systemd/system/percona-telemetry-agent.service.
Setting up libsasl2-modules-gssapi-mit:amd64 (2.1.27+dfsg2-3ubuntu1.2) ...
Setting up percona-server-mongodb-mongos (7.0.12-7.jammy) ...
Setting up percona-server-mongodb-server (7.0.12-7.jammy) ...
 ** WARNING: Access control is not enabled for the database.
 ** Read and write access to data and configuration is unrestricted.
 ** To fix this please use /usr/bin/percona-server-mongodb-enable-auth.sh
Created symlink /etc/systemd/system/multi-user.target.wants/mongod.service → /lib/systemd/system/mongod.service.
Setting up percona-server-mongodb (7.0.12-7.jammy) ...
Processing triggers for man-db (2.10.2-1) ...
Scanning processes...
Scanning candidates...
Scanning linux images...

Restarting services...
Service restarts being deferred:
 systemctl restart NetworkManager.service
 systemctl restart networkd-dispatcher.service
 systemctl restart systemd-logind.service
 systemctl restart unattended-upgrades.service
 systemctl restart user@1000.service

No containers need to be restarted.

No user sessions are running outdated binaries.

No VM guests are running outdated hypervisor (qemu) binaries on this host.


*/


-- Step 21 -->> On All Nodes (Start the service)
mongodb@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~$ sudo systemctl start mongod



-- Step 22 -->> On All Nodes (Confirm that the service is running)
mongodb@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~$ sudo systemctl status mongod
/*
● mongod.service - High-performance, schema-free document-oriented database
     Loaded: loaded (/lib/systemd/system/mongod.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2024-08-13 05:26:48 UTC; 16min ago
    Process: 6693 ExecStartPre=/usr/bin/percona-server-mongodb-helper.sh (code=exited, status=0/SUCCESS)
    Process: 6710 ExecStart=/usr/bin/env bash -c ${NUMACTL} /usr/bin/mongod ${OPTIONS} > ${STDOUT} 2> ${STDERR} (code=exited, status=0/SUCCESS)
   Main PID: 6713 (mongod)
      Tasks: 33 (limit: 4513)
     Memory: 72.6M
        CPU: 7.466s
     CGroup: /system.slice/mongod.service
             └─6713 /usr/bin/mongod -f /etc/mongod.conf

Aug 13 05:26:48 percona-mongodb-pri.com systemd[1]: Starting High-performance, schema-free document-oriented database...
Aug 13 05:26:48 percona-mongodb-pri.com systemd[1]: Started High-performance, schema-free document-oriented database.
*/
-- Step 23 -->> On All Nodes (Stop/Restart the service)
mongodb@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~$ sudo systemctl stop mongod

mongodb@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~$ sudo systemctl restart mongod

-- Step 24 -->> On All Nodes (Connect to Percona Server for MongoDB)
-- Step  24.1 -->> On All Nodes (Connect to Percona Server for MongoDB instance without authentication:)

mongodb@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~$ mongosh
/*
Current Mongosh Log ID: 66baf2b64e867de625d56fd0
Connecting to:          mongodb://127.0.0.1:27017/?directConnection=true&serverSelectionTimeoutMS=2000&appName=mongosh+2.2.10
Using MongoDB:          7.0.12-7
Using Mongosh:          2.2.10

For mongosh info see: https://docs.mongodb.com/mongodb-shell/


To help improve our products, anonymous usage data is collected and sent to MongoDB periodically (https://www.mongodb.com/legal/privacy-policy).
You can opt-out by running the disableTelemetry() command.

------
   The server generated these startup warnings when booting
   2024-08-13T05:26:48.623+00:00: Access control is not enabled for the database. Read and write access to data and configuration is unrestricted. You can use percona-server-mongodb-enable-auth.sh to fix it
   2024-08-13T05:26:48.624+00:00: vm.max_map_count is too low
------


*/
 
-- Step 25 -->> On All Nodes (MongoDB Configuration)
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:/# cp -r /etc/mongod.conf /etc/mongod.conf.backup

-- Step 26 -->> On All Nodes (MongoDB Configuration)
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:/# ll /etc/ | grep mongo
/*
-rw-r--r--.  1 root root       1471 Jul 19 06:27 mongod.conf
-rw-r--r--.  1 root root       1471 Aug 13 07:03 mongod.conf.backup


*/

-- Step 27 -->> On All Nodes (MongoDB Configuration)
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:/# sudo systemctl stop mongod
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:/# vi /etc/mongod.conf
/*
# mongod.conf

# for documentation of all options, see:
#   http://docs.mongodb.org/manual/reference/configuration-options/

# Where and how to store data.
storage:
  dbPath: /data/datastore/mongodb
#  engine:
#  wiredTiger:

# where to write logging data.
systemLog:
  destination: file
  logAppend: true
  path: /data/datastore/log/mongod.log

# network interfaces
net:
  port: 27017
  bindIp: 127.0.0.1


# how the process runs
processManagement:
  timeZoneInfo: /usr/share/zoneinfo

#security:

#operationProfiling:

#replication:

#sharding:

## Enterprise-Only Options:

#auditLog:
*/

-- Step 28 -->> On Node 1 (Tuning For MongoDB)
root@percona-mongodb-pri:/# vi /etc/mongod.conf
/*
# network interfaces
net:
  port: 27017
  bindIp: 127.0.0.1,192.168.120.7
  maxIncomingConnections: 999999
*/

-- Step 28.1 -->> On Node 2 (Tuning For MongoDB)
root@percona-mongodb-sec:/# vi /etc/mongod.conf
/*
# network interfaces
net:
  port: 27017
  bindIp: 127.0.0.1,192.168.120.9
  maxIncomingConnections: 999999
*/

-- Step 28.2 -->> On Node 3 (Tuning For MongoDB)
root@percona-mongodb-arb:/# vi /etc/mongod.conf
/*
# network interfaces
net:
  port: 27017
  bindIp: 127.0.0.1,192.168.120.10
  maxIncomingConnections: 999999
*/

-- Step 29 -->> On All Nodes (Tuning For MongoDB)
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:/# ulimit -a
/*
real-time non-blocking time  (microseconds, -R) unlimited
core file size              (blocks, -c) 0
data seg size               (kbytes, -d) unlimited
scheduling priority                 (-e) 0
file size                   (blocks, -f) unlimited
pending signals                     (-i) 15045
max locked memory           (kbytes, -l) 496116
max memory size             (kbytes, -m) unlimited
open files                          (-n) 1024
pipe size                (512 bytes, -p) 8
POSIX message queues         (bytes, -q) 819200
real-time priority                  (-r) 0
stack size                  (kbytes, -s) 8192
cpu time                   (seconds, -t) unlimited
max user processes                  (-u) 15045
virtual memory              (kbytes, -v) unlimited
file locks                          (-x) unlimited


*/

-- Step 30-->> On All Nodes (Tuning For MongoDB)
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:/# ulimit -n 64000

-- Step 31 -->> On All Nodes (Tuning For MongoDB)
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:/# ulimit -a
/*
real-time non-blocking time  (microseconds, -R) unlimited
core file size              (blocks, -c) 0
data seg size               (kbytes, -d) unlimited
scheduling priority                 (-e) 0
file size                   (blocks, -f) unlimited
pending signals                     (-i) 15045
max locked memory           (kbytes, -l) 496116
max memory size             (kbytes, -m) unlimited
open files                          (-n) 64000
pipe size                (512 bytes, -p) 8
POSIX message queues         (bytes, -q) 819200
real-time priority                  (-r) 0
stack size                  (kbytes, -s) 8192
cpu time                   (seconds, -t) unlimited
max user processes                  (-u) 15045
virtual memory              (kbytes, -v) unlimited
file locks                          (-x) unlimited


*/

-- Step 32 -->> On All Nodes (Tuning For MongoDB)
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:/# echo "mongod          soft    nofile          9999999" | tee -a /etc/security/limits.conf
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:/# echo "mongod          hard    nofile          9999999" | tee -a /etc/security/limits.conf
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:/# echo "mongod          soft    nproc           9999999" | tee -a /etc/security/limits.conf
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:/# echo "mongod          hard    nproc           9999999" | tee -a /etc/security/limits.conf
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:/# echo "mongod          soft    stack           9999999" | tee -a /etc/security/limits.conf
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:/# echo "mongod          hard    stack           9999999" | tee -a /etc/security/limits.conf
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:/# echo 9999999 > /proc/sys/vm/max_map_count
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:/# echo "vm.max_map_count=9999999" | tee -a /etc/sysctl.conf
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:/# echo 1024 65530 > /proc/sys/net/ipv4/ip_local_port_range
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:/# echo "net.ipv4.ip_local_port_range = 1024 65530" | tee -a /etc/sysctl.conf

-- Step 33 -->> On All Nodes (Enable MongoDB)
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:/# systemctl enable mongod --now
/*
Synchronizing state of mongod.service with SysV service script with /lib/systemd/systemd-sysv-install.
Executing: /lib/systemd/systemd-sysv-install enable mongod

*/
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:/# /lib/systemd/systemd-sysv-install enable mongod
-- Step 34 -->> On All Nodes (Start MongoDB)
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:/# systemctl start mongod

-- Step 35 -->> On All Nodes (Verify MongoDB)
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:/# systemctl status mongod
/*
●● mongod.service - High-performance, schema-free document-oriented database
     Loaded: loaded (/lib/systemd/system/mongod.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2024-08-13 07:13:32 UTC; 1min 16s ago
   Main PID: 7566 (mongod)
      Tasks: 33 (limit: 4513)
     Memory: 71.2M
        CPU: 853ms
     CGroup: /system.slice/mongod.service
             └─7566 /usr/bin/mongod -f /etc/mongod.conf

Aug 13 07:13:32 percona-mongodb-pri.com systemd[1]: Starting High-performance, schema-free document-oriented database...
Aug 13 07:13:32 percona-mongodb-pri.com systemd[1]: Started High-performance, schema-free document-oriented database.

*/

-- Step 36 -->> On All Nodes (Begin using MongoDB)
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:/# mongosh
/*
Current Mongosh Log ID: 66bb1bf464f0092840d56fd0
Connecting to:          mongodb://127.0.0.1:27017/?directConnection=true&serverSelectionTimeoutMS=2000&appName=mongosh+2.2.10
Using MongoDB:          7.0.12-7
Using Mongosh:          2.2.10
mongosh 2.2.15 is available for download: https://www.mongodb.com/try/download/shell

For mongosh info see: https://docs.mongodb.com/mongodb-shell/

------
   The server generated these startup warnings when booting
   2024-08-13T07:13:32.621+00:00: Access control is not enabled for the database. Read and write access to data and configuration is unrestricted. You can use percona-server-mongodb-enable-auth.sh to fix it




test> show dbs;
admin   40.00 KiB
config  12.00 KiB
local   80.00 KiB
test> db.version();
7.0.12-7
test> quit()
*/

-- Step 37 -->> On All Nodes (Default DBPath)
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~# ll /var/lib/mongodb/
/*
drwxr-xr-x.  4 mongod mongod  4096 Aug 13 07:05 ./
drwxr-xr-x. 44 root   root    4096 Aug 13 05:26 ../
-rw-------.  1 mongod mongod 20480 Aug 13 07:05 collection-0-302840681315629581.wt
-rw-------.  1 mongod mongod 20480 Aug 13 07:05 collection-2-302840681315629581.wt
-rw-------.  1 mongod mongod  4096 Aug 13 07:05 collection-4-302840681315629581.wt
-rw-------.  1 mongod mongod 20480 Aug 13 07:05 collection-5-302840681315629581.wt
drwx------.  2 mongod mongod    48 Aug 13 07:05 diagnostic.data/
-rw-------.  1 mongod mongod 20480 Aug 13 07:05 index-1-302840681315629581.wt
-rw-------.  1 mongod mongod 20480 Aug 13 07:05 index-3-302840681315629581.wt
-rw-------.  1 mongod mongod  4096 Aug 13 07:05 index-6-302840681315629581.wt
-rw-------.  1 mongod mongod 20480 Aug 13 07:05 index-7-302840681315629581.wt
-rw-------.  1 mongod mongod  4096 Aug 13 07:05 index-8-302840681315629581.wt
drwx------.  2 mongod mongod   110 Aug 13 05:26 journal/
-rw-------.  1 mongod mongod 20480 Aug 13 07:05 _mdb_catalog.wt
-rw-------.  1 mongod mongod     0 Aug 13 07:05 mongod.lock
-rw-------.  1 mongod mongod    33 Aug 13 05:26 psmdb_telemetry.data
-rw-------.  1 mongod mongod 20480 Aug 13 07:05 sizeStorer.wt
-rw-------.  1 mongod mongod   114 Aug 13 05:26 storage.bson
-rw-------.  1 mongod mongod    50 Aug 13 05:26 WiredTiger
-rw-------.  1 mongod mongod  4096 Aug 13 07:05 WiredTigerHS.wt
-rw-------.  1 mongod mongod    21 Aug 13 05:26 WiredTiger.lock
-rw-------.  1 mongod mongod  1472 Aug 13 07:05 WiredTiger.turtle
-rw-------.  1 mongod mongod 53248 Aug 13 07:05 WiredTiger.wt

*/

-- Step 38 -->> On All Nodes (Default LogPath)
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~# ll /var/log/mongodb/
/*
drwxr-xr-x.  2 mongod mongod    66 Aug 13 05:26 ./
drwxrwxr-x. 11 root   syslog  4096 Aug 13 05:26 ../
-rw-------.  1 mongod mongod 88401 Aug 13 07:05 mongod.log
-rw-r--r--.  1 mongod mongod     0 Aug 13 07:13 mongod.stderr
-rw-r--r--.  1 mongod mongod   148 Aug 13 07:13 mongod.stdout

*/

-- Step 39 -->> On All Nodes (Manuall DBPath)
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~# ll /data/datastore/mongodb/
/*

drwxrwxrwx. 4 mongod mongod  4096 Aug 13 08:45 ./
drwxr-xr-x. 4 root   root      32 Aug 13 05:13 ../
-rw-------. 1 mongod mongod 20480 Aug 13 07:14 collection-0--6409478916309770768.wt
-rw-------. 1 mongod mongod 20480 Aug 13 07:14 collection-2--6409478916309770768.wt
-rw-------. 1 mongod mongod  4096 Aug 13 07:13 collection-4--6409478916309770768.wt
-rw-------. 1 mongod mongod 20480 Aug 13 07:14 collection-5--6409478916309770768.wt
drwx------. 2 mongod mongod    71 Aug 13 08:46 diagnostic.data/
-rw-------. 1 mongod mongod 20480 Aug 13 07:14 index-1--6409478916309770768.wt
-rw-------. 1 mongod mongod 20480 Aug 13 07:14 index-3--6409478916309770768.wt
-rw-------. 1 mongod mongod  4096 Aug 13 07:13 index-6--6409478916309770768.wt
-rw-------. 1 mongod mongod  4096 Aug 13 07:13 index-7--6409478916309770768.wt
-rw-------. 1 mongod mongod 20480 Aug 13 07:14 index-8--6409478916309770768.wt
drwx------. 2 mongod mongod   110 Aug 13 07:13 journal/
-rw-------. 1 mongod mongod 20480 Aug 13 07:14 _mdb_catalog.wt
-rw-------. 1 mongod mongod     5 Aug 13 07:13 mongod.lock
-rw-------. 1 mongod mongod    33 Aug 13 07:13 psmdb_telemetry.data
-rw-------. 1 mongod mongod 20480 Aug 13 07:15 sizeStorer.wt
-rw-------. 1 mongod mongod   114 Aug 13 07:13 storage.bson
-rw-------. 1 mongod mongod    50 Aug 13 07:13 WiredTiger
-rw-------. 1 mongod mongod  4096 Aug 13 07:13 WiredTigerHS.wt
-rw-------. 1 mongod mongod    21 Aug 13 07:13 WiredTiger.lock
-rw-------. 1 mongod mongod  1471 Aug 13 08:45 WiredTiger.turtle
-rw-------. 1 mongod mongod 77824 Aug 13 08:45 WiredTiger.wt


*/

-- Step 40 -->> On All Nodes (Manuall LogPath)
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~# tail -f /data/datastore/log/mongod.log
/*
{"t":{"$date":"2024-08-13T08:42:52.007+00:00"},"s":"I",  "c":"-",        "id":20883,   "ctx":"conn15","msg":"Interrupted operation as its client disconnected","attr":{"opId":66130}}
{"t":{"$date":"2024-08-13T08:42:52.007+00:00"},"s":"I",  "c":"NETWORK",  "id":22944,   "ctx":"conn18","msg":"Connection ended","attr":{"remote":"127.0.0.1:32098","uuid":{"uuid":{"$uuid":"383d96f4-09e3-4aaf-8450-367e598d0055"}},"connectionId":18,"connectionCount":4}}
{"t":{"$date":"2024-08-13T08:42:52.008+00:00"},"s":"I",  "c":"NETWORK",  "id":22944,   "ctx":"conn15","msg":"Connection ended","attr":{"remote":"127.0.0.1:32080","uuid":{"uuid":{"$uuid":"a52f937c-2bb7-4084-a4e6-ef08178b3324"}},"connectionId":15,"connectionCount":3}}
{"t":{"$date":"2024-08-13T08:42:52.008+00:00"},"s":"I",  "c":"NETWORK",  "id":22944,   "ctx":"conn17","msg":"Connection ended","attr":{"remote":"127.0.0.1:32088","uuid":{"uuid":{"$uuid":"ed0dc2ab-4d51-4ace-babf-4b3f8c4a1472"}},"connectionId":17,"connectionCount":2}}
{"t":{"$date":"2024-08-13T08:42:52.008+00:00"},"s":"I",  "c":"NETWORK",  "id":22944,   "ctx":"conn19","msg":"Connection ended","attr":{"remote":"127.0.0.1:32108","uuid":{"uuid":{"$uuid":"c78e1740-be61-46c1-b60d-1b987b28531c"}},"connectionId":19,"connectionCount":1}}
{"t":{"$date":"2024-08-13T08:42:52.008+00:00"},"s":"I",  "c":"NETWORK",  "id":22944,   "ctx":"conn16","msg":"Connection ended","attr":{"remote":"127.0.0.1:32082","uuid":{"uuid":{"$uuid":"914c6325-53fe-4981-a57a-c034f11a6002"}},"connectionId":16,"connectionCount":0}}
{"t":{"$date":"2024-08-13T08:43:33.116+00:00"},"s":"I",  "c":"WTCHKPT",  "id":22430,   "ctx":"Checkpointer","msg":"WiredTiger message","attr":{"message":{"ts_sec":1723538613,"ts_usec":116380,"thread":"7566:0x7f6b2fbcd640","session_name":"WT_SESSION.checkpoint","category":"WT_VERB_CHECKPOINT_PROGRESS","category_id":6,"verbose_level":"DEBUG_1","verbose_level_id":1,"msg":"saving checkpoint snapshot min: 131, snapshot max: 131 snapshot count: 0, oldest timestamp: (0, 0) , meta checkpoint timestamp: (0, 0) base write gen: 1"}}}
{"t":{"$date":"2024-08-13T08:44:33.124+00:00"},"s":"I",  "c":"WTCHKPT",  "id":22430,   "ctx":"Checkpointer","msg":"WiredTiger message","attr":{"message":{"ts_sec":1723538673,"ts_usec":124731,"thread":"7566:0x7f6b2fbcd640","session_name":"WT_SESSION.checkpoint","category":"WT_VERB_CHECKPOINT_PROGRESS","category_id":6,"verbose_level":"DEBUG_1","verbose_level_id":1,"msg":"saving checkpoint snapshot min: 132, snapshot max: 132 snapshot count: 0, oldest timestamp: (0, 0) , meta checkpoint timestamp: (0, 0) base write gen: 1"}}}
{"t":{"$date":"2024-08-13T08:45:33.129+00:00"},"s":"I",  "c":"WTCHKPT",  "id":22430,   "ctx":"Checkpointer","msg":"WiredTiger message","attr":{"message":{"ts_sec":1723538733,"ts_usec":129733,"thread":"7566:0x7f6b2fbcd640","session_name":"WT_SESSION.checkpoint","category":"WT_VERB_CHECKPOINT_PROGRESS","category_id":6,"verbose_level":"DEBUG_1","verbose_level_id":1,"msg":"saving checkpoint snapshot min: 133, snapshot max: 133 snapshot count: 0, oldest timestamp: (0, 0) , meta checkpoint timestamp: (0, 0) base write gen: 1"}}}
{"t":{"$date":"2024-08-13T08:46:33.134+00:00"},"s":"I",  "c":"WTCHKPT",  "id":22430,   "ctx":"Checkpointer","msg":"WiredTiger message","attr":{"message":{"ts_sec":1723538793,"ts_usec":134245,"thread":"7566:0x7f6b2fbcd640","session_name":"WT_SESSION.checkpoint","category":"WT_VERB_CHECKPOINT_PROGRESS","category_id":6,"verbose_level":"DEBUG_1","verbose_level_id":1,"msg":"saving checkpoint snapshot min: 134, snapshot max: 134 snapshot count: 0, oldest timestamp: (0, 0) , meta checkpoint timestamp: (0, 0) base write gen: 1"}}}

*/

-- Step 41 -->> On All Nodes (Stop MongoDB)
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:/# systemctl stop mongod

-- Step 42 -->> On All Nodes (Find the location of MongoDB)
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:/# which mongosh
/*
/usr/bin/mongosh
*/

-- Step 43 -->> On All Nodes (After MongoDB Version 4.4 the "mongo" shell is not avilable)
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:/# cd /usr/bin/

-- Step 44 -->> On All Nodes
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:/usr/bin# ll | grep mongo
/*
-rwxr-xr-x.  1 root root     52760816 Jul 19 06:58 mongobridge*
-rwxr-xr-x.  1 root root    141725720 Jul 19 06:58 mongod*
-rwxr-xr-x.  1 root root     10615152 Jul 19 06:58 mongodump*
-rwxr-xr-x.  1 root root     10405904 Jul 19 06:58 mongoexport*
-rwxr-xr-x.  1 root root     10393456 Jul 19 06:58 mongofiles*
-rwxr-xr-x.  1 root root     10538672 Jul 19 06:58 mongoimport*
-rwxr-xr-x.  1 root root     10861936 Jul 19 06:58 mongorestore*
-rwxr-xr-x.  1 root root     96051512 Jul 19 06:58 mongos*
-rwxr-xr-x.  1 root root    148374000 Jul  8 12:08 mongosh*
-rwxr-xr-x.  1 root root     10251056 Jul 19 06:58 mongostat*
-rwxr-xr-x.  1 root root      9978640 Jul 19 06:58 mongotop*
-rwxr-xr-x.  1 root root         7796 Jul 19 06:27 percona-server-mongodb-enable-auth.sh*
-rwxr-xr-x.  1 root root         1936 Jul 19 06:42 percona-server-mongodb-helper.sh*


*/

-- Step 45 -->> On All Nodes (Make a copy of mongosh as mongo)
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:/usr/bin# cp mongosh mongo

-- Step 46 -->> On All Nodes
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:/usr/bin# ll | grep mongo
/*
-rwxr-xr-x.  1 root root    148374000 Aug 13 08:48 mongo*
-rwxr-xr-x.  1 root root     52760816 Jul 19 06:58 mongobridge*
-rwxr-xr-x.  1 root root    141725720 Jul 19 06:58 mongod*
-rwxr-xr-x.  1 root root     10615152 Jul 19 06:58 mongodump*
-rwxr-xr-x.  1 root root     10405904 Jul 19 06:58 mongoexport*
-rwxr-xr-x.  1 root root     10393456 Jul 19 06:58 mongofiles*
-rwxr-xr-x.  1 root root     10538672 Jul 19 06:58 mongoimport*
-rwxr-xr-x.  1 root root     10861936 Jul 19 06:58 mongorestore*
-rwxr-xr-x.  1 root root     96051512 Jul 19 06:58 mongos*
-rwxr-xr-x.  1 root root    148374000 Jul  8 12:08 mongosh*
-rwxr-xr-x.  1 root root     10251056 Jul 19 06:58 mongostat*
-rwxr-xr-x.  1 root root      9978640 Jul 19 06:58 mongotop*
-rwxr-xr-x.  1 root root         7796 Jul 19 06:27 percona-server-mongodb-enable-auth.sh*
-rwxr-xr-x.  1 root root         1936 Jul 19 06:42 percona-server-mongodb-helper.sh*

*/

-- Step 47 -->> On All Nodes (Start MongoDB)
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~# systemctl start mongod

-- Step 48 -->> On All Nodes (Verify MongoDB)
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~# systemctl status mongod
/*
● mongod.service - High-performance, schema-free document-oriented database
     Loaded: loaded (/lib/systemd/system/mongod.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2024-08-13 08:50:42 UTC; 6s ago
    Process: 8598 ExecStartPre=/usr/bin/percona-server-mongodb-helper.sh (code=exited, status=0/SUCCESS)
    Process: 8615 ExecStart=/usr/bin/env bash -c ${NUMACTL} /usr/bin/mongod ${OPTIONS} > ${STDOUT} 2> ${STDERR} (code=exited, status=0/SUCCESS)
   Main PID: 8618 (mongod)
      Tasks: 34 (limit: 4513)
     Memory: 171.7M
        CPU: 535ms
     CGroup: /system.slice/mongod.service
             └─8618 /usr/bin/mongod -f /etc/mongod.conf

Aug 13 08:50:41 percona-mongodb-pri.com systemd[1]: Starting High-performance, schema-free document-oriented database...
Aug 13 08:50:42 percona-mongodb-pri.com systemd[1]: Started High-performance, schema-free document-oriented database.

*/

-- Step 49 -->> On All Nodes (Begin with MongoDB)
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~# mongosh
/*
Current Mongosh Log ID: 66bb1e862494383c9fd56fd0
Connecting to:          mongodb://127.0.0.1:27017/?directConnection=true&serverSelectionTimeoutMS=2000&appName=mongosh+2.2.10
Using MongoDB:          7.0.12-7
Using Mongosh:          2.2.10
mongosh 2.2.15 is available for download: https://www.mongodb.com/try/download/shell

For mongosh info see: https://docs.mongodb.com/mongodb-shell/

------
   The server generated these startup warnings when booting
   2024-08-13T08:50:42.098+00:00: Access control is not enabled for the database. Read and write access to data and configuration is unrestricted. You can use percona-server-mongodb-enable-auth.sh to fix it

------


test> show dbs;
admin   40.00 KiB
config  12.00 KiB
local   80.00 KiB
test> db.version();
7.0.12-7

*/

-- Step 50 -->> On All Nodes (Begin with MongoDB)
root@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~# mongo
/*
Current Mongosh Log ID: 66bb1ebeeaf113dd0cd56fd0
Connecting to:          mongodb://127.0.0.1:27017/?directConnection=true&serverSelectionTimeoutMS=2000&appName=mongosh+2.2.10
Using MongoDB:          7.0.12-7
Using Mongosh:          2.2.10
mongosh 2.2.15 is available for download: https://www.mongodb.com/try/download/shell

For mongosh info see: https://docs.mongodb.com/mongodb-shell/

------
   The server generated these startup warnings when booting
   2024-08-13T08:50:42.098+00:00: Access control is not enabled for the database. Read and write access to data and configuration is unrestricted. You can use percona-server-mongodb-enable-auth.sh to fix it
------

test>  db.version()
7.0.12-7
test> show dbs
admin    40.00 KiB
config   12.00 KiB
local   112.00 KiB
exit
*/

-- Step 51 -->> On Node 1 (Switch user into MongoDB)
root@percona-mongodb-pri:~# su - mongodb
mongodb@percona-mongodb-pri:~$ sudo systemctl status mongod
/*
● mongod.service - High-performance, schema-free document-oriented database
     Loaded: loaded (/lib/systemd/system/mongod.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2024-08-13 08:50:42 UTC; 3min 1s ago
    Process: 8598 ExecStartPre=/usr/bin/percona-server-mongodb-helper.sh (code=exited, status=0/SUCCESS)
    Process: 8615 ExecStart=/usr/bin/env bash -c ${NUMACTL} /usr/bin/mongod ${OPTIONS} > ${STDOUT} 2> ${STDERR} (code=exited, status=0/SUCCESS)
   Main PID: 8618 (mongod)
      Tasks: 33 (limit: 4513)
     Memory: 173.4M
        CPU: 1.840s
     CGroup: /system.slice/mongod.service
             └─8618 /usr/bin/mongod -f /etc/mongod.conf

*/

-- Step 52 -->> On Node 1 (Verify MongoDB)
mongodb@percona-mongodb-pri:~$ mongosh --eval 'db.runCommand({ connectionStatus: 1 })'
/*
{
  authInfo: { authenticatedUsers: [], authenticatedUserRoles: [] },
  ok: 1
}


*/

-- Step 53 -->> On Node 1 (Begin with MongoDB - Create user for Authorized)
mongodb@percona-mongodb-pri:~$ mongosh
/*
Current Mongosh Log ID: 66bb1f46db472d2231d56fd0
Connecting to:          mongodb://127.0.0.1:27017/?directConnection=true&serverSelectionTimeoutMS=2000&appName=mongosh+2.2.10
Using MongoDB:          7.0.12-7
Using Mongosh:          2.2.10
mongosh 2.2.15 is available for download: https://www.mongodb.com/try/download/shell

For mongosh info see: https://docs.mongodb.com/mongodb-shell/

------
   The server generated these startup warnings when booting
   2024-08-13T08:50:42.098+00:00: Access control is not enabled for the database. Read and write access to data and configuration is unrestricted. You can use percona-server-mongodb-enable-auth.sh to fix it


test> db.version()
7.0.12-7
test> show dbs
admin    40.00 KiB
config   12.00 KiB
local   112.00 KiB


test> use admin
switched to db admin

admin> db
admin

admin> db.createUser(
... {
...     user: "admin",
...     pwd: "P#ssw0rd",
...     roles: [
...         {
...             role: "userAdminAnyDatabase",
...             db: "admin"
...         },
...         {
...             role: "clusterAdmin",
...              db: "admin"
...         },
...         {
...             role: "root",
...             db: "admin"
...         }
...     ]
... })
{ ok: 1 }

admin> db.getUsers()
{
  users: [
    {
      _id: 'admin.admin',
      userId: UUID('5e077bd7-d5eb-46b1-93bc-fca28beb5286'),
      user: 'admin',
      db: 'admin',
      roles: [
        { role: 'root', db: 'admin' },
        { role: 'userAdminAnyDatabase', db: 'admin' },
        { role: 'clusterAdmin', db: 'admin' }
      ],
      mechanisms: [ 'SCRAM-SHA-1', 'SCRAM-SHA-256' ]
    }
  ],
  ok: 1
}

admin> db.auth('admin','P#ssw0rd');
{ ok: 1 }

admin> quit()
*/

-- Step 54 -->> On Node 1 (Stop MongoDB)
mongodb@percona-mongodb-pri:~$ sudo systemctl stop mongod

-- Step 55 -->> On Node 1 (Access control is enabled for the database)
mongodb@percona-mongodb-pri:~$ sudo vi /etc/mongod.conf
/*
#security:
security:
 authorization: enabled
*/

-- Step 56 -->> On Node 1 (Start MongoDB)
mongodb@percona-mongodb-pri:~$ sudo systemctl start mongod

-- Step 57-->> On Node 1 (Verify MongoDB)
mongodb@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~$ sudo systemctl status mongod
/*
● mongod.service - High-performance, schema-free document-oriented database
     Loaded: loaded (/lib/systemd/system/mongod.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2024-08-13 08:58:37 UTC; 5s ago
    Process: 8777 ExecStartPre=/usr/bin/percona-server-mongodb-helper.sh (code=exited, status=0/SUCCESS)
    Process: 8794 ExecStart=/usr/bin/env bash -c ${NUMACTL} /usr/bin/mongod ${OPTIONS} > ${STDOUT} 2> ${STDERR} (code=exited, status=0/SUCCESS)
   Main PID: 8797 (mongod)
      Tasks: 34 (limit: 4513)
     Memory: 169.8M
        CPU: 427ms
     CGroup: /system.slice/mongod.service
             └─8797 /usr/bin/mongod -f /etc/mongod.conf

Aug 13 08:58:37 percona-mongodb-pri.com systemd[1]: Starting High-performance, schema-free document-oriented database...
Aug 13 08:58:37 percona-mongodb-pri.com systemd[1]: Started High-performance, schema-free document-oriented database.
*/

-- Step 58 -->> On Node 1 (Begin with MongoDB)
mongodb@percona-mongodb-pri:~$ mongosh
/*
Current Mongosh Log ID: 66bb205ca4e4c2b964d56fd0
Connecting to:          mongodb://127.0.0.1:27017/?directConnection=true&serverSelectionTimeoutMS=2000&appName=mongosh+2.2.10
Using MongoDB:          7.0.12-7
Using Mongosh:          2.2.10
mongosh 2.2.15 is available for download: https://www.mongodb.com/try/download/shell

For mongosh info see: https://docs.mongodb.com/mongodb-shell/



test> db.version()
7.0.12-7

test> show dbs
MongoServerError[Unauthorized]: Command listDatabases requires authentication

test> quit()
*/

-- Step 59 -->> On Node 1 (Begin with MongoDB)
mongodb@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~$ mongo
/*
Current Mongosh Log ID: 66bb20a66359b756a0d56fd0
Connecting to:          mongodb://127.0.0.1:27017/?directConnection=true&serverSelectionTimeoutMS=2000&appName=mongosh+2.2.10
Using MongoDB:          7.0.12-7
Using Mongosh:          2.2.10
mongosh 2.2.15 is available for download: https://www.mongodb.com/try/download/shell

For mongosh info see: https://docs.mongodb.com/mongodb-shell/


test> db.version()
7.0.12-7

test> show dbs
MongoServerError[Unauthorized]: Command listDatabases requires authentication

test> exit
*/

-- Step 60 -->> On Node 1 (Begin with MongoDB using Access Details)
mongodb@percona-mongodb-pri:~$ mongo --host 127.0.0.1 --port 27017 -u admin -p P#ssw0rd --authenticationDatabase admin
/*
Current Mongosh Log ID: 66bb20fd2cf2aaaac9d56fd0
Connecting to:          mongodb://<credentials>@127.0.0.1:27017/?directConnection=true&serverSelectionTimeoutMS=2000&authSource=admin&appName=mongosh+2.2.10
Using MongoDB:          7.0.12-7
Using Mongosh:          2.2.10
mongosh 2.2.15 is available for download: https://www.mongodb.com/try/download/shell

For mongosh info see: https://docs.mongodb.com/mongodb-shell/



test> db.version()
7.0.12-7

test> show dbs
admin   132.00 KiB
config   60.00 KiB
local   112.00 KiB


test> quit()
*/

-- Step 61 -->> On Node 1 (Begin with MongoDB using Access Details)
mongodb@percona-mongodb-pri:~$ mongosh --host 192.168.120.7 --port 27017 -u admin -p P#ssw0rd --authenticationDatabase admin
/*
Current Mongosh Log ID: 6678d0e406db529b03597192
Connecting to:          mongodb://<credentials>@192.168.120.70:27017/?directConnection=true&authSource=admin&appName=mongosh+2.2.9
Using MongoDB:          7.0.11
Using Mongosh:          2.2.9

For mongosh info see: https://docs.mongodb.com/mongodb-shell/


test> db.version()
7.0.12-7

test> show dbs
admin   132.00 KiB
config  108.00 KiB
local   112.00 KiB


test> use admin
switched to db admin

admin> db
admin

admin> db.getUsers()
{
  users: [
    {
      _id: 'admin.admin',
      userId: UUID('a74a70c7-60d2-413e-8e2d-d06ced87436b'),
      user: 'admin',
      db: 'admin',
      roles: [
        { role: 'clusterAdmin', db: 'admin' },
        { role: 'userAdminAnyDatabase', db: 'admin' },
        { role: 'root', db: 'admin' }
      ],
      mechanisms: [ 'SCRAM-SHA-1', 'SCRAM-SHA-256' ]
    }
  ],
  ok: 1
}


admin> exit
*/

-- Step 62 -->> On Node 2 (Begin with MongoDB)
root@percona-mongodb-sec:~# su - mongodb
mongodb@percona-mongodb-sec:~$ sudo systemctl status mongod
/*
● mongod.service - MongoDB Database Server
     Loaded: loaded (/lib/systemd/system/mongod.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2024-06-24 07:11:07 +0545; 26min ago
       Docs: https://docs.mongodb.org/manual
   Main PID: 1457 (mongod)
     Memory: 258.2M
        CPU: 24.419s
     CGroup: /system.slice/mongod.service
             └─1457 /usr/bin/mongod --config /etc/mongod.conf

Jun 24 07:11:07 percona-mongodb-sec.com.np systemd[1]: Started MongoDB Database Server.
Jun 24 07:11:09 percona-mongodb-sec.com.np mongod[1457]: {"t":{"$date":"2024-06-24T01:26:09.885Z"},"s":"I",  "c":"CONTROL",  "id":7484500, "ctx":"main","msg>
*/

-- Step 63 -->> On Node 2 (Begin with MongoDB - Access control is enabled for the database)
mongodb@percona-mongodb-sec:~$ sudo systemctl stop mongod

-- Step 64 -->> On Node 2 (Begin with MongoDB - Access control is enabled for the database)
mongodb@percona-mongodb-sec:~$ sudo vi /etc/mongod.conf
/*
#security:
security:
 authorization: enabled
*/

-- Step 65 -->> On Node 2
mongodb@percona-mongodb-sec:~$ sudo systemctl start mongod

-- Step 66 -->> On Node 2
mongodb@percona-mongodb-sec:~$ sudo systemctl status mongod
/*
● mongod.service - High-performance, schema-free document-oriented database
     Loaded: loaded (/lib/systemd/system/mongod.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2024-08-13 10:00:27 UTC; 8min ago
    Process: 1772 ExecStartPre=/usr/bin/percona-server-mongodb-helper.sh (code=exited, status=0/SUCCESS)
    Process: 1789 ExecStart=/usr/bin/env bash -c ${NUMACTL} /usr/bin/mongod ${OPTIONS} > ${STDOUT} 2> ${STDERR} (code=exited, status=0/SUCCESS)
   Main PID: 1792 (mongod)
      Tasks: 33 (limit: 4513)
     Memory: 176.9M
        CPU: 3.674s
     CGroup: /system.slice/mongod.service
             └─1792 /usr/bin/mongod -f /etc/mongod.conf

Aug 13 10:00:27 percona-mongodb-sec.com systemd[1]: Starting High-performance, schema-free document-oriented database...
Aug 13 10:00:27 percona-mongodb-sec.com systemd[1]: Started High-performance, schema-free document-oriented database.

*/

-- Step 67 -->> On Node 3
root@percona-mongodb-arb:~# su - mongodb
mongodb@percona-mongodb-arb:~$ sudo systemctl status mongod
/*
● mongod.service - High-performance, schema-free document-oriented database
     Loaded: loaded (/lib/systemd/system/mongod.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2024-08-13 10:03:30 UTC; 4min 45s ago
    Process: 1825 ExecStartPre=/usr/bin/percona-server-mongodb-helper.sh (code=exited, status=0/SUCCESS)
    Process: 1842 ExecStart=/usr/bin/env bash -c ${NUMACTL} /usr/bin/mongod ${OPTIONS} > ${STDOUT} 2> ${STDERR} (code=exited, status=0/SUCCESS)
   Main PID: 1845 (mongod)
      Tasks: 33 (limit: 4513)
     Memory: 176.4M
        CPU: 2.361s
     CGroup: /system.slice/mongod.service
             └─1845 /usr/bin/mongod -f /etc/mongod.conf

Aug 13 10:03:29 percona-mongodb-arb.com systemd[1]: Starting High-performance, schema-free document-oriented database...
Aug 13 10:03:30 percona-mongodb-arb.com systemd[1]: Started High-performance, schema-free document-oriented database.

*/

-- Step 68 -->> On Node 3 (Begin with MongoDB - Access control is enabled for the database)
mongodb@percona-mongodb-arb:~$ sudo systemctl stop mongod

-- Step 69 -->> On Node 3 (Begin with MongoDB - Access control is enabled for the database)
mongodb@percona-mongodb-arb:~$ sudo vi /etc/mongod.conf
/*
#security:
security:
  authorization: enabled
*/

-- Step 70 -->> On Node 3
mongodb@percona-mongodb-arb:~$ sudo systemctl start mongod

-- Step 71 -->> On Node 3
mongodb@percona-mongodb-arb:~$ sudo systemctl status mongod
/*
● mongod.service - High-performance, schema-free document-oriented database
     Loaded: loaded (/lib/systemd/system/mongod.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2024-08-13 10:03:30 UTC; 4min 45s ago
    Process: 1825 ExecStartPre=/usr/bin/percona-server-mongodb-helper.sh (code=exited, status=0/SUCCESS)
    Process: 1842 ExecStart=/usr/bin/env bash -c ${NUMACTL} /usr/bin/mongod ${OPTIONS} > ${STDOUT} 2> ${STDERR} (code=exited, status=0/SUCCESS)
   Main PID: 1845 (mongod)
      Tasks: 33 (limit: 4513)
     Memory: 176.4M
        CPU: 2.361s
     CGroup: /system.slice/mongod.service
             └─1845 /usr/bin/mongod -f /etc/mongod.conf

Aug 13 10:03:29 percona-mongodb-arb.com systemd[1]: Starting High-performance, schema-free document-oriented database...
Aug 13 10:03:30 percona-mongodb-arb.com systemd[1]: Started High-performance, schema-free document-oriented database.
*/

-- Step 72 -->> On All Nodes (Verify the Status of MongoDB)
mongodb@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~$ sudo systemctl status mongod
/*
● mongod.service - High-performance, schema-free document-oriented database
     Loaded: loaded (/lib/systemd/system/mongod.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2024-08-13 09:43:10 UTC; 48min ago
    Process: 973 ExecStart=/usr/bin/env bash -c ${NUMACTL} /usr/bin/mongod ${OPTIONS} > ${STDOUT} 2> ${STDERR} (code=exited, status=0/SUCCESS)
   Main PID: 1129 (mongod)
      Tasks: 33 (limit: 4513)
     Memory: 269.7M
        CPU: 21.349s
     CGroup: /system.slice/mongod.service
             └─1129 /usr/bin/mongod -f /etc/mongod.conf

Aug 13 09:43:09 percona-mongodb-pri.com systemd[1]: Starting High-performance, schema-free document-oriented database...
Aug 13 09:43:10 percona-mongodb-pri.com systemd[1]: Started High-performance, schema-free document-oriented database.
*/

-- Step 73 -->> On All Nodes (Configure ReplicaSets)
mongodb@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~$ sudo vi /etc/mongod.conf
/*
#replication:
replication:
  replSetName: rs0
*/

-- Step 74 -->> On Node 1 (Configure ReplicaSets)
mongodb@percona-mongodb-pri:~$ cd /data/datastore/mongodb/

-- Step 75 -->> On Node 1 (Configure ReplicaSets)
mongodb@percona-mongodb-pri:/data/datastore/mongodb$ ll
/*
drwxrwxrwx. 4 mongod mongod  4096 Aug 13 10:33 ./
drwxr-xr-x. 4 root   root      32 Aug 13 05:13 ../
-rw-------. 1 mongod mongod 36864 Aug 13 09:43 collection-0--6409478916309770768.wt
-rw-------. 1 mongod mongod 20480 Aug 13 10:06 collection-0--6720920465008851336.wt
-rw-------. 1 mongod mongod 36864 Aug 13 09:44 collection-2--6409478916309770768.wt
-rw-------. 1 mongod mongod 24576 Aug 13 10:33 collection-4--6409478916309770768.wt
-rw-------. 1 mongod mongod 20480 Aug 13 09:43 collection-5--6409478916309770768.wt
drwx------. 2 mongod mongod  4096 Aug 13 10:33 diagnostic.data/
-rw-------. 1 mongod mongod 36864 Aug 13 09:43 index-1--6409478916309770768.wt
-rw-------. 1 mongod mongod 20480 Aug 13 08:57 index-1--6720920465008851336.wt
-rw-------. 1 mongod mongod 20480 Aug 13 10:06 index-2--6720920465008851336.wt
-rw-------. 1 mongod mongod 36864 Aug 13 09:44 index-3--6409478916309770768.wt
-rw-------. 1 mongod mongod 24576 Aug 13 10:33 index-6--6409478916309770768.wt
-rw-------. 1 mongod mongod 24576 Aug 13 10:33 index-7--6409478916309770768.wt
-rw-------. 1 mongod mongod 20480 Aug 13 08:49 index-8--6409478916309770768.wt
drwx------. 2 mongod mongod   110 Aug 13 09:43 journal/
-rw-------. 1 mongod mongod 36864 Aug 13 09:43 _mdb_catalog.wt
-rw-------. 1 mongod mongod     5 Aug 13 09:43 mongod.lock
-rw-------. 1 mongod mongod    33 Aug 13 07:13 psmdb_telemetry.data
-rw-------. 1 mongod mongod 36864 Aug 13 10:33 sizeStorer.wt
-rw-------. 1 mongod mongod   114 Aug 13 07:13 storage.bson
-rw-------. 1 mongod mongod    50 Aug 13 07:13 WiredTiger
-rw-------. 1 mongod mongod  4096 Aug 13 09:43 WiredTigerHS.wt
-rw-------. 1 mongod mongod    21 Aug 13 07:13 WiredTiger.lock
-rw-------. 1 mongod mongod  1474 Aug 13 10:33 WiredTiger.turtle
-rw-------. 1 mongod mongod 86016 Aug 13 10:33 WiredTiger.wt

*/

-- Step 76 -->> On Node 1 (Configure ReplicaSets)
mongodb@percona-mongodb-pri:/data/datastore/mongodb$ openssl rand -base64 756 > keyfile

-- Step 77 -->> On Node 1 (Configure ReplicaSets)
mongodb@percona-mongodb-pri:/data/datastore/mongodb$ chmod 400 keyfile
mongodb@percona-mongodb-pri:/data/datastore/mongodb$ chown mongod:mongod keyfile
mongodb@percona-mongodb-pri:/data/datastore/mongodb$ sudo chown mongod:mongod keyfile
-- Step 78 -->> On Node 1 (Configure ReplicaSets)
mongodb@percona-mongodb-pri:/data/datastore/mongodb$ ll
/*
drwxrwxrwx. 4 mongod mongod  4096 Aug 13 10:37 ./
drwxr-xr-x. 4 root   root      32 Aug 13 05:13 ../
-rw-------. 1 mongod mongod 36864 Aug 13 09:43 collection-0--6409478916309770768.wt
-rw-------. 1 mongod mongod 20480 Aug 13 10:06 collection-0--6720920465008851336.wt
-rw-------. 1 mongod mongod 36864 Aug 13 09:44 collection-2--6409478916309770768.wt
-rw-------. 1 mongod mongod 24576 Aug 13 10:33 collection-4--6409478916309770768.wt
-rw-------. 1 mongod mongod 20480 Aug 13 09:43 collection-5--6409478916309770768.wt
drwx------. 2 mongod mongod  4096 Aug 13 10:37 diagnostic.data/
-rw-------. 1 mongod mongod 36864 Aug 13 09:43 index-1--6409478916309770768.wt
-rw-------. 1 mongod mongod 20480 Aug 13 08:57 index-1--6720920465008851336.wt
-rw-------. 1 mongod mongod 20480 Aug 13 10:06 index-2--6720920465008851336.wt
-rw-------. 1 mongod mongod 36864 Aug 13 09:44 index-3--6409478916309770768.wt
-rw-------. 1 mongod mongod 24576 Aug 13 10:33 index-6--6409478916309770768.wt
-rw-------. 1 mongod mongod 24576 Aug 13 10:33 index-7--6409478916309770768.wt
-rw-------. 1 mongod mongod 20480 Aug 13 08:49 index-8--6409478916309770768.wt
drwx------. 2 mongod mongod   110 Aug 13 09:43 journal/
-r--------. 1 mongod mongod  1024 Aug 13 10:34 keyfile
-rw-------. 1 mongod mongod 36864 Aug 13 09:43 _mdb_catalog.wt
-rw-------. 1 mongod mongod     5 Aug 13 09:43 mongod.lock
-rw-------. 1 mongod mongod    33 Aug 13 07:13 psmdb_telemetry.data
-rw-------. 1 mongod mongod 36864 Aug 13 10:33 sizeStorer.wt
-rw-------. 1 mongod mongod   114 Aug 13 07:13 storage.bson
-rw-------. 1 mongod mongod    50 Aug 13 07:13 WiredTiger
-rw-------. 1 mongod mongod  4096 Aug 13 09:43 WiredTigerHS.wt
-rw-------. 1 mongod mongod    21 Aug 13 07:13 WiredTiger.lock
-rw-------. 1 mongod mongod  1474 Aug 13 10:37 WiredTiger.turtle
-rw-------. 1 mongod mongod 86016 Aug 13 10:37 WiredTiger.wt


*/

-- Step 79 -->> On Node 1 (Configure ReplicaSets)
mongodb@percona-mongodb-pri:/datastore/mongodb$ ll | grep keyfile
/*
-r--------. 1 mongodb mongodb  1024 Jun 24 08:01 keyfile
*/

-- Step 80 -->> On Node 1 (Copy the KeyFile from Primary to Secondary Node)

root@percona-mongodb-pri:/data/datastore/mongodb# scp -r keyfile mongodb@192.168.120.9:/data/datastore/mongodb
/*
The authenticity of host '192.168.120.9 (192.168.120.9)' can't be established.
ED25519 key fingerprint is SHA256:2zlb1Jp0RD6jNdihrktAVHE9xD9o9LWPERmCX5mLsEE.
This host key is known by the following other names/addresses:
    ~/.ssh/known_hosts:1: [hashed name]
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '192.168.120.9' (ED25519) to the list of known hosts.
mongodb@192.168.120.9's password:
keyfile       
*/
mongodb@percona-mongodb-sec:/data/datastore/mongodb$ sudo chown mongod:mongod keyfile

-- Step 81 -->> On Node 1 (Copy the KeyFile from Primary to Arbiter  Node)
root@percona-mongodb-pri:/data/datastore/mongodb# scp -r keyfile mongodb@192.168.120.10:/data/datastore/mongodb
/*
The authenticity of host '192.168.120.10 (192.168.120.10)' can't be established.
ED25519 key fingerprint is SHA256:2zlb1Jp0RD6jNdihrktAVHE9xD9o9LWPERmCX5mLsEE.
This host key is known by the following other names/addresses:
    ~/.ssh/known_hosts:1: [hashed name]
    ~/.ssh/known_hosts:4: [hashed name]
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '192.168.120.10' (ED25519) to the list of known hosts.
mongodb@192.168.120.10's password:
keyfile                          
*/
mongodb@percona-mongodb-arb:/data/datastore/mongodb$ sudo chown mongod:mongod keyfile
-- Step 82 -->> On Node 2 (Verify the KeyFile on Secondary Node)
mongodb@percona-mongodb-sec:~$ cd /data/datastore/mongodb/

-- Step 83 -->> On Node 2 (Verify the KeyFile on Secondary Node)
mongodb@percona-mongodb-sec:/data/datastore/mongodb$ ll | grep keyfile
/*
-r--------. 1 mongod mongod  1024 Aug 13 10:41 keyfile
*/

-- Step 84 -->> On Node 3 (Verify the KeyFile on Arbiter Node)
mongodb@percona-mongodb-arb:~$ cd /data/datastore/mongodb/

-- Step 85 -->> On Node 3 (Verify the KeyFile on Arbiter Node)
mongodb@percona-mongodb-arb:/data/datastore/mongodb$ ll | grep keyfile
/*
-r--------. 1 mongod mongod  1024 Aug 13 10:42 keyfile
*/

-- Step 86 -->> On All Nodes (Add the KeyFile on Each Nodes)
mongodb@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:/datastore/mongodb$ sudo vi /etc/mongod.conf
/*
#security:
security:
  authorization: enabled
  keyFile: /data/datastore/mongodb/keyfile
*/

-- Step 87 -->> On All Nodes (Restart the MongoDB on Each Nodes)
mongodb@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~$ sudo systemctl restart mongod

-- Step 88 -->> On All Nodes (Verify the MongoDB Status on Each Nodes)
mongodb@percona-mongodb-pri/percona-mongodb-sec/percona-mongodb-arb:~$ sudo systemctl status mongod
/*
● mongod.service - High-performance, schema-free document-oriented database
     Loaded: loaded (/lib/systemd/system/mongod.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2024-08-13 10:50:31 UTC; 27s ago
    Process: 1890 ExecStartPre=/usr/bin/percona-server-mongodb-helper.sh (code=exited, status=0/SUCCESS)
    Process: 1909 ExecStart=/usr/bin/env bash -c ${NUMACTL} /usr/bin/mongod ${OPTIONS} > ${STDOUT} 2> ${STDERR} (code=exited, status=0/SUCCESS)
   Main PID: 1912 (mongod)
      Tasks: 54 (limit: 4513)
     Memory: 175.4M
        CPU: 1.079s
     CGroup: /system.slice/mongod.service
             └─1912 /usr/bin/mongod -f /etc/mongod.conf

Aug 13 10:50:31 percona-mongodb-pri.com systemd[1]: Starting High-performance, schema-free document-oriented database...
Aug 13 10:50:31 percona-mongodb-pri.com systemd[1]: Started High-performance, schema-free document-oriented database.


*/

-- Step 89 -->> On Node 1 (Configure the Primary Node for Secondary Replica Sets)
mongodb@percona-mongodb-pri:~$ mongosh --host 192.168.120.7  --port 27017 -u admin -p P#ssw0rd --authenticationDatabase admin
/*
Current Mongosh Log ID: 66bb3ac21ff2964a71d56fd0
Connecting to:          mongodb://<credentials>@192.168.120.7:27017/?directConnection=true&authSource=admin&appName=mongosh+2.2.10
Using MongoDB:          7.0.12-7
Using Mongosh:          2.2.10
mongosh 2.2.15 is available for download: https://www.mongodb.com/try/download/shell

For mongosh info see: https://docs.mongodb.com/mongodb-shell/



test> db.version()
7.0.12-7

test> show dbs
MongoServerError[NotPrimaryOrSecondary]: node is not in primary or recovering state

test> use admin
switched to db admin

admin> db
admin

admin> db.auth('admin','P#ssw0rd');
{ ok: 1 }

admin> rs.initiate(
        {
           _id: "rs0",
           version: 1,
           members: [
              { _id: 0, host : "percona-mongodb-pri:27017" }
           ]
        }
     )
{ ok: 1 }

rs0 [direct: secondary] admin> rs.add("percona-mongodb-sec:27017");
{
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1723546462, i: 1 }),
    signature: {
      hash: Binary.createFromBase64('NZp7WrtxBkCPflH+AeYaDPOEc+s=', 0),
      keyId: Long('7402575446908338182')
    }
  },
  operationTime: Timestamp({ t: 1723546462, i: 1 })
}


rs0 [direct: primary] admin> quit()
*/

-- Step 90 -->> On Node 1 (Verify the Primary Node)
mongodb@percona-mongodb-pri:~$ mongosh --host 192.168.120.7  --port 27017 -u admin -p P#ssw0rd --authenticationDatabase admin
/*
Current Mongosh Log ID: 66bb3b8a0357c43d91d56fd0
Connecting to:          mongodb://<credentials>@192.168.120.7:27017/?directConnection=true&authSource=admin&appName=mongosh+2.2.10
Using MongoDB:          7.0.12-7
Using Mongosh:          2.2.10
mongosh 2.2.15 is available for download: https://www.mongodb.com/try/download/shell

For mongosh info see: https://docs.mongodb.com/mongodb-shell/


rs0 [direct: primary] test> show dbs
admin   172.00 KiB
config  176.00 KiB
local   476.00 KiB


rs0 [direct: primary] test> use admin
switched to db admin

rs0 [direct: primary] admin> db.version()
7.0.12-7

rs0 [direct: primary] admin> rs.status()
{
  set: 'rs0',
  date: ISODate('2024-08-13T10:56:37.470Z'),
  myState: 1,
  term: Long('1'),
  syncSourceHost: '',
  syncSourceId: -1,
  heartbeatIntervalMillis: Long('2000'),
  majorityVoteCount: 2,
  writeMajorityCount: 2,
  votingMembersCount: 2,
  writableVotingMembersCount: 2,
  optimes: {
    lastCommittedOpTime: { ts: Timestamp({ t: 1723546596, i: 1 }), t: Long('1') },
    lastCommittedWallTime: ISODate('2024-08-13T10:56:36.474Z'),
    readConcernMajorityOpTime: { ts: Timestamp({ t: 1723546596, i: 1 }), t: Long('1') },
    appliedOpTime: { ts: Timestamp({ t: 1723546596, i: 1 }), t: Long('1') },
    durableOpTime: { ts: Timestamp({ t: 1723546596, i: 1 }), t: Long('1') },
    lastAppliedWallTime: ISODate('2024-08-13T10:56:36.474Z'),
    lastDurableWallTime: ISODate('2024-08-13T10:56:36.474Z')
  },
  lastStableRecoveryTimestamp: Timestamp({ t: 1723546576, i: 1 }),
  electionCandidateMetrics: {
    lastElectionReason: 'electionTimeout',
    lastElectionDate: ISODate('2024-08-13T10:53:26.437Z'),
    electionTerm: Long('1'),
    lastCommittedOpTimeAtElection: { ts: Timestamp({ t: 1723546406, i: 1 }), t: Long('-1') },
    lastSeenOpTimeAtElection: { ts: Timestamp({ t: 1723546406, i: 1 }), t: Long('-1') },
    numVotesNeeded: 1,
    priorityAtElection: 1,
    electionTimeoutMillis: Long('10000'),
    newTermStartDate: ISODate('2024-08-13T10:53:26.456Z'),
    wMajorityWriteAvailabilityDate: ISODate('2024-08-13T10:53:26.468Z')
  },
  members: [
    {
      _id: 0,
      name: 'percona-mongodb-pri:27017',
      health: 1,
      state: 1,
      stateStr: 'PRIMARY',
      uptime: 366,
      optime: { ts: Timestamp({ t: 1723546596, i: 1 }), t: Long('1') },
      optimeDate: ISODate('2024-08-13T10:56:36.000Z'),
      lastAppliedWallTime: ISODate('2024-08-13T10:56:36.474Z'),
      lastDurableWallTime: ISODate('2024-08-13T10:56:36.474Z'),
      syncSourceHost: '',
      syncSourceId: -1,
      infoMessage: '',
      electionTime: Timestamp({ t: 1723546406, i: 2 }),
      electionDate: ISODate('2024-08-13T10:53:26.000Z'),
      configVersion: 3,
      configTerm: 1,
      self: true,
      lastHeartbeatMessage: ''
    },
    {
      _id: 1,
      name: 'percona-mongodb-sec:27017',
      health: 1,
      state: 2,
      stateStr: 'SECONDARY',
      uptime: 135,
      optime: { ts: Timestamp({ t: 1723546586, i: 1 }), t: Long('1') },
      optimeDurable: { ts: Timestamp({ t: 1723546586, i: 1 }), t: Long('1') },
      optimeDate: ISODate('2024-08-13T10:56:26.000Z'),
      optimeDurableDate: ISODate('2024-08-13T10:56:26.000Z'),
      lastAppliedWallTime: ISODate('2024-08-13T10:56:36.474Z'),
      lastDurableWallTime: ISODate('2024-08-13T10:56:36.474Z'),
      lastHeartbeat: ISODate('2024-08-13T10:56:36.247Z'),
      lastHeartbeatRecv: ISODate('2024-08-13T10:56:36.760Z'),
      pingMs: Long('0'),
      lastHeartbeatMessage: '',
      syncSourceHost: 'percona-mongodb-pri:27017',
      syncSourceId: 0,
      infoMessage: '',
      configVersion: 3,
      configTerm: 1
    }
  ],
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1723546596, i: 1 }),
    signature: {
      hash: Binary.createFromBase64('t5qYiZA8z3zT5OK4ioZYzYpNufE=', 0),
      keyId: Long('7402575446908338182')
    }
  },
  operationTime: Timestamp({ t: 1723546596, i: 1 })
}



rs0 [direct: primary] admin> quit()
*/

-- Step 91 -->> On Node 1 (Configure the Primary Node for Arbiter)
mongodb@percona-mongodb-pri:~$ mongosh --host 192.168.120.7  --port 27017 -u admin -p P#ssw0rd --authenticationDatabase admin
/*
Current Mongosh Log ID: 66bb3c40df8b02b264d56fd0
Connecting to:          mongodb://<credentials>@192.168.120.7:27017/?directConnection=true&authSource=admin&appName=mongosh+2.2.10
Using MongoDB:          7.0.12-7
Using Mongosh:          2.2.10
mongosh 2.2.15 is available for download: https://www.mongodb.com/try/download/shell

For mongosh info see: https://docs.mongodb.com/mongodb-shell/



rs0 [direct: primary] test> db.version()
7.0.12-7

rs0 [direct: primary] test> show dbs
admin   172.00 KiB
config  176.00 KiB
local   492.00 KiB

rs0 [direct: primary] test> use admin
switched to db admin

rs0 [direct: primary] admin> db
admin

rs0 [direct: primary] admin> db.getUsers()
{
  users: [
    {
      _id: 'admin.admin',
      userId: UUID('a74a70c7-60d2-413e-8e2d-d06ced87436b'),
      user: 'admin',
      db: 'admin',
      roles: [
        { role: 'clusterAdmin', db: 'admin' },
        { role: 'userAdminAnyDatabase', db: 'admin' },
        { role: 'root', db: 'admin' }
      ],
      mechanisms: [ 'SCRAM-SHA-1', 'SCRAM-SHA-256' ]
    }
  ],
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1723546726, i: 1 }),
    signature: {
      hash: Binary.createFromBase64('h2gyoEpKxw/Z3rQ6fJsJz45WQzA=', 0),
      keyId: Long('7402575446908338182')
    }
  },
  operationTime: Timestamp({ t: 1723546726, i: 1 })
}


rs0 [direct: primary] admin> rs.addArb("percona-mongodb-arb:27017");

MongoServerError[NewReplicaSetConfigurationIncompatible]: Reconfig attempted to install a config that would change the implicit default write concern. Use the setDefaultRWConcern command to set a cluster-wide write concern and try the reconfig again.


-- To fix the above issue (MongoServerError: Reconfig attempted to install a config that would change the implicit default write concern. Use the setDefaultRWConcern command to set a cluster-wide write concern and try the reconfig again.)

rs0 [direct: primary] admin> db.adminCommand({
... setDefaultRWConcern: 1,
... defaultWriteConcern: { w: 1 }
... })
{
  defaultReadConcern: { level: 'local' },
  defaultWriteConcern: { w: 1, wtimeout: 0 },
  updateOpTime: Timestamp({ t: 1723547066, i: 1 }),
  updateWallClockTime: ISODate('2024-08-13T11:04:35.301Z'),
  defaultWriteConcernSource: 'global',
  defaultReadConcernSource: 'implicit',
  localUpdateWallClockTime: ISODate('2024-08-13T11:04:35.307Z'),
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1723547075, i: 2 }),
    signature: {
      hash: Binary.createFromBase64('WJ24Ei4RbrLgcH/swJUcQe9MaYA=', 0),
      keyId: Long('7402575446908338182')
    }
  },
  operationTime: Timestamp({ t: 1723547075, i: 2 })
}



rs0 [direct: primary] admin> rs.addArb("percona-mongodb-arb:27017");
{
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1723547233, i: 1 }),
    signature: {
      hash: Binary.createFromBase64('GXhboGgjV9zaW523QWGW3jTDCko=', 0),
      keyId: Long('7402575446908338182')
    }
  },
  operationTime: Timestamp({ t: 1723547233, i: 1 })
}


rs0 [direct: primary] admin>  rs.status()
{
  set: 'rs0',
  date: ISODate('2024-08-13T11:07:47.036Z'),
  myState: 1,
  term: Long('1'),
  syncSourceHost: '',
  syncSourceId: -1,
  heartbeatIntervalMillis: Long('2000'),
  majorityVoteCount: 2,
  writeMajorityCount: 2,
  votingMembersCount: 3,
  writableVotingMembersCount: 2,
  optimes: {
    lastCommittedOpTime: { ts: Timestamp({ t: 1723547266, i: 1 }), t: Long('1') },
    lastCommittedWallTime: ISODate('2024-08-13T11:07:46.510Z'),
    readConcernMajorityOpTime: { ts: Timestamp({ t: 1723547266, i: 1 }), t: Long('1') },
    appliedOpTime: { ts: Timestamp({ t: 1723547266, i: 1 }), t: Long('1') },
    durableOpTime: { ts: Timestamp({ t: 1723547266, i: 1 }), t: Long('1') },
    lastAppliedWallTime: ISODate('2024-08-13T11:07:46.510Z'),
    lastDurableWallTime: ISODate('2024-08-13T11:07:46.510Z')
  },
  lastStableRecoveryTimestamp: Timestamp({ t: 1723547246, i: 1 }),
  electionCandidateMetrics: {
    lastElectionReason: 'electionTimeout',
    lastElectionDate: ISODate('2024-08-13T10:53:26.437Z'),
    electionTerm: Long('1'),
    lastCommittedOpTimeAtElection: { ts: Timestamp({ t: 1723546406, i: 1 }), t: Long('-1') },
    lastSeenOpTimeAtElection: { ts: Timestamp({ t: 1723546406, i: 1 }), t: Long('-1') },
    numVotesNeeded: 1,
    priorityAtElection: 1,
    electionTimeoutMillis: Long('10000'),
    newTermStartDate: ISODate('2024-08-13T10:53:26.456Z'),
    wMajorityWriteAvailabilityDate: ISODate('2024-08-13T10:53:26.468Z')
  },
  members: [
    {
      _id: 0,
      name: 'percona-mongodb-pri:27017',
      health: 1,
      state: 1,
      stateStr: 'PRIMARY',
      uptime: 1036,
      optime: { ts: Timestamp({ t: 1723547266, i: 1 }), t: Long('1') },
      optimeDate: ISODate('2024-08-13T11:07:46.000Z'),
      lastAppliedWallTime: ISODate('2024-08-13T11:07:46.510Z'),
      lastDurableWallTime: ISODate('2024-08-13T11:07:46.510Z'),
      syncSourceHost: '',
      syncSourceId: -1,
      infoMessage: '',
      electionTime: Timestamp({ t: 1723546406, i: 2 }),
      electionDate: ISODate('2024-08-13T10:53:26.000Z'),
      configVersion: 4,
      configTerm: 1,
      self: true,
      lastHeartbeatMessage: ''
    },
    {
      _id: 1,
      name: 'percona-mongodb-sec:27017',
      health: 1,
      state: 2,
      stateStr: 'SECONDARY',
      uptime: 804,
      optime: { ts: Timestamp({ t: 1723547256, i: 1 }), t: Long('1') },
      optimeDurable: { ts: Timestamp({ t: 1723547256, i: 1 }), t: Long('1') },
      optimeDate: ISODate('2024-08-13T11:07:36.000Z'),
      optimeDurableDate: ISODate('2024-08-13T11:07:36.000Z'),
      lastAppliedWallTime: ISODate('2024-08-13T11:07:46.510Z'),
      lastDurableWallTime: ISODate('2024-08-13T11:07:46.510Z'),
      lastHeartbeat: ISODate('2024-08-13T11:07:45.258Z'),
      lastHeartbeatRecv: ISODate('2024-08-13T11:07:45.258Z'),
      pingMs: Long('0'),
      lastHeartbeatMessage: '',
      syncSourceHost: 'percona-mongodb-pri:27017',
      syncSourceId: 0,
      infoMessage: '',
      configVersion: 4,
      configTerm: 1
    },
    {
      _id: 2,
      name: 'percona-mongodb-arb:27017',
      health: 1,
      state: 7,
      stateStr: 'ARBITER',
      uptime: 33,
      lastHeartbeat: ISODate('2024-08-13T11:07:45.282Z'),
      lastHeartbeatRecv: ISODate('2024-08-13T11:07:45.302Z'),
      pingMs: Long('0'),
      lastHeartbeatMessage: '',
      syncSourceHost: '',
      syncSourceId: -1,
      infoMessage: '',
      configVersion: 4,
      configTerm: 1
    }
  ],
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1723547266, i: 1 }),
    signature: {
      hash: Binary.createFromBase64('lccjaE/v1C6RP5snZXgzhAs6BKY=', 0),
      keyId: Long('7402575446908338182')
    }
  },
  operationTime: Timestamp({ t: 1723547266, i: 1 })
}


rs0 [direct: primary] admin> quit()
*/

-- Step 92 -->> On Node 1 (Verify the Primary Node And Make the Primary Node High Priority)
mongodb@percona-mongodb-pri:~$ mongosh --host 192.168.120.7  --port 27017 -u admin -p P#ssw0rd --authenticationDatabase admin
/*
Current Mongosh Log ID: 66798228135a2fe802597192
Connecting to:          mongodb://<credentials>@192.168.120.70:27017/?directConnection=true&authSource=admin&appName=mongosh+2.2.9
Using MongoDB:          7.0.11
Using Mongosh:          2.2.9

For mongosh info see: https://docs.mongodb.com/mongodb-shell/


rs0 [direct: primary] test> show dbs;
admin   172.00 KiB
config  252.00 KiB
local   460.00 KiB


rs0 [direct: primary] test> use admin
switched to db admin

rs0 [direct: primary] admin> rs.conf()
{
  _id: 'rs0',
  version: 4,
  term: 1,
  members: [
    {
      _id: 0,
      host: 'percona-mongodb-pri:27017',
      arbiterOnly: false,
      buildIndexes: true,
      hidden: false,
      priority: 1,
      tags: {},
      secondaryDelaySecs: Long('0'),
      votes: 1
    },
    {
      _id: 1,
      host: 'percona-mongodb-sec:27017',
      arbiterOnly: false,
      buildIndexes: true,
      hidden: false,
      priority: 1,
      tags: {},
      secondaryDelaySecs: Long('0'),
      votes: 1
    },
    {
      _id: 2,
      host: 'percona-mongodb-arb:27017',
      arbiterOnly: true,
      buildIndexes: true,
      hidden: false,
      priority: 0,
      tags: {},
      secondaryDelaySecs: Long('0'),
      votes: 1
    }
  ],
  protocolVersion: Long('1'),
  writeConcernMajorityJournalDefault: true,
  settings: {
    chainingAllowed: true,
    heartbeatIntervalMillis: 2000,
    heartbeatTimeoutSecs: 10,
    electionTimeoutMillis: 10000,
    catchUpTimeoutMillis: -1,
    catchUpTakeoverDelayMillis: 30000,
    getLastErrorModes: {},
    getLastErrorDefaults: { w: 1, wtimeout: 0 },
    replicaSetId: ObjectId('66bb3b26c2fce6f24a4b566e')
  }
}


rs0 [direct: primary] admin> rs.isMaster()
{
  topologyVersion: {
    processId: ObjectId('66bb3a77c2fce6f24a4b5608'),
    counter: Long('9')
  },
  hosts: [ 'percona-mongodb-pri:27017', 'percona-mongodb-sec:27017' ],
  arbiters: [ 'percona-mongodb-arb:27017' ],
  setName: 'rs0',
  setVersion: 4,
  ismaster: true,
  secondary: false,
  primary: 'percona-mongodb-pri:27017',
  me: 'percona-mongodb-pri:27017',
  electionId: ObjectId('7fffffff0000000000000001'),
  lastWrite: {
    opTime: { ts: Timestamp({ t: 1723547516, i: 1 }), t: Long('1') },
    lastWriteDate: ISODate('2024-08-13T11:11:56.000Z'),
    majorityOpTime: { ts: Timestamp({ t: 1723547516, i: 1 }), t: Long('1') },
    majorityWriteDate: ISODate('2024-08-13T11:11:56.000Z')
  },
  maxBsonObjectSize: 16777216,
  maxMessageSizeBytes: 48000000,
  maxWriteBatchSize: 100000,
  localTime: ISODate('2024-08-13T11:11:58.919Z'),
  logicalSessionTimeoutMinutes: 30,
  connectionId: 40,
  minWireVersion: 0,
  maxWireVersion: 21,
  readOnly: false,
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1723547516, i: 1 }),
    signature: {
      hash: Binary.createFromBase64('ULtJkKxTqlMxyKe1nbKrqM7VQ3o=', 0),
      keyId: Long('7402575446908338182')
    }
  },
  operationTime: Timestamp({ t: 1723547516, i: 1 }),
  isWritablePrimary: true
}


-- Step A - To make it High Primary Always (By chaging the priority => 10)

rs0 [direct: primary] admin> cfg = rs.conf()
{
  _id: 'rs0',
  version: 4,
  term: 1,
  members: [
    {
      _id: 0,
      host: 'percona-mongodb-pri:27017',
      arbiterOnly: false,
      buildIndexes: true,
      hidden: false,
      priority: 1,
      tags: {},
      secondaryDelaySecs: Long('0'),
      votes: 1
    },
    {
      _id: 1,
      host: 'percona-mongodb-sec:27017',
      arbiterOnly: false,
      buildIndexes: true,
      hidden: false,
      priority: 1,
      tags: {},
      secondaryDelaySecs: Long('0'),
      votes: 1
    },
    {
      _id: 2,
      host: 'percona-mongodb-arb:27017',
      arbiterOnly: true,
      buildIndexes: true,
      hidden: false,
      priority: 0,
      tags: {},
      secondaryDelaySecs: Long('0'),
      votes: 1
    }
  ],
  protocolVersion: Long('1'),
  writeConcernMajorityJournalDefault: true,
  settings: {
    chainingAllowed: true,
    heartbeatIntervalMillis: 2000,
    heartbeatTimeoutSecs: 10,
    electionTimeoutMillis: 10000,
    catchUpTimeoutMillis: -1,
    catchUpTakeoverDelayMillis: 30000,
    getLastErrorModes: {},
    getLastErrorDefaults: { w: 1, wtimeout: 0 },
    replicaSetId: ObjectId('66bb3b26c2fce6f24a4b566e')
  }
}

-- Step B - To make it High Primary Always (By chaging the priority => 10)

rs0 [direct: primary] admin> cfg.members[0].priority = 10
10

rs0 [direct: primary] admin> rs.reconfig(cfg)
{
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1723547692, i: 1 }),
    signature: {
      hash: Binary.createFromBase64('JYQibNIf5+1cvmR5+26wtWI/VkM=', 0),
      keyId: Long('7402575446908338182')
    }
  },
  operationTime: Timestamp({ t: 1723547692, i: 1 })
}


-- Step C - To make it High Primary Always (By chaging the priority => 10)

rs0 [direct: primary] admin> rs.conf()
{
  _id: 'rs0',
  version: 5,
  term: 1,
  members: [
    {
      _id: 0,
      host: 'percona-mongodb-pri:27017',
      arbiterOnly: false,
      buildIndexes: true,
      hidden: false,
      priority: 10,
      tags: {},
      secondaryDelaySecs: Long('0'),
      votes: 1
    },
    {
      _id: 1,
      host: 'percona-mongodb-sec:27017',
      arbiterOnly: false,
      buildIndexes: true,
      hidden: false,
      priority: 1,
      tags: {},
      secondaryDelaySecs: Long('0'),
      votes: 1
    },
    {
      _id: 2,
      host: 'percona-mongodb-arb:27017',
      arbiterOnly: true,
      buildIndexes: true,
      hidden: false,
      priority: 0,
      tags: {},
      secondaryDelaySecs: Long('0'),
      votes: 1
    }
  ],
  protocolVersion: Long('1'),
  writeConcernMajorityJournalDefault: true,
  settings: {
    chainingAllowed: true,
    heartbeatIntervalMillis: 2000,
    heartbeatTimeoutSecs: 10,
    electionTimeoutMillis: 10000,
    catchUpTimeoutMillis: -1,
    catchUpTakeoverDelayMillis: 30000,
    getLastErrorModes: {},
    getLastErrorDefaults: { w: 1, wtimeout: 0 },
    replicaSetId: ObjectId('66bb3b26c2fce6f24a4b566e')
  }
}


rs0 [direct: primary] admin> rs.isMaster()
{
  _id: 'rs0',
  version: 5,
  term: 1,
  members: [
    {
      _id: 0,
      host: 'percona-mongodb-pri:27017',
      arbiterOnly: false,
      buildIndexes: true,
      hidden: false,
      priority: 10,
      tags: {},
      secondaryDelaySecs: Long('0'),
      votes: 1
    },
    {
      _id: 1,
      host: 'percona-mongodb-sec:27017',
      arbiterOnly: false,
      buildIndexes: true,
      hidden: false,
      priority: 1,
      tags: {},
      secondaryDelaySecs: Long('0'),
      votes: 1
    },
    {
      _id: 2,
      host: 'percona-mongodb-arb:27017',
      arbiterOnly: true,
      buildIndexes: true,
      hidden: false,
      priority: 0,
      tags: {},
      secondaryDelaySecs: Long('0'),
      votes: 1
    }
  ],
  protocolVersion: Long('1'),
  writeConcernMajorityJournalDefault: true,
  settings: {
    chainingAllowed: true,
    heartbeatIntervalMillis: 2000,
    heartbeatTimeoutSecs: 10,
    electionTimeoutMillis: 10000,
    catchUpTimeoutMillis: -1,
    catchUpTakeoverDelayMillis: 30000,
    getLastErrorModes: {},
    getLastErrorDefaults: { w: 1, wtimeout: 0 },
    replicaSetId: ObjectId('66bb3b26c2fce6f24a4b566e')
  }
}
rs0 [direct: primary] admin> rs.isMaster()
{
  topologyVersion: {
    processId: ObjectId('66bb3a77c2fce6f24a4b5608'),
    counter: Long('10')
  },
  hosts: [ 'percona-mongodb-pri:27017', 'percona-mongodb-sec:27017' ],
  arbiters: [ 'percona-mongodb-arb:27017' ],
  setName: 'rs0',
  setVersion: 5,
  ismaster: true,
  secondary: false,
  primary: 'percona-mongodb-pri:27017',
  me: 'percona-mongodb-pri:27017',
  electionId: ObjectId('7fffffff0000000000000001'),
  lastWrite: {
    opTime: { ts: Timestamp({ t: 1723547731, i: 5 }), t: Long('1') },
    lastWriteDate: ISODate('2024-08-13T11:15:31.000Z'),
    majorityOpTime: { ts: Timestamp({ t: 1723547731, i: 5 }), t: Long('1') },
    majorityWriteDate: ISODate('2024-08-13T11:15:31.000Z')
  },
  maxBsonObjectSize: 16777216,
  maxMessageSizeBytes: 48000000,
  maxWriteBatchSize: 100000,
  localTime: ISODate('2024-08-13T11:15:43.496Z'),
  logicalSessionTimeoutMinutes: 30,
  connectionId: 40,
  minWireVersion: 0,
  maxWireVersion: 21,
  readOnly: false,
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1723547731, i: 5 }),
    signature: {
      hash: Binary.createFromBase64('JCqzZmpn0ZfaDm0tkYJKHNJJcbs=', 0),
      keyId: Long('7402575446908338182')
    }
  },
  operationTime: Timestamp({ t: 1723547731, i: 5 }),
  isWritablePrimary: true
}



rs0 [direct: primary] admin> quit()
*/

-- Step 93 -->> On Node 2 (Verify the Secondary Node)
mongodb@percona-mongodb-sec:~$ mongosh --host 192.168.120.9 --port 27017 -u admin -p P#ssw0rd --authenticationDatabase admin
/*
Current Mongosh Log ID: 66bb408bcb43340dcdd56fd0
Connecting to:          mongodb://<credentials>@192.168.120.9:27017/?directConnection=true&authSource=admin&appName=mongosh+2.2.10
Using MongoDB:          7.0.12-7
Using Mongosh:          2.2.10
mongosh 2.2.15 is available for download: https://www.mongodb.com/try/download/shell

For mongosh info see: https://docs.mongodb.com/mongodb-shell/

rs0 [direct: secondary] test> show dbs
admin   140.00 KiB
config  316.00 KiB
local   476.00 KiB


rs0 [direct: secondary] test> use admin
switched to db admin

rs0 [direct: secondary] admin> db
admin

rs0 [direct: secondary] admin> rs.isMaster()
{
  topologyVersion: {
    processId: ObjectId('66bb3a875e5ce3bc0f962065'),
    counter: Long('6')
  },
  hosts: [ 'percona-mongodb-pri:27017', 'percona-mongodb-sec:27017' ],
  arbiters: [ 'percona-mongodb-arb:27017' ],
  setName: 'rs0',
  setVersion: 5,
  ismaster: false,
  secondary: true,
  primary: 'percona-mongodb-pri:27017',
  me: 'percona-mongodb-sec:27017',
  lastWrite: {
    opTime: { ts: Timestamp({ t: 1723547886, i: 1 }), t: Long('1') },
    lastWriteDate: ISODate('2024-08-13T11:18:06.000Z'),
    majorityOpTime: { ts: Timestamp({ t: 1723547886, i: 1 }), t: Long('1') },
    majorityWriteDate: ISODate('2024-08-13T11:18:06.000Z')
  },
  maxBsonObjectSize: 16777216,
  maxMessageSizeBytes: 48000000,
  maxWriteBatchSize: 100000,
  localTime: ISODate('2024-08-13T11:18:13.621Z'),
  logicalSessionTimeoutMinutes: 30,
  connectionId: 26,
  minWireVersion: 0,
  maxWireVersion: 21,
  readOnly: false,
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1723547886, i: 1 }),
    signature: {
      hash: Binary.createFromBase64('0AF5p1Dn4Xqj+lAqiAQEW3Ha+N8=', 0),
      keyId: Long('7402575446908338182')
    }
  },
  operationTime: Timestamp({ t: 1723547886, i: 1 }),
  isWritablePrimary: false
}


rs0 [direct: secondary] admin> rs.status()
{
  set: 'rs0',
  date: ISODate('2024-08-13T11:20:04.654Z'),
  myState: 2,
  term: Long('1'),
  syncSourceHost: 'percona-mongodb-pri:27017',
  syncSourceId: 0,
  heartbeatIntervalMillis: Long('2000'),
  majorityVoteCount: 2,
  writeMajorityCount: 2,
  votingMembersCount: 3,
  writableVotingMembersCount: 2,
  optimes: {
    lastCommittedOpTime: { ts: Timestamp({ t: 1723547996, i: 1 }), t: Long('1') },
    lastCommittedWallTime: ISODate('2024-08-13T11:19:56.554Z'),
    readConcernMajorityOpTime: { ts: Timestamp({ t: 1723547996, i: 1 }), t: Long('1') },
    appliedOpTime: { ts: Timestamp({ t: 1723547996, i: 1 }), t: Long('1') },
    durableOpTime: { ts: Timestamp({ t: 1723547996, i: 1 }), t: Long('1') },
    lastAppliedWallTime: ISODate('2024-08-13T11:19:56.554Z'),
    lastDurableWallTime: ISODate('2024-08-13T11:19:56.554Z')
  },
  lastStableRecoveryTimestamp: Timestamp({ t: 1723547956, i: 1 }),
  members: [
    {
      _id: 0,
      name: 'percona-mongodb-pri:27017',
      health: 1,
      state: 1,
      stateStr: 'PRIMARY',
      uptime: 1542,
      optime: { ts: Timestamp({ t: 1723547996, i: 1 }), t: Long('1') },
      optimeDurable: { ts: Timestamp({ t: 1723547996, i: 1 }), t: Long('1') },
      optimeDate: ISODate('2024-08-13T11:19:56.000Z'),
      optimeDurableDate: ISODate('2024-08-13T11:19:56.000Z'),
      lastAppliedWallTime: ISODate('2024-08-13T11:19:56.554Z'),
      lastDurableWallTime: ISODate('2024-08-13T11:19:56.554Z'),
      lastHeartbeat: ISODate('2024-08-13T11:20:04.422Z'),
      lastHeartbeatRecv: ISODate('2024-08-13T11:20:04.421Z'),
      pingMs: Long('0'),
      lastHeartbeatMessage: '',
      syncSourceHost: '',
      syncSourceId: -1,
      infoMessage: '',
      electionTime: Timestamp({ t: 1723546406, i: 2 }),
      electionDate: ISODate('2024-08-13T10:53:26.000Z'),
      configVersion: 5,
      configTerm: 1
    },
    {
      _id: 1,
      name: 'percona-mongodb-sec:27017',
      health: 1,
      state: 2,
      stateStr: 'SECONDARY',
      uptime: 1757,
      optime: { ts: Timestamp({ t: 1723547996, i: 1 }), t: Long('1') },
      optimeDate: ISODate('2024-08-13T11:19:56.000Z'),
      lastAppliedWallTime: ISODate('2024-08-13T11:19:56.554Z'),
      lastDurableWallTime: ISODate('2024-08-13T11:19:56.554Z'),
      syncSourceHost: 'percona-mongodb-pri:27017',
      syncSourceId: 0,
      infoMessage: '',
      configVersion: 5,
      configTerm: 1,
      self: true,
      lastHeartbeatMessage: ''
    },
    {
      _id: 2,
      name: 'percona-mongodb-arb:27017',
      health: 1,
      state: 7,
      stateStr: 'ARBITER',
      uptime: 771,
      lastHeartbeat: ISODate('2024-08-13T11:20:04.421Z'),
      lastHeartbeatRecv: ISODate('2024-08-13T11:20:04.422Z'),
      pingMs: Long('0'),
      lastHeartbeatMessage: '',
      syncSourceHost: '',
      syncSourceId: -1,
      infoMessage: '',
      configVersion: 5,
      configTerm: 1
    }
  ],
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1723547996, i: 1 }),
    signature: {
      hash: Binary.createFromBase64('LvDygH9DAYNYM4fxTyunbFwtQtw=', 0),
      keyId: Long('7402575446908338182')
    }
  },
  operationTime: Timestamp({ t: 1723547996, i: 1 })
}

rs0 [direct: secondary] admin> rs.conf()
{
  _id: 'rs0',
  version: 5,
  term: 1,
  members: [
    {
      _id: 0,
      host: 'percona-mongodb-pri:27017',
      arbiterOnly: false,
      buildIndexes: true,
      hidden: false,
      priority: 10,
      tags: {},
      secondaryDelaySecs: Long('0'),
      votes: 1
    },
    {
      _id: 1,
      host: 'percona-mongodb-sec:27017',
      arbiterOnly: false,
      buildIndexes: true,
      hidden: false,
      priority: 1,
      tags: {},
      secondaryDelaySecs: Long('0'),
      votes: 1
    },
    {
      _id: 2,
      host: 'percona-mongodb-arb:27017',
      arbiterOnly: true,
      buildIndexes: true,
      hidden: false,
      priority: 0,
      tags: {},
      secondaryDelaySecs: Long('0'),
      votes: 1
    }
  ],
  protocolVersion: Long('1'),
  writeConcernMajorityJournalDefault: true,
  settings: {
    chainingAllowed: true,
    heartbeatIntervalMillis: 2000,
    heartbeatTimeoutSecs: 10,
    electionTimeoutMillis: 10000,
    catchUpTimeoutMillis: -1,
    catchUpTakeoverDelayMillis: 30000,
    getLastErrorModes: {},
    getLastErrorDefaults: { w: 1, wtimeout: 0 },
    replicaSetId: ObjectId('66bb3b26c2fce6f24a4b566e')
  }
}


rs0 [direct: secondary] admin> quit()
*/

-- Step 94 -->> On Node 3 (Verify the Arbiter Node)
mongodb@percona-mongodb-arb:~$ mongosh --host 192.168.120.10 --port 27017 -u admin -p P#ssw0rd --authenticationDatabase admin
/*
Current Mongosh Log ID: 66bb41d262ac873ec7d56fd0
Connecting to:          mongodb://<credentials>@192.168.120.10:27017/?directConnection=true&authSource=admin&appName=mongosh+2.2.10
Using MongoDB:          7.0.12-7
Using Mongosh:          2.2.10
mongosh 2.2.15 is available for download: https://www.mongodb.com/try/download/shell

For mongosh info see: https://docs.mongodb.com/mongodb-shell/


rs0 [direct: arbiter] test> show dbs
MongoServerError[Unauthorized]: Command listDatabases requires authentication

rs0 [direct: arbiter] test> use admin
switched to db admin

rs0 [direct: arbiter] admin> db
admin

rs0 [direct: arbiter] admin> show dbs
MongoServerError[Unauthorized]: Command listDatabases requires authentication

rs0 [direct: arbiter] admin> rs.isMaster()
{
  topologyVersion: {
    processId: ObjectId('66bb3a8a8b05dafeae2d3a70'),
    counter: Long('2')
  },
  hosts: [ 'percona-mongodb-pri:27017', 'percona-mongodb-sec:27017' ],
  arbiters: [ 'percona-mongodb-arb:27017' ],
  setName: 'rs0',
  setVersion: 5,
  ismaster: false,
  secondary: false,
  primary: 'percona-mongodb-pri:27017',
  arbiterOnly: true,
  me: 'percona-mongodb-arb:27017',
  lastWrite: {
    opTime: { ts: Timestamp({ t: 1723548156, i: 1 }), t: Long('1') },
    lastWriteDate: ISODate('2024-08-13T11:22:36.000Z'),
    majorityOpTime: { ts: Timestamp({ t: 1723548156, i: 1 }), t: Long('1') },
    majorityWriteDate: ISODate('2024-08-13T11:22:36.000Z')
  },
  maxBsonObjectSize: 16777216,
  maxMessageSizeBytes: 48000000,
  maxWriteBatchSize: 100000,
  localTime: ISODate('2024-08-13T11:22:48.044Z'),
  logicalSessionTimeoutMinutes: 30,
  connectionId: 20,
  minWireVersion: 0,
  maxWireVersion: 21,
  readOnly: false,
  ok: 1,
  isWritablePrimary: false
}


rs0 [direct: arbiter] admin> rs.status()
MongoServerError[Unauthorized]: Command replSetGetStatus requires authentication

rs0 [direct: arbiter] admin> quit()
*/

-- Step 95 -->> On Node 1 (Verify the Primary and Secondary Replication)
mongodb@percona-mongodb-pri:~$ mongosh --host 192.168.120.7  --port 27017 -u admin -p P#ssw0rd --authenticationDatabase admin
/*
Current Mongosh Log ID: 667986582e84edd84e597192
Connecting to:          mongodb://<credentials>@192.168.120.70:27017/?directConnection=true&authSource=admin&appName=mongosh+2.2.9
Using MongoDB:          7.0.11
Using Mongosh:          2.2.9

For mongosh info see: https://docs.mongodb.com/mongodb-shell/


rs0 [direct: primary] test> show dbs
admin   172.00 KiB
config  252.00 KiB
local   484.00 KiB



rs0 [direct: primary] test> use admin
switched to db admin

rs0 [direct: primary] admin> db
admin

rs0 [direct: primary] admin> db.getUsers()
{
  users: [
    {
      _id: 'admin.admin',
      userId: UUID('a74a70c7-60d2-413e-8e2d-d06ced87436b'),
      user: 'admin',
      db: 'admin',
      roles: [
        { role: 'clusterAdmin', db: 'admin' },
        { role: 'userAdminAnyDatabase', db: 'admin' },
        { role: 'root', db: 'admin' }
      ],
      mechanisms: [ 'SCRAM-SHA-1', 'SCRAM-SHA-256' ]
    }
  ],
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1723548246, i: 1 }),
    signature: {
      hash: Binary.createFromBase64('G0mYxuUicwWjaeDE2Ze+JaKc670=', 0),
      keyId: Long('7402575446908338182')
    }
  },
  operationTime: Timestamp({ t: 1723548246, i: 1 })
}



rs0 [direct: primary] admin> use rabin
switched to db rabin

rs0 [direct: primary] rabin>db
rabin

rs0 [direct: primary] rabin> db.createUser(
...    {
...    user:"rabin",
...    pwd:"rabin123",
...    roles:["readWrite"]
...    }
...    )
{
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1723548683, i: 1 }),
    signature: {
      hash: Binary.createFromBase64('dh1Rb3mBQIfPxuSfm0+d63B1eRc=', 0),
      keyId: Long('7402575446908338182')
    }
  },
  operationTime: Timestamp({ t: 1723548683, i: 1 })
}



rs0 [direct: primary] rabin> db.auth("rabin","rabin123")
{ ok: 1 }

rs0 [direct: primary] rabin> db.createCollection('tbl_cib')
{ ok: 1 }

rs0 [direct: primary] rabin> show collections
tbl_cib

rs0 [direct: primary] rabin> db.getCollectionNames()
[ 'tbl_cib' ]

rs0 [direct: primary] rabin> quit()
*/

-- Step 96 -->> On Node 1 (Verify the Primary and Secondary Replication)
mongodb@percona-mongodb-pri:~$ mongosh --host 192.168.120.7  --port 27017 -u rabin -p rabin123 --authenticationDatabase rabin
/*
Current Mongosh Log ID: 66bb445d68db76d45dd56fd0
Connecting to:          mongodb://<credentials>@192.168.120.7:27017/?directConnection=true&authSource=rabin&appName=mongosh+2.2.10
Using MongoDB:          7.0.12-7
Using Mongosh:          2.2.10
mongosh 2.2.15 is available for download: https://www.mongodb.com/try/download/shell

For mongosh info see: https://docs.mongodb.com/mongodb-shell/


rs0 [direct: primary] test> show dbs
rabin  8.00 KiB

rs0 [direct: primary] test> use rabin
switched to db rabin

rs0 [direct: primary] rabin> db.getCollectionNames()
[ 'tbl_cib' ]

rs0 [direct: primary] rabin> quit()
*/

-- Step 97 -->> On Node 2 (Verify the Primary and Secondary Replication)
mongodb@percona-mongodb-sec:~$ mongosh --host 192.168.120.9  --port 27017 -u rabin -p rabin123 --authenticationDatabase rabin
/*
Current Mongosh Log ID: 66bb449f1eb311218fd56fd0
Connecting to:          mongodb://<credentials>@192.168.120.9:27017/?directConnection=true&authSource=rabin&appName=mongosh+2.2.10
Using MongoDB:          7.0.12-7
Using Mongosh:          2.2.10
mongosh 2.2.15 is available for download: https://www.mongodb.com/try/download/shell

For mongosh info see: https://docs.mongodb.com/mongodb-shell/



rs0 [direct: secondary] test> show dbs
rabin  8.00 KiB

rs0 [direct: secondary] test> use rabin
switched to db rabin

rs0 [direct: secondary] rabin> db
rabin

rs0 [direct: secondary] rabin> use rabin
tbl_cib

rs0 [direct: secondary] rabin> db.getCollectionNames()
[ 'tbl_cib' ]

rs0 [direct: secondary] rabin> quit()
*/


-- Failed Over Test
-- Step 98 -->> On Node 1 (Stop the MongoDB Serivice at Primary Node i.e. Node 1)
mongodb@percona-mongodb-pri:~$ sudo systemctl stop mongod.service

-- Step 99 -->> On Node 1 (Verify the MongoDB Serivice at Primary Node i.e. Node 1)
mongodb@percona-mongodb-pri:~$ sudo systemctl status mongod.service
/*
○ mongod.service - High-performance, schema-free document-oriented database
     Loaded: loaded (/lib/systemd/system/mongod.service; enabled; vendor preset: enabled)
     Active: inactive (dead) since Tue 2024-08-13 11:35:21 UTC; 7s ago
    Process: 1890 ExecStartPre=/usr/bin/percona-server-mongodb-helper.sh (code=exited, status=0/SUCCESS)
    Process: 1909 ExecStart=/usr/bin/env bash -c ${NUMACTL} /usr/bin/mongod ${OPTIONS} > ${STDOUT} 2> ${STDERR} (code=exited, status=0/SUCCESS)
   Main PID: 1912 (code=exited, status=0/SUCCESS)
        CPU: 30.399s

Aug 13 10:50:31 percona-mongodb-pri.com systemd[1]: Starting High-performance, schema-free document-oriented database...
Aug 13 10:50:31 percona-mongodb-pri.com systemd[1]: Started High-performance, schema-free document-oriented database.
Aug 13 11:35:06 percona-mongodb-pri.com systemd[1]: Stopping High-performance, schema-free document-oriented database...
Aug 13 11:35:21 percona-mongodb-pri.com systemd[1]: mongod.service: Deactivated successfully.
Aug 13 11:35:21 percona-mongodb-pri.com systemd[1]: Stopped High-performance, schema-free document-oriented database.
Aug 13 11:35:21 percona-mongodb-pri.com systemd[1]: mongod.service: Consumed 30.399s CPU time.
mongodb@percona-mongodb-pri:~$ sudo systemctl start mongod.service

*/
.
-- Step 100 -->> On Node 2 (Verify the MongoDB Serivice at Secondary Node i.e. Node 2)
mongodb@percona-mongodb-sec:~$ sudo systemctl status mongod.service
/*
●● mongod.service - High-performance, schema-free document-oriented database
     Loaded: loaded (/lib/systemd/system/mongod.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2024-08-13 10:50:48 UTC; 45min ago
    Process: 2481 ExecStartPre=/usr/bin/percona-server-mongodb-helper.sh (code=exited, status=0/SUCCESS)
    Process: 2499 ExecStart=/usr/bin/env bash -c ${NUMACTL} /usr/bin/mongod ${OPTIONS} > ${STDOUT} 2> ${STDERR} (code=exited, status=0/SUCCESS)
   Main PID: 2502 (mongod)
      Tasks: 90 (limit: 4513)
     Memory: 201.0M
        CPU: 33.882s
     CGroup: /system.slice/mongod.service
             └─2502 /usr/bin/mongod -f /etc/mongod.conf

Aug 13 10:50:47 percona-mongodb-sec.com systemd[1]: Starting High-performance, schema-free document-oriented database...
Aug 13 10:50:48 percona-mongodb-sec.com systemd[1]: Started High-performance, schema-free document-oriented database.
*/

-- Step 101 -->> On Node 2 (Verify the MongoDB Serivice at Secondary Node i.e. Node 2)
mongodb@percona-mongodb-sec:~$ mongosh --host 192.168.120.9 --port 27017 -u admin -p P#ssw0rd --authenticationDatabase admin
/*
Current Mongosh Log ID: 6679980cc58b758931597192
Connecting to:          mongodb://<credentials>@192.168.120.71:27017/?directConnection=true&authSource=admin&appName=mongosh+2.2.9
Using MongoDB:          7.0.11
Using Mongosh:          2.2.9

For mongosh info see: https://docs.mongodb.com/mongodb-shell/


rs0 [direct: primary] test> show dbs
admin   188.00 KiB
config  316.00 KiB
local   484.00 KiB
rabin     8.00 KiB

rs0 [direct: primary] test> use admin
switched to db admin

rs0 [direct: primary] admin> db
admin

rs0 [direct: primary] admin> rs.isMaster()
{
  topologyVersion: {
    processId: ObjectId('66797b4353d47c25b759a523'),
    counter: Long('10')
  },
  hosts: [ 'percona-mongodb-pri:27017', 'percona-mongodb-sec:27017' ],
  arbiters: [ 'percona-mongodb-arb:27017' ],
  setName: 'rs0',
  setVersion: 5,
  ismaster: true,
  secondary: false,
  primary: 'percona-mongodb-sec:27017',
  me: 'percona-mongodb-sec:27017',
  electionId: ObjectId('7fffffff0000000000000004'),
  lastWrite: {
    opTime: { ts: Timestamp({ t: 1719244874, i: 1 }), t: Long('4') },
    lastWriteDate: ISODate('2024-06-24T16:01:14.000Z'),
    majorityOpTime: { ts: Timestamp({ t: 1719244654, i: 2 }), t: Long('4') },
    majorityWriteDate: ISODate('2024-06-24T15:57:34.000Z')
  },
  maxBsonObjectSize: 16777216,
  maxMessageSizeBytes: 48000000,
  maxWriteBatchSize: 100000,
  localTime: ISODate('2024-06-24T16:01:18.267Z'),
  logicalSessionTimeoutMinutes: 30,
  connectionId: 62,
  minWireVersion: 0,
  maxWireVersion: 21,
  readOnly: false,
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1719244874, i: 1 }),
    signature: {
      hash: Binary.createFromBase64('47GpQTYhbuJgJ5NmgDePeIkvXh0=', 0),
      keyId: Long('7384069845874114566')
    }
  },
  operationTime: Timestamp({ t: 1719244874, i: 1 }),
  isWritablePrimary: true
}


rs0 [direct: primary] admin> rs.status()
{
  set: 'rs0',
  date: ISODate('2024-06-24T16:02:10.452Z'),
  myState: 1,
  term: Long('4'),
  syncSourceHost: '',
  syncSourceId: -1,
  heartbeatIntervalMillis: Long('2000'),
  majorityVoteCount: 2,
  writeMajorityCount: 2,
  votingMembersCount: 3,
  writableVotingMembersCount: 2,
  optimes: {
    lastCommittedOpTime: { ts: Timestamp({ t: 1719244654, i: 2 }), t: Long('4') },
    lastCommittedWallTime: ISODate('2024-06-24T15:57:34.733Z'),
    readConcernMajorityOpTime: { ts: Timestamp({ t: 1719244654, i: 2 }), t: Long('4') },
    appliedOpTime: { ts: Timestamp({ t: 1719244924, i: 1 }), t: Long('4') },
    durableOpTime: { ts: Timestamp({ t: 1719244924, i: 1 }), t: Long('4') },
    lastAppliedWallTime: ISODate('2024-06-24T16:02:04.749Z'),
    lastDurableWallTime: ISODate('2024-06-24T16:02:04.749Z')
  },
  lastStableRecoveryTimestamp: Timestamp({ t: 1719244654, i: 2 }),
  electionCandidateMetrics: {
    lastElectionReason: 'electionTimeout',
    lastElectionDate: ISODate('2024-06-24T15:57:34.724Z'),
    electionTerm: Long('4'),
    lastCommittedOpTimeAtElection: { ts: Timestamp({ t: 1719244643, i: 1 }), t: Long('2') },
    lastSeenOpTimeAtElection: { ts: Timestamp({ t: 1719244643, i: 1 }), t: Long('2') },
    numVotesNeeded: 2,
    priorityAtElection: 1,
    electionTimeoutMillis: Long('10000'),
    numCatchUpOps: Long('0'),
    newTermStartDate: ISODate('2024-06-24T15:57:34.733Z'),
    wMajorityWriteAvailabilityDate: ISODate('2024-06-24T15:57:34.747Z')
  },
  electionParticipantMetrics: {
    votedForCandidate: true,
    electionTerm: Long('2'),
    lastVoteDate: ISODate('2024-06-24T15:48:53.096Z'),
    electionCandidateMemberId: 0,
    voteReason: '',
    lastAppliedOpTimeAtElection: { ts: Timestamp({ t: 1719241802, i: 1 }), t: Long('1') },
    maxAppliedOpTimeInSet: { ts: Timestamp({ t: 1719241802, i: 1 }), t: Long('1') },
    priorityAtElection: 1
  },
  members: [
    {
      _id: 0,
      name: 'percona-mongodb-pri:27017',
      health: 0,
      state: 8,
      stateStr: '(not reachable/healthy)',
      uptime: 0,
      optime: { ts: Timestamp({ t: 0, i: 0 }), t: Long('-1') },
      optimeDurable: { ts: Timestamp({ t: 0, i: 0 }), t: Long('-1') },
      optimeDate: ISODate('1970-01-01T00:00:00.000Z'),
      optimeDurableDate: ISODate('1970-01-01T00:00:00.000Z'),
      lastAppliedWallTime: ISODate('2024-06-24T15:57:34.733Z'),
      lastDurableWallTime: ISODate('2024-06-24T15:57:34.733Z'),
      lastHeartbeat: ISODate('2024-06-24T16:02:09.041Z'),
      lastHeartbeatRecv: ISODate('2024-06-24T15:57:39.239Z'),
      pingMs: Long('0'),
      lastHeartbeatMessage: 'Error connecting to percona-mongodb-pri:27017 (192.168.120.70:27017) :: caused by :: onInvoke :: caused by :: Connection refused',
      syncSourceHost: '',
      syncSourceId: -1,
      infoMessage: '',
      configVersion: 5,
      configTerm: 4
    },
    {
      _id: 1,
      name: 'percona-mongodb-sec:27017',
      health: 1,
      state: 1,
      stateStr: 'PRIMARY',
      uptime: 7488,
      optime: { ts: Timestamp({ t: 1719244924, i: 1 }), t: Long('4') },
      optimeDate: ISODate('2024-06-24T16:02:04.000Z'),
      lastAppliedWallTime: ISODate('2024-06-24T16:02:04.749Z'),
      lastDurableWallTime: ISODate('2024-06-24T16:02:04.749Z'),
      syncSourceHost: '',
      syncSourceId: -1,
      infoMessage: '',
      electionTime: Timestamp({ t: 1719244654, i: 1 }),
      electionDate: ISODate('2024-06-24T15:57:34.000Z'),
      configVersion: 5,
      configTerm: 4,
      self: true,
      lastHeartbeatMessage: ''
    },
    {
      _id: 2,
      name: 'percona-mongodb-arb:27017',
      health: 1,
      state: 7,
      stateStr: 'ARBITER',
      uptime: 805,
      lastHeartbeat: ISODate('2024-06-24T16:02:08.985Z'),
      lastHeartbeatRecv: ISODate('2024-06-24T16:02:08.984Z'),
      pingMs: Long('0'),
      lastHeartbeatMessage: '',
      syncSourceHost: '',
      syncSourceId: -1,
      infoMessage: '',
      configVersion: 5,
      configTerm: 4
    }
  ],
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1719244924, i: 1 }),
    signature: {
      hash: Binary.createFromBase64('Ta/e2OyqxjvrZgKGHZ9vqPtd9NQ=', 0),
      keyId: Long('7384069845874114566')
    }
  },
  operationTime: Timestamp({ t: 1719244924, i: 1 })
}


rs0 [direct: primary] admin> rs.conf()
{
  _id: 'rs0',
  version: 5,
  term: 4,
  members: [
    {
      _id: 0,
      host: 'percona-mongodb-pri:27017',
      arbiterOnly: false,
      buildIndexes: true,
      hidden: false,
      priority: 10,
      tags: {},
      secondaryDelaySecs: Long('0'),
      votes: 1
    },
    {
      _id: 1,
      host: 'percona-mongodb-sec:27017',
      arbiterOnly: false,
      buildIndexes: true,
      hidden: false,
      priority: 1,
      tags: {},
      secondaryDelaySecs: Long('0'),
      votes: 1
    },
    {
      _id: 2,
      host: 'percona-mongodb-arb:27017',
      arbiterOnly: true,
      buildIndexes: true,
      hidden: false,
      priority: 0,
      tags: {},
      secondaryDelaySecs: Long('0'),
      votes: 1
    }
  ],
  protocolVersion: Long('1'),
  writeConcernMajorityJournalDefault: true,
  settings: {
    chainingAllowed: true,
    heartbeatIntervalMillis: 2000,
    heartbeatTimeoutSecs: 10,
    electionTimeoutMillis: 10000,
    catchUpTimeoutMillis: -1,
    catchUpTakeoverDelayMillis: 30000,
    getLastErrorModes: {},
    getLastErrorDefaults: { w: 1, wtimeout: 0 },
    replicaSetId: ObjectId('66797c679c4daa8cd22bf69c')
  }
}


rs0 [direct: primary] admin> db.getUsers()
{
  users: [
    {
      _id: 'admin.admin',
      userId: UUID('c2a82dd9-45ab-4388-86cb-9ef3578c4434'),
      user: 'admin',
      db: 'admin',
      roles: [
        { role: 'root', db: 'admin' },
        { role: 'clusterAdmin', db: 'admin' },
        { role: 'userAdminAnyDatabase', db: 'admin' }
      ],
      mechanisms: [ 'SCRAM-SHA-1', 'SCRAM-SHA-256' ]
    }
  ],
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1719245104, i: 1 }),
    signature: {
      hash: Binary.createFromBase64('pY1m9urWEDj+6JmBIE0iZjPM5hs=', 0),
      keyId: Long('7384069845874114566')
    }
  },
  operationTime: Timestamp({ t: 1719245104, i: 1 })
}

rs0 [direct: primary] admin> use rabin
switched to db rabin

rs0 [direct: primary] rabin> db
rabin

rs0 [direct: primary] rabin> db.getCollectionNames()
[ 'tbl_cib' ]

rs0 [direct: primary] rabin> quit()

*/

-- Step 102 -->> On Node 2 (Stop the MongoDB Serivice at Secondary Node i.e. Node 2)
mongodb@percona-mongodb-sec:~$ sudo systemctl stop mongod.service

-- Step 103 -->> On Node 2 (Verify the MongoDB Serivice at Secondary Node i.e. Node 2)
mongodb@percona-mongodb-sec:~$ sudo systemctl status mongod.service
/*
○ mongod.service - MongoDB Database Server
     Loaded: loaded (/lib/systemd/system/mongod.service; enabled; vendor preset: enabled)
     Active: inactive (dead) since Mon 2024-06-24 21:54:48 +0545; 15s ago
       Docs: https://docs.mongodb.org/manual
    Process: 1429 ExecStart=/usr/bin/mongod --config /etc/mongod.conf (code=exited, status=0/SUCCESS)
   Main PID: 1429 (code=exited, status=0/SUCCESS)
        CPU: 1min 22.288s

Jun 24 19:42:22 percona-mongodb-sec.com.np systemd[1]: Started MongoDB Database Server.
Jun 24 19:42:23 percona-mongodb-sec.com.np mongod[1429]: {"t":{"$date":"2024-06-24T13:57:23.011Z"},"s":"I",  "c":"CONTROL",  "id":7484500, "ctx":"main","msg>
Jun 24 21:54:32 percona-mongodb-sec.com.np systemd[1]: Stopping MongoDB Database Server...
Jun 24 21:54:48 percona-mongodb-sec.com.np systemd[1]: mongod.service: Deactivated successfully.
Jun 24 21:54:48 percona-mongodb-sec.com.np systemd[1]: Stopped MongoDB Database Server.
Jun 24 21:54:48 percona-mongodb-sec.com.np systemd[1]: mongod.service: Consumed 1min 22.288s CPU time.

*/

-- Step 104 -->> On Node 3 (Verify the MongoDB Serivice at Arbiter Node i.e. Node 3)
mongodb@percona-mongodb-arb:~$ mongo --host 192.168.120.10 --port 27017 -u admin -p P#ssw0rd --authenticationDatabase admin
/*
Current Mongosh Log ID: 66bc397dd1389aeb29d56fd0
Connecting to:          mongodb://<credentials>@192.168.120.10:27017/?directConnection=true&authSource=admin&appName=mongosh+2.2.10
Using MongoDB:          7.0.12-7
Using Mongosh:          2.2.10
mongosh 2.2.15 is available for download: https://www.mongodb.com/try/download/shell

For mongosh info see: https://docs.mongodb.com/mongodb-shell/



rs0 [direct: arbiter] test> use admin
switched to db admin

rs0 [direct: arbiter] admin> db
admin

rs0 [direct: arbiter] admin> show dbs
MongoServerError[Unauthorized]: Command listDatabases requires authentication

rs0 [direct: arbiter] admin> rs.isMaster()
{
  topologyVersion: {
    processId: ObjectId('66bc370476f86448818365b8'),
    counter: Long('4')
  },
  hosts: [ 'percona-mongodb-pri:27017', 'percona-mongodb-sec:27017' ],
  arbiters: [ 'percona-mongodb-arb:27017' ],
  setName: 'rs0',
  setVersion: 5,
  ismaster: false,
  secondary: false,
  primary: 'percona-mongodb-pri:27017',
  arbiterOnly: true,
  me: 'percona-mongodb-arb:27017',
  lastWrite: {
    opTime: { ts: Timestamp({ t: 1723611591, i: 1 }), t: Long('7') },
    lastWriteDate: ISODate('2024-08-14T04:59:51.000Z'),
    majorityOpTime: { ts: Timestamp({ t: 1723611591, i: 1 }), t: Long('7') },
    majorityWriteDate: ISODate('2024-08-14T04:59:51.000Z')
  },
  maxBsonObjectSize: 16777216,
  maxMessageSizeBytes: 48000000,
  maxWriteBatchSize: 100000,
  localTime: ISODate('2024-08-14T04:59:58.312Z'),
  logicalSessionTimeoutMinutes: 30,
  connectionId: 25,
  minWireVersion: 0,
  maxWireVersion: 21,
  readOnly: false,
  ok: 1,
  isWritablePrimary: false
}


rs0 [direct: arbiter] admin> quit()
*/

-- Step 105 -->> On Node 1 (Start the MongoDB Serivice at Primary Node i.e. Node 1)
mongodb@percona-mongodb-pri:~$ sudo systemctl start mongod.service

-- Step 106 -->> On Node 1 (Verify the MongoDB Serivice at Primary Node i.e. Node 1)
mongodb@percona-mongodb-pri:~$ sudo systemctl status mongod.service
/*
●● mongod.service - High-performance, schema-free document-oriented database
     Loaded: loaded (/lib/systemd/system/mongod.service; enabled; vendor preset: enabled)
     Active: active (running) since Wed 2024-08-14 04:47:46 UTC; 13min ago
    Process: 1027 ExecStartPre=/usr/bin/percona-server-mongodb-helper.sh (code=exited, status=0/SUCCESS)
    Process: 1060 ExecStart=/usr/bin/env bash -c ${NUMACTL} /usr/bin/mongod ${OPTIONS} > ${STDOUT} 2> ${STDERR} (code=exited, status=0/SUCCESS)
   Main PID: 1091 (mongod)
      Tasks: 80 (limit: 4513)
     Memory: 295.0M
        CPU: 11.996s
     CGroup: /system.slice/mongod.service
             └─1091 /usr/bin/mongod -f /etc/mongod.conf

Aug 14 04:47:44 percona-mongodb-pri.com systemd[1]: Starting High-performance, schema-free document-oriented database...
Aug 14 04:47:46 percona-mongodb-pri.com systemd[1]: Started High-performance, schema-free document-oriented database.

*/

-- Step 107 -->> On Node 1 (Verify the MongoDB Serivice at Primary Node i.e. Node 1)
mongodb@percona-mongodb-pri:~$ mongosh --host 192.168.120.7  --port 27017 -u admin -p P#ssw0rd --authenticationDatabase admin
/*
Current Mongosh Log ID: 66bc3a3816a69e6417d56fd0
Connecting to:          mongodb://<credentials>@192.168.120.7:27017/?directConnection=true&authSource=admin&appName=mongosh+2.2.10
Using MongoDB:          7.0.12-7
Using Mongosh:          2.2.10
mongosh 2.2.15 is available for download: https://www.mongodb.com/try/download/shell

For mongosh info see: https://docs.mongodb.com/mongodb-shell/


rs0 [direct: primary] test> show dbs
admin   220.00 KiB
config  248.00 KiB
local   508.00 KiB
rabin     8.00 KiB


rs0 [direct: primary] test> use admin
switched to db admin

rs0 [direct: primary] admin> db
admin

rs0 [direct: primary] admin> db.getUsers()
{
  users: [
    {
      _id: 'admin.admin',
      userId: UUID('a74a70c7-60d2-413e-8e2d-d06ced87436b'),
      user: 'admin',
      db: 'admin',
      roles: [
        { role: 'clusterAdmin', db: 'admin' },
        { role: 'userAdminAnyDatabase', db: 'admin' },
        { role: 'root', db: 'admin' }
      ],
      mechanisms: [ 'SCRAM-SHA-1', 'SCRAM-SHA-256' ]
    }
  ],
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1723611741, i: 1 }),
    signature: {
      hash: Binary.createFromBase64('xd86ZNUrOpMNM9VsvxBB5x0o4JI=', 0),
      keyId: Long('7402575446908338182')
    }
  },
  operationTime: Timestamp({ t: 1723611741, i: 1 })
}


rs0 [direct: primary] admin> rs.isMaster()
{
  topologyVersion: {
    processId: ObjectId('66bc36f1d46f73b1fb6ed1fb'),
    counter: Long('11')
  },
  hosts: [ 'percona-mongodb-pri:27017', 'percona-mongodb-sec:27017' ],
  arbiters: [ 'percona-mongodb-arb:27017' ],
  setName: 'rs0',
  setVersion: 5,
  ismaster: true,
  secondary: false,
  primary: 'percona-mongodb-pri:27017',
  me: 'percona-mongodb-pri:27017',
  electionId: ObjectId('7fffffff0000000000000007'),
  lastWrite: {
    opTime: { ts: Timestamp({ t: 1723611766, i: 4 }), t: Long('7') },
    lastWriteDate: ISODate('2024-08-14T05:02:46.000Z'),
    majorityOpTime: { ts: Timestamp({ t: 1723611766, i: 4 }), t: Long('7') },
    majorityWriteDate: ISODate('2024-08-14T05:02:46.000Z')
  },
  maxBsonObjectSize: 16777216,
  maxMessageSizeBytes: 48000000,
  maxWriteBatchSize: 100000,
  localTime: ISODate('2024-08-14T05:02:52.441Z'),
  logicalSessionTimeoutMinutes: 30,
  connectionId: 49,
  minWireVersion: 0,
  maxWireVersion: 21,
  readOnly: false,
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1723611766, i: 4 }),
    signature: {
      hash: Binary.createFromBase64('jumunDubWFindCLj0S5eFzQ4Ikw=', 0),
      keyId: Long('7402575446908338182')
    }
  },
  operationTime: Timestamp({ t: 1723611766, i: 4 }),
  isWritablePrimary: true
}


rs0 [direct: primary] admin> rs.conf()
{
  _id: 'rs0',
  version: 5,
  term: 7,
  members: [
    {
      _id: 0,
      host: 'percona-mongodb-pri:27017',
      arbiterOnly: false,
      buildIndexes: true,
      hidden: false,
      priority: 10,
      tags: {},
      secondaryDelaySecs: Long('0'),
      votes: 1
    },
    {
      _id: 1,
      host: 'percona-mongodb-sec:27017',
      arbiterOnly: false,
      buildIndexes: true,
      hidden: false,
      priority: 1,
      tags: {},
      secondaryDelaySecs: Long('0'),
      votes: 1
    },
    {
      _id: 2,
      host: 'percona-mongodb-arb:27017',
      arbiterOnly: true,
      buildIndexes: true,
      hidden: false,
      priority: 0,
      tags: {},
      secondaryDelaySecs: Long('0'),
      votes: 1
    }
  ],
  protocolVersion: Long('1'),
  writeConcernMajorityJournalDefault: true,
  settings: {
    chainingAllowed: true,
    heartbeatIntervalMillis: 2000,
    heartbeatTimeoutSecs: 10,
    electionTimeoutMillis: 10000,
    catchUpTimeoutMillis: -1,
    catchUpTakeoverDelayMillis: 30000,
    getLastErrorModes: {},
    getLastErrorDefaults: { w: 1, wtimeout: 0 },
    replicaSetId: ObjectId('66bb3b26c2fce6f24a4b566e')
  }
}

rs0 [direct: primary] admin> rs.conf()
{
  _id: 'rs0',
  version: 5,
  term: 7,
  members: [
    {
      _id: 0,
      host: 'percona-mongodb-pri:27017',
      arbiterOnly: false,
      buildIndexes: true,
      hidden: false,
      priority: 10,
      tags: {},
      secondaryDelaySecs: Long('0'),
      votes: 1
    },
    {
      _id: 1,
      host: 'percona-mongodb-sec:27017',
      arbiterOnly: false,
      buildIndexes: true,
      hidden: false,
      priority: 1,
      tags: {},
      secondaryDelaySecs: Long('0'),
      votes: 1
    },
    {
      _id: 2,
      host: 'percona-mongodb-arb:27017',
      arbiterOnly: true,
      buildIndexes: true,
      hidden: false,
      priority: 0,
      tags: {},
      secondaryDelaySecs: Long('0'),
      votes: 1
    }
  ],
  protocolVersion: Long('1'),
  writeConcernMajorityJournalDefault: true,
  settings: {
    chainingAllowed: true,
    heartbeatIntervalMillis: 2000,
    heartbeatTimeoutSecs: 10,
    electionTimeoutMillis: 10000,
    catchUpTimeoutMillis: -1,
    catchUpTakeoverDelayMillis: 30000,
    getLastErrorModes: {},
    getLastErrorDefaults: { w: 1, wtimeout: 0 },
    replicaSetId: ObjectId('66bb3b26c2fce6f24a4b566e')
  }
}

rs0 [direct: primary] admin> rs.status()
{
  set: 'rs0',
  date: ISODate('2024-08-14T05:04:05.733Z'),
  myState: 1,
  term: Long('7'),
  syncSourceHost: '',
  syncSourceId: -1,
  heartbeatIntervalMillis: Long('2000'),
  majorityVoteCount: 2,
  writeMajorityCount: 2,
  votingMembersCount: 3,
  writableVotingMembersCount: 2,
  optimes: {
    lastCommittedOpTime: { ts: Timestamp({ t: 1723611841, i: 1 }), t: Long('7') },
    lastCommittedWallTime: ISODate('2024-08-14T05:04:01.841Z'),
    readConcernMajorityOpTime: { ts: Timestamp({ t: 1723611841, i: 1 }), t: Long('7') },
    appliedOpTime: { ts: Timestamp({ t: 1723611841, i: 1 }), t: Long('7') },
    durableOpTime: { ts: Timestamp({ t: 1723611841, i: 1 }), t: Long('7') },
    lastAppliedWallTime: ISODate('2024-08-14T05:04:01.841Z'),
    lastDurableWallTime: ISODate('2024-08-14T05:04:01.841Z')
  },
  lastStableRecoveryTimestamp: Timestamp({ t: 1723611821, i: 1 }),
  electionCandidateMetrics: {
    lastElectionReason: 'priorityTakeover',
    lastElectionDate: ISODate('2024-08-14T04:49:51.782Z'),
    electionTerm: Long('7'),
    lastCommittedOpTimeAtElection: { ts: Timestamp({ t: 1723610991, i: 1 }), t: Long('6') },
    lastSeenOpTimeAtElection: { ts: Timestamp({ t: 1723610991, i: 1 }), t: Long('6') },
    numVotesNeeded: 2,
    priorityAtElection: 10,
    electionTimeoutMillis: Long('10000'),
    priorPrimaryMemberId: 1,
    numCatchUpOps: Long('0'),
    newTermStartDate: ISODate('2024-08-14T04:49:51.789Z'),
    wMajorityWriteAvailabilityDate: ISODate('2024-08-14T04:49:51.802Z')
  },
  electionParticipantMetrics: {
    votedForCandidate: true,
    electionTerm: Long('6'),
    lastVoteDate: ISODate('2024-08-14T04:49:41.421Z'),
    electionCandidateMemberId: 1,
    voteReason: '',
    lastAppliedOpTimeAtElection: { ts: Timestamp({ t: 1723610968, i: 1 }), t: Long('5') },
    maxAppliedOpTimeInSet: { ts: Timestamp({ t: 1723610968, i: 1 }), t: Long('5') },
    priorityAtElection: 10
  },
  members: [
    {
      _id: 0,
      name: 'percona-mongodb-pri:27017',
      health: 1,
      state: 1,
      stateStr: 'PRIMARY',
      uptime: 980,
      optime: { ts: Timestamp({ t: 1723611841, i: 1 }), t: Long('7') },
      optimeDate: ISODate('2024-08-14T05:04:01.000Z'),
      lastAppliedWallTime: ISODate('2024-08-14T05:04:01.841Z'),
      lastDurableWallTime: ISODate('2024-08-14T05:04:01.841Z'),
      syncSourceHost: '',
      syncSourceId: -1,
      infoMessage: '',
      electionTime: Timestamp({ t: 1723610991, i: 2 }),
      electionDate: ISODate('2024-08-14T04:49:51.000Z'),
      configVersion: 5,
      configTerm: 7,
      self: true,
      lastHeartbeatMessage: ''
    },
    {
      _id: 1,
      name: 'percona-mongodb-sec:27017',
      health: 1,
      state: 2,
      stateStr: 'SECONDARY',
      uptime: 872,
      optime: { ts: Timestamp({ t: 1723611841, i: 1 }), t: Long('7') },
      optimeDurable: { ts: Timestamp({ t: 1723611841, i: 1 }), t: Long('7') },
      optimeDate: ISODate('2024-08-14T05:04:01.000Z'),
      optimeDurableDate: ISODate('2024-08-14T05:04:01.000Z'),
      lastAppliedWallTime: ISODate('2024-08-14T05:04:01.841Z'),
      lastDurableWallTime: ISODate('2024-08-14T05:04:01.841Z'),
      lastHeartbeat: ISODate('2024-08-14T05:04:04.514Z'),
      lastHeartbeatRecv: ISODate('2024-08-14T05:04:05.101Z'),
      pingMs: Long('0'),
      lastHeartbeatMessage: '',
      syncSourceHost: 'percona-mongodb-pri:27017',
      syncSourceId: 0,
      infoMessage: '',
      configVersion: 5,
      configTerm: 7
    },
    {
      _id: 2,
      name: 'percona-mongodb-arb:27017',
      health: 1,
      state: 7,
      stateStr: 'ARBITER',
      uptime: 874,
      lastHeartbeat: ISODate('2024-08-14T05:04:04.514Z'),
      lastHeartbeatRecv: ISODate('2024-08-14T05:04:04.514Z'),
      pingMs: Long('0'),
      lastHeartbeatMessage: '',
      syncSourceHost: '',
      syncSourceId: -1,
      infoMessage: '',
      configVersion: 5,
      configTerm: 7
    }
  ],
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1723611841, i: 1 }),
    signature: {
      hash: Binary.createFromBase64('dpPLJKlk7zPsnpFwr71oxG1iFQw=', 0),
      keyId: Long('7402575446908338182')
    }
  },
  operationTime: Timestamp({ t: 1723611841, i: 1 })
}



rs0 [direct: primary] admin> quit()

*/

-- Step 108 -->> On Node 2 (Start the MongoDB Serivice at Secondary Node i.e. Node 2)
mongodb@percona-mongodb-sec:~$ sudo systemctl start mongod.service

-- Step 109 -->> On Node 2 (Verify the MongoDB Serivice at Secondary Node i.e. Node 2)
mongodb@percona-mongodb-sec:~$ sudo systemctl status mongod.service
/*
● mongod.service - High-performance, schema-free document-oriented database
     Loaded: loaded (/lib/systemd/system/mongod.service; enabled; vendor preset: enabled)
     Active: active (running) since Wed 2024-08-14 04:48:05 UTC; 21min ago
    Process: 887 ExecStartPre=/usr/bin/percona-server-mongodb-helper.sh (code=exited, status=0/SUCCESS)
    Process: 951 ExecStart=/usr/bin/env bash -c ${NUMACTL} /usr/bin/mongod ${OPTIONS} > ${STDOUT} 2> ${STDERR} (code=exited, status=0/SUCCESS)
   Main PID: 1081 (mongod)
      Tasks: 75 (limit: 4513)
     Memory: 283.8M
        CPU: 15.950s
     CGroup: /system.slice/mongod.service
             └─1081 /usr/bin/mongod -f /etc/mongod.conf

Aug 14 04:48:03 percona-mongodb-sec.com systemd[1]: Starting High-performance, schema-free document-oriented database...
Aug 14 04:48:05 percona-mongodb-sec.com systemd[1]: Started High-performance, schema-free document-oriented database.

*/

-- Step 110 -->> On Node 2 (Verify the MongoDB Serivice at Secondary Node i.e. Node 2)
mongodb@percona-mongodb-sec:~$ mongosh --host 192.168.120.9 --port 27017 -u admin -p P#ssw0rd --authenticationDatabase admin
/*
Current Mongosh Log ID: 66bc3c2ab3bfb89173d56fd0
Connecting to:          mongodb://<credentials>@192.168.120.9:27017/?directConnection=true&authSource=admin&appName=mongosh+2.2.10
Using MongoDB:          7.0.12-7
Using Mongosh:          2.2.10
mongosh 2.2.15 is available for download: https://www.mongodb.com/try/download/shell

For mongosh info see: https://docs.mongodb.com/mongodb-shell/



rs0 [direct: secondary] test> show dbs
admin   188.00 KiB
config  316.00 KiB
local   524.00 KiB
rabin     8.00 KiB



rs0 [direct: secondary] test> use admin
switched to db admin

rs0 [direct: secondary] admin> db.getUsers()
{
  users: [
    {
      _id: 'admin.admin',
      userId: UUID('a74a70c7-60d2-413e-8e2d-d06ced87436b'),
      user: 'admin',
      db: 'admin',
      roles: [
        { role: 'clusterAdmin', db: 'admin' },
        { role: 'userAdminAnyDatabase', db: 'admin' },
        { role: 'root', db: 'admin' }
      ],
      mechanisms: [ 'SCRAM-SHA-1', 'SCRAM-SHA-256' ]
    }
  ],
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1723612281, i: 1 }),
    signature: {
      hash: Binary.createFromBase64('qZxZhRNtQho1MXMK5XRRVot3PbY=', 0),
      keyId: Long('7402575446908338182')
    }
  },
  operationTime: Timestamp({ t: 1723612281, i: 1 })
}


rs0 [direct: secondary] admin> rs.conf()
{
  _id: 'rs0',
  version: 5,
  term: 7,
  members: [
    {
      _id: 0,
      host: 'percona-mongodb-pri:27017',
      arbiterOnly: false,
      buildIndexes: true,
      hidden: false,
      priority: 10,
      tags: {},
      secondaryDelaySecs: Long('0'),
      votes: 1
    },
    {
      _id: 1,
      host: 'percona-mongodb-sec:27017',
      arbiterOnly: false,
      buildIndexes: true,
      hidden: false,
      priority: 1,
      tags: {},
      secondaryDelaySecs: Long('0'),
      votes: 1
    },
    {
      _id: 2,
      host: 'percona-mongodb-arb:27017',
      arbiterOnly: true,
      buildIndexes: true,
      hidden: false,
      priority: 0,
      tags: {},
      secondaryDelaySecs: Long('0'),
      votes: 1
    }
  ],
  protocolVersion: Long('1'),
  writeConcernMajorityJournalDefault: true,
  settings: {
    chainingAllowed: true,
    heartbeatIntervalMillis: 2000,
    heartbeatTimeoutSecs: 10,
    electionTimeoutMillis: 10000,
    catchUpTimeoutMillis: -1,
    catchUpTakeoverDelayMillis: 30000,
    getLastErrorModes: {},
    getLastErrorDefaults: { w: 1, wtimeout: 0 },
    replicaSetId: ObjectId('66bb3b26c2fce6f24a4b566e')
  }
}



rs0 [direct: secondary] admin> rs.status()
{
  set: 'rs0',
  date: ISODate('2024-06-24T16:27:30.006Z'),
  myState: 2,
  term: Long('5'),
  syncSourceHost: 'percona-mongodb-pri:27017',
  syncSourceId: 0,
  heartbeatIntervalMillis: Long('2000'),
  majorityVoteCount: 2,
  writeMajorityCount: 2,
  votingMembersCount: 3,
  writableVotingMembersCount: 2,
  optimes: {
    lastCommittedOpTime: { ts: Timestamp({ t: 1719246442, i: 1 }), t: Long('5') },
    lastCommittedWallTime: ISODate('2024-06-24T16:27:22.467Z'),
    readConcernMajorityOpTime: { ts: Timestamp({ t: 1719246442, i: 1 }), t: Long('5') },
    appliedOpTime: { ts: Timestamp({ t: 1719246442, i: 1 }), t: Long('5') },
    durableOpTime: { ts: Timestamp({ t: 1719246442, i: 1 }), t: Long('5') },
    lastAppliedWallTime: ISODate('2024-06-24T16:27:22.467Z'),
    lastDurableWallTime: ISODate('2024-06-24T16:27:22.467Z')
  },
  lastStableRecoveryTimestamp: Timestamp({ t: 1719246432, i: 1 }),
  members: [
    {
      _id: 0,
      name: 'percona-mongodb-pri:27017',
      health: 1,
      state: 1,
      stateStr: 'PRIMARY',
      uptime: 491,
      optime: { ts: Timestamp({ t: 1719246442, i: 1 }), t: Long('5') },
      optimeDurable: { ts: Timestamp({ t: 1719246442, i: 1 }), t: Long('5') },
      optimeDate: ISODate('2024-06-24T16:27:22.000Z'),
      optimeDurableDate: ISODate('2024-06-24T16:27:22.000Z'),
      lastAppliedWallTime: ISODate('2024-06-24T16:27:22.467Z'),
      lastDurableWallTime: ISODate('2024-06-24T16:27:22.467Z'),
      lastHeartbeat: ISODate('2024-06-24T16:27:28.065Z'),
      lastHeartbeatRecv: ISODate('2024-06-24T16:27:29.500Z'),
      pingMs: Long('0'),
      lastHeartbeatMessage: '',
      syncSourceHost: '',
      syncSourceId: -1,
      infoMessage: '',
      electionTime: Timestamp({ t: 1719245632, i: 1 }),
      electionDate: ISODate('2024-06-24T16:13:52.000Z'),
      configVersion: 5,
      configTerm: 5
    },
    {
      _id: 1,
      name: 'percona-mongodb-sec:27017',
      health: 1,
      state: 2,
      stateStr: 'SECONDARY',
      uptime: 492,
      optime: { ts: Timestamp({ t: 1719246442, i: 1 }), t: Long('5') },
      optimeDate: ISODate('2024-06-24T16:27:22.000Z'),
      lastAppliedWallTime: ISODate('2024-06-24T16:27:22.467Z'),
      lastDurableWallTime: ISODate('2024-06-24T16:27:22.467Z'),
      syncSourceHost: 'percona-mongodb-pri:27017',
      syncSourceId: 0,
      infoMessage: '',
      configVersion: 5,
      configTerm: 5,
      self: true,
      lastHeartbeatMessage: ''
    },
    {
      _id: 2,
      name: 'percona-mongodb-arb:27017',
      health: 1,
      state: 7,
      stateStr: 'ARBITER',
      uptime: 491,
      lastHeartbeat: ISODate('2024-06-24T16:27:28.064Z'),
      lastHeartbeatRecv: ISODate('2024-06-24T16:27:29.500Z'),
      pingMs: Long('0'),
      lastHeartbeatMessage: '',
      syncSourceHost: '',
      syncSourceId: -1,
      infoMessage: '',
      configVersion: 5,
      configTerm: 5
    }
  ],
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1719246442, i: 1 }),
    signature: {
      hash: Binary.createFromBase64('Y2gka7xRawrlWst78EbLhnTmYNk=', 0),
      keyId: Long('7384069845874114566')
    }
  },
  operationTime: Timestamp({ t: 1719246442, i: 1 })
}


rs0 [direct: secondary] admin> rs.isMaster()
{
  topologyVersion: {
    processId: ObjectId('66799c86503d9ebb491979a9'),
    counter: Long('6')
  },
  hosts: [ 'percona-mongodb-pri:27017', 'percona-mongodb-sec:27017' ],
  arbiters: [ 'percona-mongodb-arb:27017' ],
  setName: 'rs0',
  setVersion: 5,
  ismaster: false,
  secondary: true,
  primary: 'percona-mongodb-pri:27017',
  me: 'percona-mongodb-sec:27017',
  lastWrite: {
    opTime: { ts: Timestamp({ t: 1719246532, i: 1 }), t: Long('5') },
    lastWriteDate: ISODate('2024-06-24T16:28:52.000Z'),
    majorityOpTime: { ts: Timestamp({ t: 1719246532, i: 1 }), t: Long('5') },
    majorityWriteDate: ISODate('2024-06-24T16:28:52.000Z')
  },
  maxBsonObjectSize: 16777216,
  maxMessageSizeBytes: 48000000,
  maxWriteBatchSize: 100000,
  localTime: ISODate('2024-06-24T16:28:56.206Z'),
  logicalSessionTimeoutMinutes: 30,
  connectionId: 28,
  minWireVersion: 0,
  maxWireVersion: 21,
  readOnly: false,
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1719246532, i: 1 }),
    signature: {
      hash: Binary.createFromBase64('0uv7/ROfefdIoa6tK0ZOPAYZFWE=', 0),
      keyId: Long('7384069845874114566')
    }
  },
  operationTime: Timestamp({ t: 1719246532, i: 1 }),
  isWritablePrimary: false
}

rs0 [direct: secondary] admin> quit()
*/

-- Step 111 -->> On Node 3 (Verify the MongoDB Serivice at Arbiter Node i.e. Node 3)
mongodb@percona-mongodb-arb:~$ mongo --host 192.168.120.10 --port 27017 -u admin -p P#ssw0rd --authenticationDatabase admin
/*
Connecting to:          mongodb://<credentials>@192.168.120.10:27017/?directConnection=true&authSource=admin&appName=mongosh+2.2.10
Using MongoDB:          7.0.12-7
Using Mongosh:          2.2.10
mongosh 2.2.15 is available for download: https://www.mongodb.com/try/download/shell

For mongosh info see: https://docs.mongodb.com/mongodb-shell/




rs0 [direct: arbiter] test> show dbs
MongoServerError[Unauthorized]: Command listDatabases requires authentication
rs0 [direct: arbiter] test> use admin
switched to db admin
rs0 [direct: arbiter] admin> db
admin
rs0 [direct: arbiter] admin> rs.isMaster()
{
  topologyVersion: {
    processId: ObjectId('66bc370476f86448818365b8'),
    counter: Long('4')
  },
  hosts: [ 'percona-mongodb-pri:27017', 'percona-mongodb-sec:27017' ],
  arbiters: [ 'percona-mongodb-arb:27017' ],
  setName: 'rs0',
  setVersion: 5,
  ismaster: false,
  secondary: false,
  primary: 'percona-mongodb-pri:27017',
  arbiterOnly: true,
  me: 'percona-mongodb-arb:27017',
  lastWrite: {
    opTime: { ts: Timestamp({ t: 1723614281, i: 1 }), t: Long('7') },
    lastWriteDate: ISODate('2024-08-14T05:44:41.000Z'),
    majorityOpTime: { ts: Timestamp({ t: 1723614281, i: 1 }), t: Long('7') },
    majorityWriteDate: ISODate('2024-08-14T05:44:41.000Z')
  },
  maxBsonObjectSize: 16777216,
  maxMessageSizeBytes: 48000000,
  maxWriteBatchSize: 100000,
  localTime: ISODate('2024-08-14T05:44:45.144Z'),
  logicalSessionTimeoutMinutes: 30,
  connectionId: 29,
  minWireVersion: 0,
  maxWireVersion: 21,
  readOnly: false,
  ok: 1,
  isWritablePrimary: false
}



rs0 [direct: arbiter] admin> quit()
*/

-- Data verification
-- Step 112 -->> On Node 1 (Verify the DB SIze of MongoDB at Primary Node)
mongodb@percona-mongodb-pri:~$ sudo du -sh /data/datastore/mongodb/
/*
304M    /data/datastore/mongodb/
*/

-- Step 113 -->> On Node 1 (Verify the Files Count (Of DbPath) of MongoDB at Primary Node)
mongodb@percona-mongodb-pri:~$ sudo ls /data/datastore/mongodb/ -1 | wc -l
/*
72
*/

-- Step 114 -->> On Node 2 (Verify the DB SIze of MongoDB at Secondary Node)
mongodb@percona-mongodb-sec:~$ sudo du -sh /data/datastore/mongodb/
/*
304M    /data/datastore/mongodb/
*/

-- Step 115 -->> On Node 2 (Verify the Files Count (Of DbPath) of MongoDB at Secondary Node)
mongodb@percona-mongodb-sec:~$ sudo ls /data/datastore/mongodb/ -1 | wc -l
/*
72
*/

-- Step 116 -->> On Node 3 (Verify the DB SIze of MongoDB at Arbiter Node)
mongodb@percona-mongodb-arb:~$ sudo du -sh /data/datastore/mongodb/
/*
304M    /datastore/mongodb/
*/

-- Step 117 -->> On Node 3 (Verify the Files Count (Of DbPath) of MongoDB at Arbiter Node)
mongodb@percona-mongodb-arb:~$ ls /data/datastore/mongodb/ -1 | wc -l
/*
37
*/

-- Step 118 -->> On Node 1 (Verify the Files List (Of DbPath) of MongoDB at Primary Node)
mongodb@percona-mongodb-pri:~$ ll /data/datastore/mongodb/
/*
drwxrwxrwx. 4 mongod mongod   4096 Aug 14 05:50 ./
drwxr-xr-x. 4 root   root       32 Aug 13 05:13 ../
-rw-------. 1 mongod mongod  36864 Aug 14 04:47 collection-0--6409478916309770768.wt
-rw-------. 1 mongod mongod  36864 Aug 14 04:52 collection-0--6720920465008851336.wt
-rw-------. 1 mongod mongod  36864 Aug 14 05:50 collection-0--9029375862758851892.wt
-rw-------. 1 mongod mongod  61440 Aug 14 05:50 collection-10--9029375862758851892.wt
-rw-------. 1 mongod mongod  36864 Aug 14 04:50 collection-11--9029375862758851892.wt
-rw-------. 1 mongod mongod  20480 Aug 14 04:47 collection-13--9029375862758851892.wt
-rw-------. 1 mongod mongod   4096 Aug 14 04:47 collection-15--9029375862758851892.wt
-rw-------. 1 mongod mongod   4096 Aug 13 11:35 collection-18--9029375862758851892.wt
-rw-------. 1 mongod mongod   4096 Aug 13 11:35 collection-20--9029375862758851892.wt
-rw-------. 1 mongod mongod   4096 Aug 14 04:48 collection-22--9029375862758851892.wt
-rw-------. 1 mongod mongod  20480 Aug 14 04:48 collection-23--9029375862758851892.wt
-rw-------. 1 mongod mongod   4096 Aug 13 11:35 collection-24--9029375862758851892.wt
-rw-------. 1 mongod mongod  36864 Aug 14 04:48 collection-2--6409478916309770768.wt
-rw-------. 1 mongod mongod   4096 Aug 14 04:47 collection-26--9029375862758851892.wt
-rw-------. 1 mongod mongod   4096 Aug 14 04:47 collection-27--9029375862758851892.wt
-rw-------. 1 mongod mongod  20480 Aug 14 04:47 collection-2--9029375862758851892.wt
-rw-------. 1 mongod mongod   4096 Aug 13 11:35 collection-34--9029375862758851892.wt
-rw-------. 1 mongod mongod   4096 Aug 14 04:47 collection-35--9029375862758851892.wt
-rw-------. 1 mongod mongod   4096 Aug 13 11:35 collection-40--9029375862758851892.wt
-rw-------. 1 mongod mongod  20480 Aug 14 04:47 collection-43--9029375862758851892.wt
-rw-------. 1 mongod mongod   4096 Aug 13 11:35 collection-45--9029375862758851892.wt
-rw-------. 1 mongod mongod  32768 Aug 14 05:50 collection-4--6409478916309770768.wt
-rw-------. 1 mongod mongod  36864 Aug 14 04:50 collection-4--9029375862758851892.wt
-rw-------. 1 mongod mongod  20480 Aug 14 04:47 collection-5--6409478916309770768.wt
-rw-------. 1 mongod mongod  36864 Aug 14 04:48 collection-6--9029375862758851892.wt
-rw-------. 1 mongod mongod  20480 Aug 14 04:47 collection-8--9029375862758851892.wt
drwx------. 2 mongod mongod   4096 Aug 14 05:50 diagnostic.data/
-rw-------. 1 mongod mongod  20480 Aug 13 11:35 index-12--9029375862758851892.wt
-rw-------. 1 mongod mongod  20480 Aug 13 11:35 index-14--9029375862758851892.wt
-rw-------. 1 mongod mongod  36864 Aug 14 04:47 index-1--6409478916309770768.wt
-rw-------. 1 mongod mongod  36864 Aug 13 11:35 index-1--6720920465008851336.wt
-rw-------. 1 mongod mongod   4096 Aug 14 04:52 index-16--9029375862758851892.wt
-rw-------. 1 mongod mongod   4096 Aug 13 11:35 index-17--9029375862758851892.wt
-rw-------. 1 mongod mongod  20480 Aug 14 04:47 index-1--9029375862758851892.wt
-rw-------. 1 mongod mongod   4096 Aug 13 11:35 index-19--9029375862758851892.wt
-rw-------. 1 mongod mongod   4096 Aug 13 11:35 index-21--9029375862758851892.wt
-rw-------. 1 mongod mongod  20480 Aug 13 11:35 index-25--9029375862758851892.wt
-rw-------. 1 mongod mongod  36864 Aug 14 04:55 index-2--6720920465008851336.wt
-rw-------. 1 mongod mongod   4096 Aug 13 11:35 index-28--9029375862758851892.wt
-rw-------. 1 mongod mongod   4096 Aug 14 04:48 index-29--9029375862758851892.wt
-rw-------. 1 mongod mongod   4096 Aug 13 11:35 index-30--9029375862758851892.wt
-rw-------. 1 mongod mongod   4096 Aug 13 11:35 index-31--9029375862758851892.wt
-rw-------. 1 mongod mongod   4096 Aug 14 04:48 index-32--9029375862758851892.wt
-rw-------. 1 mongod mongod   4096 Aug 14 04:48 index-33--9029375862758851892.wt
-rw-------. 1 mongod mongod  36864 Aug 14 04:48 index-3--6409478916309770768.wt
-rw-------. 1 mongod mongod   4096 Aug 13 11:35 index-36--9029375862758851892.wt
-rw-------. 1 mongod mongod   4096 Aug 13 11:35 index-37--9029375862758851892.wt
-rw-------. 1 mongod mongod   4096 Aug 14 04:48 index-38--9029375862758851892.wt
-rw-------. 1 mongod mongod  20480 Aug 13 11:35 index-3--9029375862758851892.wt
-rw-------. 1 mongod mongod   4096 Aug 14 04:48 index-39--9029375862758851892.wt
-rw-------. 1 mongod mongod   4096 Aug 13 11:35 index-41--9029375862758851892.wt
-rw-------. 1 mongod mongod   4096 Aug 14 04:48 index-42--9029375862758851892.wt
-rw-------. 1 mongod mongod  20480 Aug 14 04:47 index-44--9029375862758851892.wt
-rw-------. 1 mongod mongod   4096 Aug 13 11:35 index-46--9029375862758851892.wt
-rw-------. 1 mongod mongod  20480 Aug 13 11:35 index-5--9029375862758851892.wt
-rw-------. 1 mongod mongod  32768 Aug 14 05:50 index-6--6409478916309770768.wt
-rw-------. 1 mongod mongod  24576 Aug 14 05:46 index-7--6409478916309770768.wt
-rw-------. 1 mongod mongod  20480 Aug 14 04:47 index-7--9029375862758851892.wt
-rw-------. 1 mongod mongod  20480 Aug 13 08:49 index-8--6409478916309770768.wt
-rw-------. 1 mongod mongod  20480 Aug 13 11:35 index-9--9029375862758851892.wt
drwx------. 2 mongod mongod    110 Aug 14 04:48 journal/
-r--------. 1 mongod mongod   1024 Aug 13 10:34 keyfile
-rw-------. 1 mongod mongod  36864 Aug 14 04:47 _mdb_catalog.wt
-rw-------. 1 mongod mongod      5 Aug 14 04:47 mongod.lock
-rw-------. 1 mongod mongod     33 Aug 13 07:13 psmdb_telemetry.data
-rw-------. 1 mongod mongod  36864 Aug 14 05:50 sizeStorer.wt
-rw-------. 1 mongod mongod    114 Aug 13 07:13 storage.bson
-rw-------. 1 mongod mongod     50 Aug 13 07:13 WiredTiger
-rw-------. 1 mongod mongod  24576 Aug 14 04:49 WiredTigerHS.wt
-rw-------. 1 mongod mongod     21 Aug 13 07:13 WiredTiger.lock
-rw-------. 1 mongod mongod   1480 Aug 14 05:50 WiredTiger.turtle
-rw-------. 1 mongod mongod 262144 Aug 14 05:50 WiredTiger.wt

*/

-- Step 119 -->> On Node 2 (Verify the Files List (Of DbPath) of MongoDB at Secondary Node)
mongodb@percona-mongodb-sec:~$ ll /data/datastore/mongodb/
/*

drwxrwxrwx. 4 mongod mongod   4096 Aug 14 05:51 ./
drwxr-xr-x. 4 root   root       32 Aug 13 05:13 ../
-rw-------. 1 mongod mongod  36864 Aug 14 05:51 collection-0--436885588044701458.wt
-rw-------. 1 mongod mongod  36864 Aug 14 04:50 collection-10--436885588044701458.wt
-rw-------. 1 mongod mongod  61440 Aug 14 05:51 collection-14--436885588044701458.wt
-rw-------. 1 mongod mongod  36864 Aug 14 05:10 collection-15--436885588044701458.wt
-rw-------. 1 mongod mongod  20480 Aug 14 04:48 collection-18--436885588044701458.wt
-rw-------. 1 mongod mongod  20480 Aug 14 04:48 collection-20--436885588044701458.wt
-rw-------. 1 mongod mongod   4096 Aug 14 04:48 collection-22--436885588044701458.wt
-rw-------. 1 mongod mongod  36864 Aug 14 04:48 collection-2--436885588044701458.wt
-rw-------. 1 mongod mongod   4096 Aug 14 04:49 collection-25--436885588044701458.wt
-rw-------. 1 mongod mongod  36864 Aug 14 04:49 collection-2--6409478916309770768.wt
-rw-------. 1 mongod mongod   4096 Aug 13 10:54 collection-26--436885588044701458.wt
-rw-------. 1 mongod mongod   4096 Aug 13 10:54 collection-28--436885588044701458.wt
-rw-------. 1 mongod mongod   4096 Aug 13 10:54 collection-31--436885588044701458.wt
-rw-------. 1 mongod mongod   4096 Aug 13 10:54 collection-34--436885588044701458.wt
-rw-------. 1 mongod mongod   4096 Aug 14 04:48 collection-36--436885588044701458.wt
-rw-------. 1 mongod mongod   4096 Aug 14 04:48 collection-39--436885588044701458.wt
-rw-------. 1 mongod mongod  32768 Aug 14 05:51 collection-42--436885588044701458.wt
-rw-------. 1 mongod mongod  36864 Aug 14 04:50 collection-4--436885588044701458.wt
-rw-------. 1 mongod mongod   4096 Aug 14 04:48 collection-45--436885588044701458.wt
-rw-------. 1 mongod mongod   4096 Aug 13 10:54 collection-48--436885588044701458.wt
-rw-------. 1 mongod mongod  20480 Aug 14 04:48 collection-51--436885588044701458.wt
-rw-------. 1 mongod mongod  20480 Aug 14 04:48 collection-53--436885588044701458.wt
-rw-------. 1 mongod mongod   4096 Aug 13 11:31 collection-55--436885588044701458.wt
-rw-------. 1 mongod mongod  20480 Aug 14 04:48 collection-5--6409478916309770768.wt
-rw-------. 1 mongod mongod  36864 Aug 14 04:49 collection-6--436885588044701458.wt
-rw-------. 1 mongod mongod  20480 Aug 14 04:48 collection-8--436885588044701458.wt
drwx------. 2 mongod mongod   4096 Aug 14 05:51 diagnostic.data/
-rw-------. 1 mongod mongod  20480 Aug 13 10:54 index-11--436885588044701458.wt
-rw-------. 1 mongod mongod  20480 Aug 14 04:48 index-1--436885588044701458.wt
-rw-------. 1 mongod mongod  36864 Aug 14 05:10 index-16--436885588044701458.wt
-rw-------. 1 mongod mongod  36864 Aug 13 11:31 index-17--436885588044701458.wt
-rw-------. 1 mongod mongod  20480 Aug 13 10:54 index-19--436885588044701458.wt
-rw-------. 1 mongod mongod  20480 Aug 14 04:48 index-21--436885588044701458.wt
-rw-------. 1 mongod mongod   8192 Aug 13 10:54 index-23--436885588044701458.wt
-rw-------. 1 mongod mongod   8192 Aug 13 11:30 index-24--436885588044701458.wt
-rw-------. 1 mongod mongod   8192 Aug 13 10:54 index-27--436885588044701458.wt
-rw-------. 1 mongod mongod   8192 Aug 13 11:35 index-29--436885588044701458.wt
-rw-------. 1 mongod mongod   8192 Aug 13 10:54 index-30--436885588044701458.wt
-rw-------. 1 mongod mongod   8192 Aug 13 11:35 index-32--436885588044701458.wt
-rw-------. 1 mongod mongod   8192 Aug 13 10:54 index-33--436885588044701458.wt
-rw-------. 1 mongod mongod  20480 Aug 13 10:51 index-3--436885588044701458.wt
-rw-------. 1 mongod mongod   8192 Aug 13 10:54 index-35--436885588044701458.wt
-rw-------. 1 mongod mongod  36864 Aug 14 04:49 index-3--6409478916309770768.wt
-rw-------. 1 mongod mongod   8192 Aug 13 11:35 index-37--436885588044701458.wt
-rw-------. 1 mongod mongod   8192 Aug 13 10:54 index-38--436885588044701458.wt
-rw-------. 1 mongod mongod   8192 Aug 13 11:35 index-40--436885588044701458.wt
-rw-------. 1 mongod mongod   8192 Aug 13 10:54 index-41--436885588044701458.wt
-rw-------. 1 mongod mongod  32768 Aug 14 05:51 index-43--436885588044701458.wt
-rw-------. 1 mongod mongod  32768 Aug 14 05:51 index-44--436885588044701458.wt
-rw-------. 1 mongod mongod   8192 Aug 13 11:35 index-46--436885588044701458.wt
-rw-------. 1 mongod mongod   8192 Aug 13 10:54 index-47--436885588044701458.wt
-rw-------. 1 mongod mongod   8192 Aug 13 11:35 index-49--436885588044701458.wt
-rw-------. 1 mongod mongod   8192 Aug 13 10:54 index-50--436885588044701458.wt
-rw-------. 1 mongod mongod  20480 Aug 13 10:54 index-52--436885588044701458.wt
-rw-------. 1 mongod mongod  20480 Aug 13 10:51 index-5--436885588044701458.wt
-rw-------. 1 mongod mongod  20480 Aug 14 04:48 index-54--436885588044701458.wt
-rw-------. 1 mongod mongod   4096 Aug 13 11:31 index-56--436885588044701458.wt
-rw-------. 1 mongod mongod  20480 Aug 14 04:48 index-7--436885588044701458.wt
-rw-------. 1 mongod mongod  20480 Aug 13 08:49 index-8--6409478916309770768.wt
-rw-------. 1 mongod mongod  20480 Aug 13 10:51 index-9--436885588044701458.wt
drwx------. 2 mongod mongod    110 Aug 14 04:49 journal/
-r--------. 1 mongod mongod   1024 Aug 13 10:41 keyfile
-rw-------. 1 mongod mongod  36864 Aug 14 04:48 _mdb_catalog.wt
-rw-------. 1 mongod mongod      5 Aug 14 04:48 mongod.lock
-rw-------. 1 mongod mongod     33 Aug 13 07:13 psmdb_telemetry.data
-rw-------. 1 mongod mongod  36864 Aug 14 05:51 sizeStorer.wt
-rw-------. 1 mongod mongod    114 Aug 13 07:13 storage.bson
-rw-------. 1 mongod mongod     50 Aug 13 07:13 WiredTiger
-rw-------. 1 mongod mongod  32768 Aug 14 05:32 WiredTigerHS.wt
-rw-------. 1 mongod mongod     21 Aug 13 07:13 WiredTiger.lock
-rw-------. 1 mongod mongod   1481 Aug 14 05:51 WiredTiger.turtle
-rw-------. 1 mongod mongod 319488 Aug 14 05:51 WiredTiger.wt

*/

-- Step 120 -->> On Node 3 (Verify the Files List (Of DbPath) of MongoDB at Arbiter Node)
mongodb@percona-mongodb-arb:~$ ll /data/datastore/mongodb/
/*
drwxrwxrwx. 4 mongod mongod   4096 Aug 14 05:52 ./
drwxr-xr-x. 4 root   root       32 Aug 13 05:13 ../
-rw-------. 1 mongod mongod  36864 Aug 14 04:48 collection-0--6409478916309770768.wt
-rw-------. 1 mongod mongod  20480 Aug 14 04:58 collection-0--6720920465008851336.wt
-rw-------. 1 mongod mongod   4096 Aug 14 04:48 collection-0-9006256860426358096.wt
-rw-------. 1 mongod mongod  36864 Aug 14 04:50 collection-10-9006256860426358096.wt
-rw-------. 1 mongod mongod  36864 Aug 14 04:49 collection-2--6409478916309770768.wt
-rw-------. 1 mongod mongod  20480 Aug 14 04:48 collection-2-9006256860426358096.wt
-rw-------. 1 mongod mongod  36864 Aug 13 10:50 collection-4--6409478916309770768.wt
-rw-------. 1 mongod mongod  36864 Aug 14 04:50 collection-4-9006256860426358096.wt
-rw-------. 1 mongod mongod  20480 Aug 14 04:48 collection-5--6409478916309770768.wt
-rw-------. 1 mongod mongod  36864 Aug 14 04:49 collection-6-9006256860426358096.wt
-rw-------. 1 mongod mongod  20480 Aug 14 04:48 collection-8-9006256860426358096.wt
drwx------. 2 mongod mongod   4096 Aug 14 05:52 diagnostic.data/
-rw-------. 1 mongod mongod  20480 Aug 13 11:07 index-11-9006256860426358096.wt
-rw-------. 1 mongod mongod  36864 Aug 14 04:48 index-1--6409478916309770768.wt
-rw-------. 1 mongod mongod  20480 Aug 13 08:57 index-1--6720920465008851336.wt
-rw-------. 1 mongod mongod   4096 Aug 14 04:48 index-1-9006256860426358096.wt
-rw-------. 1 mongod mongod  20480 Aug 14 04:58 index-2--6720920465008851336.wt
-rw-------. 1 mongod mongod  36864 Aug 14 04:49 index-3--6409478916309770768.wt
-rw-------. 1 mongod mongod  20480 Aug 13 10:51 index-3-9006256860426358096.wt
-rw-------. 1 mongod mongod  20480 Aug 13 10:51 index-5-9006256860426358096.wt
-rw-------. 1 mongod mongod  36864 Aug 13 10:50 index-6--6409478916309770768.wt
-rw-------. 1 mongod mongod  36864 Aug 13 10:50 index-7--6409478916309770768.wt
-rw-------. 1 mongod mongod  20480 Aug 14 04:48 index-7-9006256860426358096.wt
-rw-------. 1 mongod mongod  20480 Aug 13 08:49 index-8--6409478916309770768.wt
-rw-------. 1 mongod mongod  20480 Aug 13 10:51 index-9-9006256860426358096.wt
drwx------. 2 mongod mongod    110 Aug 14 04:49 journal/
-r--------. 1 mongod mongod   1024 Aug 13 10:42 keyfile
-rw-------. 1 mongod mongod  36864 Aug 14 04:48 _mdb_catalog.wt
-rw-------. 1 mongod mongod      5 Aug 14 04:48 mongod.lock
-rw-------. 1 mongod mongod     33 Aug 13 07:13 psmdb_telemetry.data
-rw-------. 1 mongod mongod  36864 Aug 14 04:50 sizeStorer.wt
-rw-------. 1 mongod mongod    114 Aug 13 07:13 storage.bson
-rw-------. 1 mongod mongod     50 Aug 13 07:13 WiredTiger
-rw-------. 1 mongod mongod   4096 Aug 14 04:48 WiredTigerHS.wt
-rw-------. 1 mongod mongod     21 Aug 13 07:13 WiredTiger.lock
-rw-------. 1 mongod mongod   1474 Aug 14 05:52 WiredTiger.turtle
-rw-------. 1 mongod mongod 106496 Aug 14 05:52 WiredTiger.wt

*/

--restore 
mongorestore --host 192.168.120.7 --port 27017 --username admin --password P#ssw0rd --authenticationDatabase sample_analytics /data/backupstore/mongodbdump/sample_analytics
mongodb@percona-mongodb-pri:/backupstore/mongodbFullBackup/dump$ mongorestore --host 192.168.120.7  --port 27017 -u rabin -p rabin123 --authenticationDatabase rabin --db rabin /data/backupstore/mongodbdump/psycQuizDB

/*
2024-08-15T06:08:00.675+0000    The --db and --collection flags are deprecated for this use-case; please use --nsInclude instead, i.e. with --nsInclude=${DATABASE}.${COLLECTION}
2024-08-15T06:08:00.675+0000    building a list of collections to restore from /data/backupstore/mongodbdump/psycQuizDB dir
2024-08-15T06:08:00.676+0000    reading metadata for rabin.psyc_qz_dhcu from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_dhcu.metadata.json
2024-08-15T06:08:00.676+0000    reading metadata for rabin.psyc_qz_sxrd from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_sxrd.metadata.json
2024-08-15T06:08:00.677+0000    reading metadata for rabin.psyc_qz_hdwd from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_hdwd.metadata.json
2024-08-15T06:08:00.677+0000    reading metadata for rabin.psyc_qz_okje from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_okje.metadata.json
2024-08-15T06:08:00.677+0000    reading metadata for rabin.psyc_qz_qscu from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_qscu.metadata.json
2024-08-15T06:08:00.678+0000    reading metadata for rabin.psyc_qz_falq from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_falq.metadata.json
2024-08-15T06:08:00.678+0000    reading metadata for rabin.psyc_qz_licf from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_licf.metadata.json
2024-08-15T06:08:00.678+0000    reading metadata for rabin.psyc_qz_mlho from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_mlho.metadata.json
2024-08-15T06:08:00.679+0000    reading metadata for rabin.psyc_qz_xkgl from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_xkgl.metadata.json
2024-08-15T06:08:00.679+0000    reading metadata for rabin.psyc_qz_kkry from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_kkry.metadata.json
2024-08-15T06:08:00.679+0000    reading metadata for rabin.psyc_qz_kplj from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_kplj.metadata.json
2024-08-15T06:08:00.680+0000    reading metadata for rabin.psyc_qz_wmrm from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_wmrm.metadata.json
2024-08-15T06:08:00.680+0000    reading metadata for rabin.psyc_qz_kjyj from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_kjyj.metadata.json
2024-08-15T06:08:00.680+0000    reading metadata for rabin.psyc_qz_aqrm from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_aqrm.metadata.json
2024-08-15T06:08:00.680+0000    reading metadata for rabin.psyc_qz_jraz from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_jraz.metadata.json
2024-08-15T06:08:00.680+0000    reading metadata for rabin.psyc_qz_zxeo from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_zxeo.metadata.json
2024-08-15T06:08:00.681+0000    reading metadata for rabin.psyc_qz_dpwv from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_dpwv.metadata.json
2024-08-15T06:08:00.681+0000    reading metadata for rabin.psyc_qz_goxy from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_goxy.metadata.json
2024-08-15T06:08:00.681+0000    reading metadata for rabin.psyc_qz_ocqy from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_ocqy.metadata.json
2024-08-15T06:08:00.681+0000    reading metadata for rabin.psyc_qz_oqhf from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_oqhf.metadata.json
2024-08-15T06:08:00.681+0000    reading metadata for rabin.psyc_qz_rhtn from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_rhtn.metadata.json
2024-08-15T06:08:00.682+0000    reading metadata for rabin.psyc_qz_wlwo from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_wlwo.metadata.json
2024-08-15T06:08:00.682+0000    reading metadata for rabin.psyc_qz_sakp from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_sakp.metadata.json
2024-08-15T06:08:00.682+0000    reading metadata for rabin.psyc_qz_ttmm from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_ttmm.metadata.json
2024-08-15T06:08:00.682+0000    reading metadata for rabin.psyc_qz_ubdi from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_ubdi.metadata.json
2024-08-15T06:08:00.682+0000    reading metadata for rabin.psyc_qz_cekt from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_cekt.metadata.json
2024-08-15T06:08:00.683+0000    reading metadata for rabin.psyc_qz_fxko from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_fxko.metadata.json
2024-08-15T06:08:00.683+0000    reading metadata for rabin.psyc_qz_wgma from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_wgma.metadata.json
2024-08-15T06:08:00.683+0000    reading metadata for rabin.psyc_qz_wvdm from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_wvdm.metadata.json
2024-08-15T06:08:00.683+0000    reading metadata for rabin.psyc_qz_dcqo from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_dcqo.metadata.json
2024-08-15T06:08:00.683+0000    reading metadata for rabin.random_questions from /data/backupstore/mongodbdump/psycQuizDB/random_questions.metadata.json
2024-08-15T06:08:00.683+0000    reading metadata for rabin.psyc_qz_wqcs from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_wqcs.metadata.json
2024-08-15T06:08:00.684+0000    reading metadata for rabin.psyc_qz_wqsd from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_wqsd.metadata.json
2024-08-15T06:08:00.684+0000    reading metadata for rabin.psyc_qz_xgbm from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_xgbm.metadata.json
2024-08-15T06:08:00.684+0000    reading metadata for rabin.psyc_qz_clax from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_clax.metadata.json
2024-08-15T06:08:00.684+0000    reading metadata for rabin.psyc_qz_pyzy from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_pyzy.metadata.json
2024-08-15T06:08:00.684+0000    reading metadata for rabin.psyc_qz_rinst from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_rinst.metadata.json
2024-08-15T06:08:00.684+0000    reading metadata for rabin.psyc_qz_tngk from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_tngk.metadata.json
2024-08-15T06:08:00.685+0000    reading metadata for rabin.psyc_qz_ulav from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_ulav.metadata.json
2024-08-15T06:08:00.685+0000    reading metadata for rabin.psyc_qz_zerw from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_zerw.metadata.json
2024-08-15T06:08:00.685+0000    reading metadata for rabin.psyc_qz_zvwp from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_zvwp.metadata.json
2024-08-15T06:08:00.685+0000    reading metadata for rabin.psyc_qz_cugl from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_cugl.metadata.json
2024-08-15T06:08:00.685+0000    reading metadata for rabin.psyc_qz_kztd from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_kztd.metadata.json
2024-08-15T06:08:00.685+0000    reading metadata for rabin.psyc_qz_lhrk from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_lhrk.metadata.json
2024-08-15T06:08:00.686+0000    reading metadata for rabin.psyc_qz_mapk from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_mapk.metadata.json
2024-08-15T06:08:00.686+0000    reading metadata for rabin.psyc_qz_nssx from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_nssx.metadata.json
2024-08-15T06:08:00.686+0000    reading metadata for rabin.psyc_qz_iypo from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_iypo.metadata.json
2024-08-15T06:08:00.686+0000    reading metadata for rabin.psyc_qz_qvar from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_qvar.metadata.json
2024-08-15T06:08:00.687+0000    reading metadata for rabin.psyc_qz_rdht from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_rdht.metadata.json
2024-08-15T06:08:00.687+0000    reading metadata for rabin.psyc_qz_ybuz from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_ybuz.metadata.json
2024-08-15T06:08:00.687+0000    reading metadata for rabin.psyc_qz_ygwq from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_ygwq.metadata.json
2024-08-15T06:08:00.687+0000    reading metadata for rabin.psyc_qz_amif from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_amif.metadata.json
2024-08-15T06:08:00.688+0000    reading metadata for rabin.psyc_qz_kmhw from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_kmhw.metadata.json
2024-08-15T06:08:00.688+0000    reading metadata for rabin.psyc_qz_psrc from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_psrc.metadata.json
2024-08-15T06:08:00.688+0000    reading metadata for rabin.psyc_qz_yepb from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_yepb.metadata.json
2024-08-15T06:08:00.688+0000    reading metadata for rabin.psyc_qz_zbti from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_zbti.metadata.json
2024-08-15T06:08:00.702+0000    restoring rabin.psyc_qz_mlho from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_mlho.bson
2024-08-15T06:08:00.708+0000    restoring rabin.random_questions from /data/backupstore/mongodbdump/psycQuizDB/random_questions.bson
2024-08-15T06:08:00.726+0000    restoring rabin.psyc_qz_kmhw from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_kmhw.bson
2024-08-15T06:08:00.732+0000    restoring rabin.psyc_qz_rdht from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_rdht.bson
2024-08-15T06:08:01.418+0000    finished restoring rabin.psyc_qz_rdht (5032 documents, 0 failures)
2024-08-15T06:08:01.429+0000    restoring rabin.psyc_qz_oqhf from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_oqhf.bson
2024-08-15T06:08:02.004+0000    finished restoring rabin.psyc_qz_oqhf (5372 documents, 0 failures)
2024-08-15T06:08:02.022+0000    restoring rabin.psyc_qz_jraz from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_jraz.bson
2024-08-15T06:08:02.565+0000    finished restoring rabin.psyc_qz_jraz (5182 documents, 0 failures)
2024-08-15T06:08:02.579+0000    restoring rabin.psyc_qz_wgma from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_wgma.bson
2024-08-15T06:08:03.215+0000    finished restoring rabin.psyc_qz_wgma (5032 documents, 0 failures)
2024-08-15T06:08:03.259+0000    restoring rabin.psyc_qz_tngk from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_tngk.bson
2024-08-15T06:08:03.622+0000    finished restoring rabin.psyc_qz_kmhw (31084 documents, 0 failures)
2024-08-15T06:08:03.636+0000    restoring rabin.psyc_qz_ulav from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_ulav.bson
2024-08-15T06:08:03.680+0000    [###.....................]      rabin.psyc_qz_mlho   28.4MB/173MB   (16.5%)
2024-08-15T06:08:03.680+0000    [###.....................]  rabin.random_questions    137MB/850MB   (16.2%)
2024-08-15T06:08:03.680+0000    [################........]      rabin.psyc_qz_tngk  1.25MB/1.80MB   (69.4%)
2024-08-15T06:08:03.680+0000    [########################]      rabin.psyc_qz_ulav  1.50MB/1.50MB  (100.0%)
2024-08-15T06:08:03.680+0000
2024-08-15T06:08:03.790+0000    [########################]  rabin.psyc_qz_ulav  1.50MB/1.50MB  (100.0%)
2024-08-15T06:08:03.790+0000    finished restoring rabin.psyc_qz_ulav (329 documents, 0 failures)
2024-08-15T06:08:03.799+0000    restoring rabin.psyc_qz_dpwv from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_dpwv.bson
2024-08-15T06:08:03.848+0000    finished restoring rabin.psyc_qz_dpwv (32 documents, 0 failures)
2024-08-15T06:08:03.849+0000    [########################]  rabin.psyc_qz_tngk  1.80MB/1.80MB  (100.0%)
2024-08-15T06:08:03.851+0000    finished restoring rabin.psyc_qz_tngk (5768 documents, 0 failures)
2024-08-15T06:08:03.861+0000    restoring rabin.psyc_qz_licf from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_licf.bson
2024-08-15T06:08:03.886+0000    restoring rabin.psyc_qz_nssx from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_nssx.bson
2024-08-15T06:08:03.904+0000    finished restoring rabin.psyc_qz_licf (65 documents, 0 failures)
2024-08-15T06:08:03.916+0000    finished restoring rabin.psyc_qz_nssx (199 documents, 0 failures)
2024-08-15T06:08:03.938+0000    restoring rabin.psyc_qz_aqrm from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_aqrm.bson
2024-08-15T06:08:03.950+0000    restoring rabin.psyc_qz_qscu from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_qscu.bson
2024-08-15T06:08:04.009+0000    finished restoring rabin.psyc_qz_qscu (58 documents, 0 failures)
2024-08-15T06:08:04.026+0000    restoring rabin.psyc_qz_ubdi from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_ubdi.bson
2024-08-15T06:08:04.032+0000    finished restoring rabin.psyc_qz_aqrm (125 documents, 0 failures)
2024-08-15T06:08:04.046+0000    restoring rabin.psyc_qz_rhtn from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_rhtn.bson
2024-08-15T06:08:04.085+0000    finished restoring rabin.psyc_qz_ubdi (52 documents, 0 failures)
2024-08-15T06:08:04.107+0000    restoring rabin.psyc_qz_xkgl from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_xkgl.bson
2024-08-15T06:08:04.110+0000    finished restoring rabin.psyc_qz_rhtn (5 documents, 0 failures)
2024-08-15T06:08:04.139+0000    restoring rabin.psyc_qz_psrc from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_psrc.bson
2024-08-15T06:08:04.233+0000    finished restoring rabin.psyc_qz_xkgl (210 documents, 0 failures)
2024-08-15T06:08:04.241+0000    restoring rabin.psyc_qz_iypo from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_iypo.bson
2024-08-15T06:08:04.262+0000    finished restoring rabin.psyc_qz_psrc (546 documents, 0 failures)
2024-08-15T06:08:04.269+0000    restoring rabin.psyc_qz_falq from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_falq.bson
2024-08-15T06:08:04.315+0000    finished restoring rabin.psyc_qz_iypo (199 documents, 0 failures)
2024-08-15T06:08:04.320+0000    finished restoring rabin.psyc_qz_falq (228 documents, 0 failures)
2024-08-15T06:08:04.330+0000    restoring rabin.psyc_qz_kplj from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_kplj.bson
2024-08-15T06:08:04.335+0000    restoring rabin.psyc_qz_kztd from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_kztd.bson
2024-08-15T06:08:04.348+0000    finished restoring rabin.psyc_qz_kplj (22 documents, 0 failures)
2024-08-15T06:08:04.368+0000    finished restoring rabin.psyc_qz_kztd (1 document, 0 failures)
2024-08-15T06:08:04.370+0000    restoring rabin.psyc_qz_zbti from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_zbti.bson
2024-08-15T06:08:04.379+0000    restoring rabin.psyc_qz_kjyj from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_kjyj.bson
2024-08-15T06:08:04.578+0000    finished restoring rabin.psyc_qz_zbti (23 documents, 0 failures)
2024-08-15T06:08:04.578+0000    finished restoring rabin.psyc_qz_kjyj (29 documents, 0 failures)
2024-08-15T06:08:04.610+0000    restoring rabin.psyc_qz_ybuz from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_ybuz.bson
2024-08-15T06:08:04.629+0000    restoring rabin.psyc_qz_rinst from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_rinst.bson
2024-08-15T06:08:04.716+0000    finished restoring rabin.psyc_qz_rinst (2 documents, 0 failures)
2024-08-15T06:08:04.717+0000    finished restoring rabin.psyc_qz_ybuz (288 documents, 0 failures)
2024-08-15T06:08:04.735+0000    restoring rabin.psyc_qz_ttmm from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_ttmm.bson
2024-08-15T06:08:04.737+0000    restoring rabin.psyc_qz_sakp from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_sakp.bson
2024-08-15T06:08:04.927+0000    finished restoring rabin.psyc_qz_sakp (20 documents, 0 failures)
2024-08-15T06:08:04.928+0000    finished restoring rabin.psyc_qz_ttmm (29 documents, 0 failures)
2024-08-15T06:08:04.990+0000    restoring rabin.psyc_qz_okje from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_okje.bson
2024-08-15T06:08:05.011+0000    restoring rabin.psyc_qz_lhrk from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_lhrk.bson
2024-08-15T06:08:06.215+0000    finished restoring rabin.psyc_qz_lhrk (8 documents, 0 failures)
2024-08-15T06:08:06.222+0000    finished restoring rabin.psyc_qz_okje (3 documents, 0 failures)
2024-08-15T06:08:06.823+0000    [#####...................]      rabin.psyc_qz_mlho  39.8MB/173MB  (23.0%)
2024-08-15T06:08:06.823+0000    [######..................]  rabin.random_questions   229MB/850MB  (26.9%)
2024-08-15T06:08:06.823+0000
2024-08-15T06:08:06.858+0000    restoring rabin.psyc_qz_wqcs from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_wqcs.bson
2024-08-15T06:08:07.240+0000    restoring rabin.psyc_qz_ocqy from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_ocqy.bson
2024-08-15T06:08:08.243+0000    finished restoring rabin.psyc_qz_wqcs (5 documents, 0 failures)
2024-08-15T06:08:08.243+0000    finished restoring rabin.psyc_qz_ocqy (4 documents, 0 failures)
2024-08-15T06:08:09.013+0000    restoring rabin.psyc_qz_yepb from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_yepb.bson
2024-08-15T06:08:09.137+0000    restoring rabin.psyc_qz_xgbm from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_xgbm.bson
2024-08-15T06:08:09.675+0000    [#####...................]      rabin.psyc_qz_mlho   41.0MB/173MB   (23.7%)
2024-08-15T06:08:09.675+0000    [######..................]  rabin.random_questions    229MB/850MB   (26.9%)
2024-08-15T06:08:09.675+0000    [########################]      rabin.psyc_qz_yepb  4.07KB/4.07KB  (100.0%)
2024-08-15T06:08:09.675+0000    [########################]      rabin.psyc_qz_xgbm  4.17KB/4.17KB  (100.0%)
2024-08-15T06:08:09.675+0000
2024-08-15T06:08:10.298+0000    [########################]  rabin.psyc_qz_yepb  4.07KB/4.07KB  (100.0%)
2024-08-15T06:08:10.298+0000    finished restoring rabin.psyc_qz_yepb (2 documents, 0 failures)
2024-08-15T06:08:10.298+0000    [########################]  rabin.psyc_qz_xgbm  4.17KB/4.17KB  (100.0%)
2024-08-15T06:08:10.298+0000    finished restoring rabin.psyc_qz_xgbm (12 documents, 0 failures)
2024-08-15T06:08:10.423+0000    restoring rabin.psyc_qz_wvdm from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_wvdm.bson
2024-08-15T06:08:10.424+0000    restoring rabin.psyc_qz_goxy from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_goxy.bson
2024-08-15T06:08:11.153+0000    finished restoring rabin.psyc_qz_goxy (1 document, 0 failures)
2024-08-15T06:08:11.154+0000    finished restoring rabin.psyc_qz_wvdm (2 documents, 0 failures)
2024-08-15T06:08:11.585+0000    restoring rabin.psyc_qz_wqsd from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_wqsd.bson
2024-08-15T06:08:11.702+0000    restoring rabin.psyc_qz_pyzy from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_pyzy.bson
2024-08-15T06:08:12.003+0000    finished restoring rabin.psyc_qz_wqsd (4 documents, 0 failures)
2024-08-15T06:08:12.005+0000    finished restoring rabin.psyc_qz_pyzy (2 documents, 0 failures)
2024-08-15T06:08:12.751+0000    [######..................]      rabin.psyc_qz_mlho  44.4MB/173MB  (25.7%)
2024-08-15T06:08:12.751+0000    [#######.................]  rabin.random_questions   275MB/850MB  (32.3%)
2024-08-15T06:08:12.751+0000
2024-08-15T06:08:12.898+0000    restoring rabin.psyc_qz_zvwp from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_zvwp.bson
2024-08-15T06:08:12.934+0000    restoring rabin.psyc_qz_mapk from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_mapk.bson
2024-08-15T06:08:13.490+0000    finished restoring rabin.psyc_qz_mapk (1 document, 0 failures)
2024-08-15T06:08:13.501+0000    finished restoring rabin.psyc_qz_zvwp (1 document, 0 failures)
2024-08-15T06:08:14.300+0000    restoring rabin.psyc_qz_hdwd from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_hdwd.bson
2024-08-15T06:08:14.308+0000    restoring rabin.psyc_qz_wlwo from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_wlwo.bson
2024-08-15T06:08:14.324+0000    finished restoring rabin.psyc_qz_hdwd (0 documents, 0 failures)
2024-08-15T06:08:14.324+0000    finished restoring rabin.psyc_qz_wlwo (0 documents, 0 failures)
2024-08-15T06:08:14.437+0000    restoring rabin.psyc_qz_wmrm from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_wmrm.bson
2024-08-15T06:08:14.440+0000    restoring rabin.psyc_qz_dcqo from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_dcqo.bson
2024-08-15T06:08:14.454+0000    finished restoring rabin.psyc_qz_wmrm (0 documents, 0 failures)
2024-08-15T06:08:14.460+0000    finished restoring rabin.psyc_qz_dcqo (0 documents, 0 failures)
2024-08-15T06:08:14.578+0000    restoring rabin.psyc_qz_dhcu from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_dhcu.bson
2024-08-15T06:08:14.583+0000    restoring rabin.psyc_qz_fxko from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_fxko.bson
2024-08-15T06:08:14.605+0000    finished restoring rabin.psyc_qz_fxko (0 documents, 0 failures)
2024-08-15T06:08:14.609+0000    finished restoring rabin.psyc_qz_dhcu (0 documents, 0 failures)
2024-08-15T06:08:14.847+0000    restoring rabin.psyc_qz_sxrd from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_sxrd.bson
2024-08-15T06:08:14.950+0000    restoring rabin.psyc_qz_cugl from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_cugl.bson
2024-08-15T06:08:14.963+0000    finished restoring rabin.psyc_qz_cugl (0 documents, 0 failures)
2024-08-15T06:08:14.968+0000    finished restoring rabin.psyc_qz_sxrd (0 documents, 0 failures)
2024-08-15T06:08:15.194+0000    restoring rabin.psyc_qz_qvar from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_qvar.bson
2024-08-15T06:08:15.203+0000    restoring rabin.psyc_qz_amif from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_amif.bson
2024-08-15T06:08:15.205+0000    finished restoring rabin.psyc_qz_qvar (0 documents, 0 failures)
2024-08-15T06:08:15.215+0000    finished restoring rabin.psyc_qz_amif (0 documents, 0 failures)
2024-08-15T06:08:15.698+0000    [######..................]      rabin.psyc_qz_mlho  45.5MB/173MB  (26.3%)
2024-08-15T06:08:15.698+0000    [#########...............]  rabin.random_questions   321MB/850MB  (37.7%)
2024-08-15T06:08:15.698+0000
2024-08-15T06:08:15.712+0000    restoring rabin.psyc_qz_ygwq from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_ygwq.bson
2024-08-15T06:08:15.718+0000    restoring rabin.psyc_qz_clax from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_clax.bson
2024-08-15T06:08:15.724+0000    finished restoring rabin.psyc_qz_ygwq (0 documents, 0 failures)
2024-08-15T06:08:15.730+0000    finished restoring rabin.psyc_qz_clax (0 documents, 0 failures)
2024-08-15T06:08:15.844+0000    restoring rabin.psyc_qz_zerw from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_zerw.bson
2024-08-15T06:08:15.856+0000    finished restoring rabin.psyc_qz_zerw (0 documents, 0 failures)
2024-08-15T06:08:15.969+0000    restoring rabin.psyc_qz_kkry from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_kkry.bson
2024-08-15T06:08:15.970+0000    restoring rabin.psyc_qz_zxeo from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_zxeo.bson
2024-08-15T06:08:15.982+0000    finished restoring rabin.psyc_qz_kkry (0 documents, 0 failures)
2024-08-15T06:08:15.982+0000    finished restoring rabin.psyc_qz_zxeo (0 documents, 0 failures)
2024-08-15T06:08:16.099+0000    restoring rabin.psyc_qz_cekt from /data/backupstore/mongodbdump/psycQuizDB/psyc_qz_cekt.bson
2024-08-15T06:08:16.110+0000    finished restoring rabin.psyc_qz_cekt (0 documents, 0 failures)
2024-08-15T06:08:18.679+0000    [######..................]      rabin.psyc_qz_mlho  47.7MB/173MB  (27.6%)
2024-08-15T06:08:18.679+0000    [#########...............]  rabin.random_questions   321MB/850MB  (37.7%)
2024-08-15T06:08:18.679+0000
2024-08-15T06:08:21.674+0000    [######..................]      rabin.psyc_qz_mlho  48.9MB/173MB  (28.3%)
2024-08-15T06:08:21.674+0000    [#########...............]  rabin.random_questions   321MB/850MB  (37.7%)
2024-08-15T06:08:21.674+0000
2024-08-15T06:08:24.766+0000    [######..................]      rabin.psyc_qz_mlho  50.4MB/173MB  (29.1%)
2024-08-15T06:08:24.766+0000    [##########..............]  rabin.random_questions   366MB/850MB  (43.1%)
2024-08-15T06:08:24.766+0000
2024-08-15T06:08:27.674+0000    [#######.................]      rabin.psyc_qz_mlho  53.5MB/173MB  (30.9%)
2024-08-15T06:08:27.674+0000    [###########.............]  rabin.random_questions   391MB/850MB  (45.9%)
2024-08-15T06:08:27.674+0000
2024-08-15T06:08:30.674+0000    [########................]      rabin.psyc_qz_mlho  58.0MB/173MB  (33.6%)
2024-08-15T06:08:30.675+0000    [############............]  rabin.random_questions   445MB/850MB  (52.3%)
2024-08-15T06:08:30.675+0000
2024-08-15T06:08:33.674+0000    [##########..............]      rabin.psyc_qz_mlho  72.8MB/173MB  (42.1%)
2024-08-15T06:08:33.674+0000    [###############.........]  rabin.random_questions   550MB/850MB  (64.7%)
2024-08-15T06:08:33.674+0000
2024-08-15T06:08:36.675+0000    [############............]      rabin.psyc_qz_mlho  91.0MB/173MB  (52.7%)
2024-08-15T06:08:36.675+0000    [##################......]  rabin.random_questions   642MB/850MB  (75.5%)
2024-08-15T06:08:36.675+0000
2024-08-15T06:08:39.677+0000    [##############..........]      rabin.psyc_qz_mlho  102MB/173MB  (59.2%)
2024-08-15T06:08:39.677+0000    [####################....]  rabin.random_questions  733MB/850MB  (86.2%)
2024-08-15T06:08:39.677+0000
2024-08-15T06:08:42.692+0000    [################........]      rabin.psyc_qz_mlho  117MB/173MB  (67.8%)
2024-08-15T06:08:42.692+0000    [#######################.]  rabin.random_questions  825MB/850MB  (97.0%)
2024-08-15T06:08:42.692+0000
2024-08-15T06:08:43.871+0000    [########################]  rabin.random_questions  850MB/850MB  (100.0%)
2024-08-15T06:08:43.871+0000    finished restoring rabin.random_questions (5030 documents, 0 failures)
2024-08-15T06:08:45.674+0000    [#######################.]  rabin.psyc_qz_mlho  166MB/173MB  (95.9%)
2024-08-15T06:08:46.011+0000    [########################]  rabin.psyc_qz_mlho  173MB/173MB  (100.0%)
2024-08-15T06:08:46.011+0000    finished restoring rabin.psyc_qz_mlho (152264 documents, 0 failures)
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_dcqo
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_rinst
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_cekt
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_wlwo
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_pyzy
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_cugl
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_amif
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_yepb
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_qscu
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_wmrm
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_oqhf
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_zvwp
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_nssx
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_licf
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_ocqy
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_wqcs
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_xgbm
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_ygwq
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_kkry
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_kplj
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_aqrm
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_wqsd
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_qvar
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_ybuz
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_wgma
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_zerw
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_kztd
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_goxy
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_clax
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_lhrk
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_hdwd
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_kjyj
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_jraz
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_mapk
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_falq
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_iypo
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_kmhw
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_dhcu
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_rdht
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_ubdi
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_zxeo
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_psrc
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_dpwv
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_wvdm
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.random_questions
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_rhtn
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_okje
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_mlho
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_xkgl
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_zbti
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_ttmm
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_fxko
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_tngk
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_sakp
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_sxrd
2024-08-15T06:08:46.013+0000    no indexes to restore for collection rabin.psyc_qz_ulav
2024-08-15T06:08:46.016+0000    217271 document(s) restored successfully. 0 document(s) failed to restore.


*/
mongodb@percona-mongodb-pri:~$ mongorestore --host 192.168.120.7 --port 27017 -u rabin -p rabin123 --authenticationDatabase rabin --nsInclude=rabin.* /data/backupstore/mongodbdump/psycQuizDB
--notes:rabin.* includes all collections within the rabin database. 
--If you want to restore a specific collection, you can specify it like this:

mongodb@percona-mongodb-pri:~$ mongorestore --host 192.168.120.7 --port 27017 -u rabin -p rabin123 --authenticationDatabase rabin --nsInclude=rabin.yourCollectionName /data/backupstore/mongodbdump/psycQuizDB
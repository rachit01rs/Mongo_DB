
cat /dev/null > mongodb.log

--------------------------------------------------------------------------
----------------------------rabin/rabin123---------------------------------
--------------------------------------------------------------------------
-- 1 All Nodes on VM (Server Storage)
root@mongodb:~# df -Th
/*
Filesystem                                                                                   Type   Size  Used Avail Use% Mounted on
tmpfs                                                                                        tmpfs  195M  1.3M  194M   1% /run
/dev/mapper/Ubuntu--lvm-root                                                                 xfs     25G  4.1G   21G  17% /
/dev/disk/by-id/dm-uuid-LVM-aQ6HcOyCreCv48lHoDG1hR8RLOrZAlOf0nRIeARLZS9taPsERnFRRrSbV4ap7K0A xfs    8.0G  2.3G  5.8G  29% /usr
tmpfs                                                                                        tmpfs  972M     0  972M   0% /dev/shm
tmpfs                                                                                        tmpfs  5.0M     0  5.0M   0% /run/lock
/dev/sda2                                                                                    xfs   1014M  165M  850M  17% /boot
/dev/mapper/Ubuntu--lvm-var                                                                  xfs    8.0G  245M  7.8G   3% /var
/dev/mapper/Ubuntu--lvm-tmp                                                                  xfs    6.0G   76M  6.0G   2% /tmp
/dev/mapper/Ubuntu--lvm-usr_var                                                              xfs    8.0G  604M  7.5G   8% /var/lib
tmpfs                                                                                        tmpfs  195M  4.0K  195M   1% /run/user/1000
*/

-- 1 All Nodes on VM (Server Kernal version)
root@mongodb:~# uname -msr
/*
Linux 5.15.0-112-generic x86_64
*/

-- 1 All Nodes on VM (Server Release)
root@mongodb:~# cat /etc/lsb-release
/*
ISTRIB_ID=Ubuntu
DISTRIB_RELEASE=22.04
DISTRIB_CODENAME=jammy
DISTRIB_DESCRIPTION="Ubuntu 22.04.4 LTS"
*/

-- 1 All Nodes on VM (Server Release)
root@mongodb:~# cat /etc/os-release
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
root@mongodb:~# vi /etc/hosts
/*
127.0.0.1 localhost
127.0.1.1 mongodb

# Public
192.168.120.70 mongodbtest-pri.com.np mongodbtest-pri
192.168.120.71 mongodbtest-sec.com.np mongodbtest-sec
192.168.120.72 mongotest-arb.com.np mongotest-arb
*/

-- Step 2 -->> On Node 1 (Ethernet Configuration)
root@mongodb:~# vi /etc/netplan/00-installer-config.yaml
/*
# This is the network config written by 'subiquity'
network:
  ethernets:
    ens33:
      addresses:
      - 192.168.120.70/24
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
root@mongodb:~# vi /etc/netplan/00-installer-config.yaml
/*
# This is the network config written by 'subiquity'
#
network:
  ethernets:
    ens33:
      addresses:
      - 192.168.120.71/24
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
root@mongodb:~# vi /etc/netplan/00-installer-config.yaml
/*
# This is the network config written by 'subiquity'
network:
  ethernets:
    ens33:
      addresses:
      - 192.168.120.72/24
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
root@mongodb:~# systemctl restart network-online.target

-- Step 4 -->> On All Nodes (Set Hostname)
root@mongodb:~# hostnamectl | grep hostname
/*
 Static hostname: mongodbtest-pri.com.np/mongodbtest-sec.com.np/mongotest-arb.com.np
*/

-- Step 4.1 -->> On All Nodes
root@mongodb:~# hostnamectl --static
/*
mongodbtest-pri.com.np
*/

-- Step 4.2 -->> On All Nodes
root@mongodbtest-pri:~# hostnamectl
/*
 Static hostname: mongodbtest-pri.com.np
       Icon name: computer-vm
         Chassis: vm
      Machine ID: 86f5997010c44eceb3dc225d08d420c2
         Boot ID: 9768e1dcd7604c4ab529cf600490a8b3
  Virtualization: vmware
Operating System: Ubuntu 22.04.4 LTS
          Kernel: Linux 5.15.0-112-generic
    Architecture: x86-64
 Hardware Vendor: VMware, Inc.
  Hardware Model: VMware Virtual Platform


*/

-- Step 4.3 -->> On Node 1
root@mongodbtest-pri:~# hostnamectl set-hostname mongodbtest-pri.com.np

-- Step 4.3.1 -->> On Node 2
root@mongodbtest-sec:~# hostnamectl set-hostname mongodbtest-sec.com.np

-- Step 4.3.2 -->> On Node 3
root@mongotest-arb:~# hostnamectl set-hostname mongotest-arb.com.np

-- Step 4.4 -->> On Node 1
root@mongodbtest-pri:~# hostnamectl
/*
 Static hostname: mongodbtest-pri.unidev39.org.np
       Icon name: computer-vm
         Chassis: vm
      Machine ID: 331c2034bd21478bbf65b345244f9120
         Boot ID: 91428965b8094519a3830b6ddafc02b7
  Virtualization: vmware
Operating System: Ubuntu 22.04.4 LTS
          Kernel: Linux 6.5.0-25-generic
    Architecture: x86-64
 Hardware Vendor: VMware, Inc.
  Hardware Model: VMware Virtual Platform
*/

-- Step 4.4.1 -->> On Node 2
root@mongodbtest-sec:~#  hostnamectl
/*
  Static hostname: mongodbtest-sec.com.np
       Icon name: computer-vm
         Chassis: vm
      Machine ID: 81d99c6017672bdd78516770666b2538
         Boot ID: 87be6fbb70c64e79a8795db3ba7aacd1
  Virtualization: vmware
Operating System: Ubuntu 22.04.4 LTS
          Kernel: Linux 5.15.0-112-generic
    Architecture: x86-64
 Hardware Vendor: VMware, Inc.
  Hardware Model: VMware Virtual Platform

*/

-- Step 4.4.2 -->> On Node 3
root@mongotest-arb:~# hostnamectl
/*
 
 Static hostname: mongotest-arb.com.np
       Icon name: computer-vm
         Chassis: vm
      Machine ID: 0614e737abd040f22f16f494666b2593
         Boot ID: 74bbf5ce9bfd4cd1bf6ca03e194a6114
  Virtualization: vmware
Operating System: Ubuntu 22.04.4 LTS
          Kernel: Linux 5.15.0-112-generic
    Architecture: x86-64
 Hardware Vendor: VMware, Inc.
  Hardware Model: VMware Virtual Platform
*/

-- Step 5 -->> On All Nodes (IPtables Configuration)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# apt install net-tools
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# iptables -F
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# iptables -X
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# iptables -t nat -F
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# iptables -t nat -X
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# iptables -t mangle -F
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# iptables -t mangle -X
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# iptables -P INPUT ACCEPT
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# iptables -P FORWARD ACCEPT
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# iptables -P OUTPUT ACCEPT
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# iptables -L -nv

root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# apt install net-tools
-- Step 5.1 -->> On Node 1
root@mongodbtest-pri:~# ifconfig
/*
ens33: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.120.70  netmask 255.255.255.0  broadcast 192.168.120.255
        inet6 fe80::20c:29ff:fe83:3c6e  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:83:3c:6e  txqueuelen 1000  (Ethernet)
        RX packets 660  bytes 259639 (259.6 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 506  bytes 61236 (61.2 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 174  bytes 14007 (14.0 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 174  bytes 14007 (14.0 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
*/

-- Step 5.1.1 -->> On Node 2
root@mongodbtest-sec:~# ifconfig
/*
ens33: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.120.71  netmask 255.255.255.0  broadcast 192.168.120.255
        inet6 fe80::20c:29ff:fe76:3c90  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:76:3c:90  txqueuelen 1000  (Ethernet)
        RX packets 598  bytes 254372 (254.3 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 443  bytes 54332 (54.3 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 178  bytes 14409 (14.4 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 178  bytes 14409 (14.4 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

*/

-- Step 5.1.2 -->> On Node 3
root@mongotest-arb:~# ifconfig
/*
ens33: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.120.72  netmask 255.255.255.0  broadcast 192.168.120.255
        inet6 fe80::20c:29ff:fe40:ab92  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:40:ab:92  txqueuelen 1000  (Ethernet)
        RX packets 550  bytes 250066 (250.0 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 438  bytes 52890 (52.8 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 174  bytes 13999 (13.9 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 174  bytes 13999 (13.9 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0


*/

-- Step 6 -->> On All Nodes (Firew Configuration)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# apt install firewalld

-- Step 6.1 -->> On All Nodes
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# systemctl enable firewalld

-- Step 6.2 -->> On All Nodes
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# systemctl start firewalld


-- Step 6.3 -->> On All Nodes
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# systemctl status firewalld
/*
● firewalld.service - firewalld - dynamic firewall daemon
     Loaded: loaded (/lib/systemd/system/firewalld.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2024-06-17 15:54:54 UTC; 51s ago
       Docs: man:firewalld(1)
   Main PID: 1991 (firewalld)
      Tasks: 2 (limit: 2175)
     Memory: 23.9M
        CPU: 307ms
     CGroup: /system.slice/firewalld.service
             └─1991 /usr/bin/python3 /usr/sbin/firewalld --nofork --nopid

Jun 17 15:54:54 mongodbtest-pri.com.np systemd[1]: Starting firewalld - dynamic firewall daemon...
Jun 17 15:54:54 mongodbtest-pri.com.np systemd[1]: Started firewalld - dynamic firewall daemon.
*/

-- Step 6.4 -->> On All Nodes
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# sudo firewall-cmd --zone=public --add-port=27017/tcp --permanent
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# sudo firewall-cmd --zone=public --add-port=27017/udp --permanent
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# sudo firewall-cmd --zone=public --add-port=22/tcp --permanent
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# sudo firewall-cmd --zone=public --add-port=22/udp --permanent

-- Step 6.5 -->> On All Nodes
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~#  firewall-cmd --list-all
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
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# sudo apt update && sudo apt upgrade -y

-- Step 8 -->> On All Nodes (Selinux Configuration)
-- Making sure the SELINUX flag is set as follows.
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# sudo apt install policycoreutils selinux-basics selinux-utils -y
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# sudo selinux-activate
/*
Activating SE Linux
Sourcing file `/etc/default/grub'
Sourcing file `/etc/default/grub.d/init-select.cfg'
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-5.15.0-112-generic
Found initrd image: /boot/initrd.img-5.15.0-112-generic
Found linux image: /boot/vmlinuz-5.15.0-23-generic
Found initrd image: /boot/initrd.img-5.15.0-23-generic
Warning: os-prober will not be executed to detect other bootable partitions.
Systems on them will not be added to the GRUB boot configuration.
Check GRUB_DISABLE_OS_PROBER documentation entry.
done
SE Linux is activated.  You may need to reboot now.
*/

-- Step 8.1 -->> On All Nodes
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# getenforce
/*
Disabled
*/

-- Step 8.2 -->> On All Nodes
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# sestatus
/*
SELinux status:                 disabled
*/

-- Step 8.3 -->> On All Nodes
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# init 6

-- Step 8.4 -->> On Node 1
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# vi /etc/selinux/config
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
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# getenforce
/*
Permissive
*/

-- Step 8.6 -->> On Node 1
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# sestatus
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
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# firewall-cmd --list-all
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
root@mongodbtest-pri:~# hostnamectl
/*
 Static hostname: mongodbtest-pri.com.np
       Icon name: computer-vm
         Chassis: vm
      Machine ID: 86f5997010c44eceb3dc225d08d420c2
         Boot ID: 86b5a2f930ae4b50aa1856fb89a155b2
  Virtualization: vmware
Operating System: Ubuntu 22.04.4 LTS
          Kernel: Linux 5.15.0-112-generic
    Architecture: x86-64
 Hardware Vendor: VMware, Inc.
  Hardware Model: VMware Virtual Platform
*/

-- Step 10.1 -->> On Node 2
root@mongodbtest-sec:~# hostnamectl
/*
 Static hostname: mongodbtest-sec.com.np
       Icon name: computer-vm
         Chassis: vm
      Machine ID: 81d99c6017672bdd78516770666b2538
         Boot ID: b508363d8cbe47b0919fad6edfbc2ce9
  Virtualization: vmware
Operating System: Ubuntu 22.04.4 LTS
          Kernel: Linux 5.15.0-112-generic
    Architecture: x86-64
 Hardware Vendor: VMware, Inc.
  Hardware Model: VMware Virtual Platform

*/

-- Step 10.2 -->> On Node 3
root@mongotest-arb:~# hostnamectl
/*
 Static hostname: mongotest-arb.com.np
       Icon name: computer-vm
         Chassis: vm
      Machine ID: 0614e737abd040f22f16f494666b2593
         Boot ID: 2e5e5147559b43f097115f8802665835
  Virtualization: vmware
Operating System: Ubuntu 22.04.4 LTS
          Kernel: Linux 5.15.0-112-generic
    Architecture: x86-64
 Hardware Vendor: VMware, Inc.
  Hardware Model: VMware Virtual Platform

*/

-- Step 11 -->> On All Nodes (Assign role to MongoDB User)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# sudo adduser mongodb
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# sudo usermod -aG sudo mongodb

-- Step 11.1 -->> On All Nodes 
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# sudo usermod -aG root mongodb

-- Step 11.2 -->> On All Nodes 
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# rsync --archive --chown=mongodb:mongodb ~/.ssh /home/mongodb

-- Step 11.3 -->> On Node 1
root@mongodbtest-pri:~# ssh mongodb@192.168.120.70
/*
The authenticity of host '192.168.120.70 (192.168.120.70)' can't be established.
ED25519 key fingerprint is SHA256:XNR7nWEbZFHy7mMW8jp+ZcW2wVMoJNlJxQMpvn32GL4.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '192.168.120.70' (ED25519) to the list of known hosts.
mongodb@192.168.120.70's password:
Welcome to Ubuntu 22.04.4 LTS (GNU/Linux 5.15.0-112-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Thu Jun 20 07:11:38 AM UTC 2024

  System load:  0.03               Processes:              292
  Usage of /:   16.1% of 24.99GB   Users logged in:        3
  Memory usage: 21%                IPv4 address for ens33: 192.168.120.70
  Swap usage:   0%


Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status

Failed to connect to https://changelogs.ubuntu.com/meta-release-lts. Check your Internet connection or proxy settings



The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

*/

-- Step 11.3.1 -->> On Node 2
root@mongodbtest-sec:~# ssh mongodb@192.168.120.71
/*
The authenticity of host '192.168.120.71 (192.168.120.71)' can't be established.
ED25519 key fingerprint is SHA256:XNR7nWEbZFHy7mMW8jp+ZcW2wVMoJNlJxQMpvn32GL4.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '192.168.120.71' (ED25519) to the list of known hosts.
mongodb@192.168.120.71's password:
Welcome to Ubuntu 22.04.4 LTS (GNU/Linux 5.15.0-112-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Thu Jun 20 07:13:21 AM UTC 2024

  System load:  0.0                Processes:              293
  Usage of /:   16.1% of 24.99GB   Users logged in:        3
  Memory usage: 25%                IPv4 address for ens33: 192.168.120.71
  Swap usage:   0%

 * Strictly confined Kubernetes makes edge and IoT secure. Learn how MicroK8s
   just raised the bar for easy, resilient and secure K8s cluster deployment.

   https://ubuntu.com/engage/secure-kubernetes-at-the-edge

Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status



The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.


*/

-- Step 11.3.2 -->> On Node 3
root@mongotest-arb:~# ssh mongodb@192.168.120.72
/*
The authenticity of host '192.168.120.72 (192.168.120.72)' can't be established.
ED25519 key fingerprint is SHA256:XNR7nWEbZFHy7mMW8jp+ZcW2wVMoJNlJxQMpvn32GL4.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '192.168.120.72' (ED25519) to the list of known hosts.
mongodb@192.168.120.72's password:
Welcome to Ubuntu 22.04.4 LTS (GNU/Linux 5.15.0-112-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Thu Jun 20 07:14:45 AM UTC 2024

  System load:  0.01               Processes:              278
  Usage of /:   16.1% of 24.99GB   Users logged in:        2
  Memory usage: 24%                IPv4 address for ens33: 192.168.120.72
  Swap usage:   0%

 * Strictly confined Kubernetes makes edge and IoT secure. Learn how MicroK8s
   just raised the bar for easy, resilient and secure K8s cluster deployment.

   https://ubuntu.com/engage/secure-kubernetes-at-the-edge

Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status



The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc//copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.
*/

-- Step 11.4 -->> On All Nodes
mongodb@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~$ exit

-- Step 12 -->> On All Nodes (LVM Partition Configuration - Before Status)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# df -Th
/*
Filesystem                                                                                   Type   Size  Used Avail Use% Mounted on
tmpfs                                                                                        tmpfs  193M  1.2M  192M   1% /run
/dev/mapper/Ubuntu--lvm-root                                                                 xfs     25G  4.1G   21G  17% /
/dev/disk/by-id/dm-uuid-LVM-aQ6HcOyCreCv48lHoDG1hR8RLOrZAlOf0nRIeARLZS9taPsERnFRRrSbV4ap7K0A xfs    8.0G  3.2G  4.9G  40% /usr
tmpfs                                                                                        tmpfs  964M     0  964M   0% /dev/shm
tmpfs                                                                                        tmpfs  5.0M     0  5.0M   0% /run/lock
/dev/sda2                                                                                    xfs   1014M  292M  722M  29% /boot
/dev/mapper/Ubuntu--lvm-var                                                                  xfs    8.0G  332M  7.7G   5% /var
/dev/mapper/Ubuntu--lvm-tmp                                                                  xfs    6.0G   76M  6.0G   2% /tmp
/dev/mapper/Ubuntu--lvm-usr_var                                                              xfs    8.0G  794M  7.3G  10% /var/lib

*/

-- Step 13 -->> On Node 1 (LVM Partition Configuration - Before Status)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# lsblk
/*
NAME                    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
loop0                     7:0    0 61.9M  1 loop /snap/core20/1376
loop3                     7:3    0 78.8M  1 loop /snap/lxd/22754
sda                       8:0    0   65G  0 disk
├─sda1                    8:1    0    1M  0 part
├─sda2                    8:2    0    1G  0 part /boot
└─sda3                    8:3    0   64G  0 part
  ├─Ubuntu--lvm-root    253:0    0   25G  0 lvm  /
  ├─Ubuntu--lvm-var     253:1    0    8G  0 lvm  /var
  ├─Ubuntu--lvm-usr     253:2    0    8G  0 lvm  /usr
  ├─Ubuntu--lvm-usr_var 253:3    0    8G  0 lvm  /var/lib
  ├─Ubuntu--lvm-tmp     253:4    0    6G  0 lvm  /tmp
  └─Ubuntu--lvm-swap    253:5    0    9G  0 lvm  [SWAP]
sdb                       8:16   0    5G  0 disk
sdc                       8:32   0    5G  0 disk
sr0                      11:0    1  1.4G  0 rom

*/

-- Step 14 -->> On Node 1 (LVM Partition Configuration - Before Status)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# fdisk -ll | grep sd
/*
/d/dev/sda1     2048      4095      2048   1M BIOS boot
/dev/sda2     4096   2101247   2097152   1G Linux filesystem
/dev/sda3  2101248 136312831 134211584  64G Linux filesystem
Disk /dev/sdb: 5 GiB, 5368709120 bytes, 10485760 sectors
Disk /dev/sdc: 5 GiB, 5368709120 bytes, 10485760 sectors
*/

-- Step 15 -->> On All Nodes (LVM Partition Configuration - t with 8e to change LVM Partition)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# fdisk /dev/sdb
/*

Welcome to fdisk (util-linux 2.37.2).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0xc667cde5.

Command (m for help): p
Disk /dev/sdb: 5 GiB, 5368709120 bytes, 10485760 sectors
Disk model: VMware Virtual S
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xc667cde5

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1):
First sector (2048-10485759, default 2048):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-10485759, default 10485759):

Created a new partition 1 of type 'Linux' and of size 5 GiB.

Command (m for help): t
Selected partition 1
Hex code or alias (type L to list all): L

00 Empty            24 NEC DOS          81 Minix / old Lin  bf Solaris
01 FAT12            27 Hidden NTFS Win  82 Linux swap / So  c1 DRDOS/sec (FAT-
02 XENIX root       39 Plan 9           83 Linux            c4 DRDOS/sec (FAT-
03 XENIX usr        3c PartitionMagic   84 OS/2 hidden or   c6 DRDOS/sec (FAT-
04 FAT16 <32M       40 Venix 80286      85 Linux extended   c7 Syrinx
05 Extended         41 PPC PReP Boot    86 NTFS volume set  da Non-FS data
06 FAT16            42 SFS              87 NTFS volume set  db CP/M / CTOS / .
07 HPFS/NTFS/exFAT  4d QNX4.x           88 Linux plaintext  de Dell Utility
08 AIX              4e QNX4.x 2nd part  8e Linux LVM        df BootIt
09 AIX bootable     4f QNX4.x 3rd part  93 Amoeba           e1 DOS access
0a OS/2 Boot Manag  50 OnTrack DM       94 Amoeba BBT       e3 DOS R/O
0b W95 FAT32        51 OnTrack DM6 Aux  9f BSD/OS           e4 SpeedStor
0c W95 FAT32 (LBA)  52 CP/M             a0 IBM Thinkpad hi  ea Linux extended
0e W95 FAT16 (LBA)  53 OnTrack DM6 Aux  a5 FreeBSD          eb BeOS fs
0f W95 Ext'd (LBA)  54 OnTrackDM6       a6 OpenBSD          ee GPT
10 OPUS             55 EZ-Drive         a7 NeXTSTEP         ef EFI (FAT-12/16/
11 Hidden FAT12     56 Golden Bow       a8 Darwin UFS       f0 Linux/PA-RISC b
12 Compaq diagnost  5c Priam Edisk      a9 NetBSD           f1 SpeedStor
14 Hidden FAT16 <3  61 SpeedStor        ab Darwin boot      f4 SpeedStor
16 Hidden FAT16     63 GNU HURD or Sys  af HFS / HFS+       f2 DOS secondary
17 Hidden HPFS/NTF  64 Novell Netware   b7 BSDI fs          fb VMware VMFS
18 AST SmartSleep   65 Novell Netware   b8 BSDI swap        fc VMware VMKCORE
1b Hidden W95 FAT3  70 DiskSecure Mult  bb Boot Wizard hid  fd Linux raid auto
1c Hidden W95 FAT3  75 PC/IX            bc Acronis FAT32 L  fe LANstep
1e Hidden W95 FAT1  80 Old Minix        be Solaris boot     ff BBT

Aliases:
   linux          - 83
   swap           - 82
   extended       - 05
   uefi           - EF
   raid           - FD
   lvm            - 8E
   linuxex        - 85
Hex code or alias (type L to list all): 8E
Changed type of partition 'Linux' to 'Linux LVM'.

Command (m for help): p
Disk /dev/sdb: 5 GiB, 5368709120 bytes, 10485760 sectors
Disk model: VMware Virtual S
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xc667cde5

Device     Boot Start      End  Sectors Size Id Type
/dev/sdb1        2048 10485759 10483712   5G 8e Linux LVM

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
*/

-- Step 16 -->> On All Nodes (LVM Partition Configuration - t with 8e to change LVM Partition)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# fdisk /dev/sdc
/*
Welcome to fdisk (util-linux 2.37.2).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0x3ec2927b.

Command (m for help): p
Disk /dev/sdc: 5 GiB, 5368709120 bytes, 10485760 sectors
Disk model: VMware Virtual S
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x3ec2927b

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1):
First sector (2048-10485759, default 2048):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-10485759, default 10485759):

Created a new partition 1 of type 'Linux' and of size 5 GiB.

Command (m for help): t
Selected partition 1
Hex code or alias (type L to list all): L

00 Empty            24 NEC DOS          81 Minix / old Lin  bf Solaris
01 FAT12            27 Hidden NTFS Win  82 Linux swap / So  c1 DRDOS/sec (FAT-
02 XENIX root       39 Plan 9           83 Linux            c4 DRDOS/sec (FAT-
03 XENIX usr        3c PartitionMagic   84 OS/2 hidden or   c6 DRDOS/sec (FAT-
04 FAT16 <32M       40 Venix 80286      85 Linux extended   c7 Syrinx
05 Extended         41 PPC PReP Boot    86 NTFS volume set  da Non-FS data
06 FAT16            42 SFS              87 NTFS volume set  db CP/M / CTOS / .
07 HPFS/NTFS/exFAT  4d QNX4.x           88 Linux plaintext  de Dell Utility
08 AIX              4e QNX4.x 2nd part  8e Linux LVM        df BootIt
09 AIX bootable     4f QNX4.x 3rd part  93 Amoeba           e1 DOS access
0a OS/2 Boot Manag  50 OnTrack DM       94 Amoeba BBT       e3 DOS R/O
0b W95 FAT32        51 OnTrack DM6 Aux  9f BSD/OS           e4 SpeedStor
0c W95 FAT32 (LBA)  52 CP/M             a0 IBM Thinkpad hi  ea Linux extended
0e W95 FAT16 (LBA)  53 OnTrack DM6 Aux  a5 FreeBSD          eb BeOS fs
0f W95 Ext'd (LBA)  54 OnTrackDM6       a6 OpenBSD          ee GPT
10 OPUS             55 EZ-Drive         a7 NeXTSTEP         ef EFI (FAT-12/16/
11 Hidden FAT12     56 Golden Bow       a8 Darwin UFS       f0 Linux/PA-RISC b
12 Compaq diagnost  5c Priam Edisk      a9 NetBSD           f1 SpeedStor
14 Hidden FAT16 <3  61 SpeedStor        ab Darwin boot      f4 SpeedStor
16 Hidden FAT16     63 GNU HURD or Sys  af HFS / HFS+       f2 DOS secondary
17 Hidden HPFS/NTF  64 Novell Netware   b7 BSDI fs          fb VMware VMFS
18 AST SmartSleep   65 Novell Netware   b8 BSDI swap        fc VMware VMKCORE
1b Hidden W95 FAT3  70 DiskSecure Mult  bb Boot Wizard hid  fd Linux raid auto
1c Hidden W95 FAT3  75 PC/IX            bc Acronis FAT32 L  fe LANstep
1e Hidden W95 FAT1  80 Old Minix        be Solaris boot     ff BBT

Aliases:
   linux          - 83
   swap           - 82
   extended       - 05
   uefi           - EF
   raid           - FD
   lvm            - 8E
   linuxex        - 85
Hex code or alias (type L to list all): 8E
Changed type of partition 'Linux' to 'Linux LVM'.

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.

*/

-- Step 17 -->> On All Nodes (LVM Partition Configuration - After Status)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# fdisk -ll | grep sd
/*
Disk /dev/sda: 65 GiB, 69793218560 bytes, 136314880 sectors
/dev/sda1     2048      4095      2048   1M BIOS boot
/dev/sda2     4096   2101247   2097152   1G Linux filesystem
/dev/sda3  2101248 136312831 134211584  64G Linux filesystem
Disk /dev/sdb: 5 GiB, 5368709120 bytes, 10485760 sectors
/dev/sdb1        2048 10485759 10483712   5G 8e Linux LVM
Disk /dev/sdc: 5 GiB, 5368709120 bytes, 10485760 sectors
/dev/sdc1        2048 10485759 10483712   5G 8e Linux LVM
*/

-- Step 18 -->> On All Nodes (LVM Partition Configuration - Make it Avilable)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# partprobe /dev/sdb

-- Step 19 -->> On All Nodes (LVM Partition Configuration - Make it Avilable)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# partprobe /dev/sdc

-- Step 20 -->> On All Nodes (LVM Partition Configuration - After Status)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# lsblk
/*
NAME                    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
loop0                     7:0    0 61.9M  1 loop /snap/core20/1376
loop3                     7:3    0 78.8M  1 loop /snap/lxd/22754
sda                       8:0    0   65G  0 disk
├─sda1                    8:1    0    1M  0 part
├─sda2                    8:2    0    1G  0 part /boot
└─sda3                    8:3    0   64G  0 part
  ├─Ubuntu--lvm-root    253:0    0   25G  0 lvm  /
  ├─Ubuntu--lvm-var     253:1    0    8G  0 lvm  /var
  ├─Ubuntu--lvm-usr     253:2    0    8G  0 lvm  /usr
  ├─Ubuntu--lvm-usr_var 253:3    0    8G  0 lvm  /var/lib
  ├─Ubuntu--lvm-tmp     253:4    0    6G  0 lvm  /tmp
  └─Ubuntu--lvm-swap    253:5    0    9G  0 lvm  [SWAP]
sdb                       8:16   0    5G  0 disk
└─sdb1                    8:17   0    5G  0 part
sdc                       8:32   0    5G  0 disk
└─sdc1                    8:33   0    5G  0 part
sr0                      11:0    1  1.4G  0 rom

*/

-- Step 21 -->> On All Nodes (LVM Partition Configuration - Befor Status of pvs)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# pvs
/*
 PV         VG         Fmt  Attr PSize   PFree
  /dev/sda3  Ubuntu-lvm lvm2 a--  <64.00g    0
*/

-- Step 22 -->> On All Nodes (LVM Partition Configuration - Befor Status of vgs)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# vgs
/*
   VG         #PV #LV #SN Attr   VSize   VFree
  Ubuntu-lvm   1   6   0 wz--n- <64.00g    0
*/

-- Step 23 -->> On All Nodes (LVM Partition Configuration - Befor Status of lvs)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# lvs
/*
  L LV      VG         Attr       LSize  Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  root    Ubuntu-lvm -wi-ao---- 25.00g
  swap    Ubuntu-lvm -wi-ao---- <9.00g
  tmp     Ubuntu-lvm -wi-ao----  6.00g
  usr     Ubuntu-lvm -wi-ao----  8.00g
  usr_var Ubuntu-lvm -wi-ao----  8.00g
  var     Ubuntu-lvm -wi-ao----  8.00g

*/

-- Step 24 -->> On All Nodes (LVM Partition Configuration - After Status)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# fdisk -ll | grep sd
/*
DDisk /dev/sda: 65 GiB, 69793218560 bytes, 136314880 sectors
/dev/sda1     2048      4095      2048   1M BIOS boot
/dev/sda2     4096   2101247   2097152   1G Linux filesystem
/dev/sda3  2101248 136312831 134211584  64G Linux filesystem
Disk /dev/sdb: 5 GiB, 5368709120 bytes, 10485760 sectors
/dev/sdb1        2048 10485759 10483712   5G 8e Linux LVM
Disk /dev/sdc: 5 GiB, 5368709120 bytes, 10485760 sectors
/dev/sdc1        2048 10485759 10483712   5G 8e Linux LVM

*/

-- Step 25 -->> On All Nodes (LVM Partition Configuration - Create pvs)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# pvcreate /dev/sdb1
/*
  Physical volume "/dev/sdb1" successfully created.
*/

-- Step 26 -->> On All Nodes (LVM Partition Configuration - Create pvs)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# pvcreate /dev/sdc1
/*
  Physical volume "/dev/sdc1" successfully created.
*/

-- Step 27 -->> On All Nodes (LVM Partition Configuration - Verify pvs)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# pvs
/*
  PV         VG         Fmt  Attr PSize   PFree
  /dev/sda3  Ubuntu-lvm lvm2 a--  <64.00g     0
  /dev/sdb1             lvm2 ---   <5.00g <5.00g
  /dev/sdc1             lvm2 ---   <5.00g <5.00g
*/

-- Step 28 -->> On All Nodes (LVM Partition Configuration - Verify pvs)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# pvdisplay /dev/sdb1
/*
   "/dev/sdb1" is a new physical volume of "<5.00 GiB"
  --- NEW Physical volume ---
  PV Name               /dev/sdb1
  VG Name
  PV Size               <5.00 GiB
  Allocatable           NO
  PE Size               0
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               yU0L0T-CH6i-pB9l-KqAv-8yS1-2UAx-Yuz66w

  */

-- Step 29 -->> On All Nodes (LVM Partition Configuration - Verify pvs)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# pvdisplay /dev/sdc1
/*
  "/dev/sdc1" is a new physical volume of "<5.00 GiB"
  --- NEW Physical volume ---
  PV Name               /dev/sdc1
  VG Name
  PV Size               <5.00 GiB
  Allocatable           NO
  PE Size               0
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               U33QgN-387d-1w8W-vGHA-78rc-jv0a-70DOyw

*/

-- Step 30 -->> On All Nodes (LVM Partition Configuration - Create vgs)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# vgcreate datastore_vg /dev/sdb1
/*
  Volume group "datastore_vg_vg" successfully created
*/

-- Step 31 -->> On All Nodes (LVM Partition Configuration - Create vgs)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# vgcreate backupstore_vg /dev/sdc1
/*
  Volume group "backupstore_vg_vg" successfully created
*/

-- Step 31.1 -->> On All Nodes (LVM Partition Configuration - Create vgs)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# vgs
/*
   VG             #PV #LV #SN Attr   VSize   VFree
  Ubuntu-lvm       1   6   0 wz--n- <64.00g     0
  backupstore_vg   1   0   0 wz--n-  <5.00g <5.00g
  datastore_vg     1   0   0 wz--n-  <5.00g <5.00g

*/

-- Step 32 -->> On All Nodes (LVM Partition Configuration - Verify vgs)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# vgdisplay datastore_vg
/*
  --- Volume group ---
  VG Name               datastore_vg
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  1
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                0
  Open LV               0
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               <5.00 GiB
  PE Size               4.00 MiB
  Total PE              1279
  Alloc PE / Size       0 / 0
  Free  PE / Size       1279 / <5.00 GiB
  VG UUID               xQG0u5-I3B6-lDaa-mc33-lvet-1TBG-hZbzpx

*/

-- Step 33 -->> On All Nodes (LVM Partition Configuration - Verify vgs)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# vgdisplay backupstore_vg
/*
  --- Volume group ---
  VG Name               backupstore_vg
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  1
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                0
  Open LV               0
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               <5.00 GiB
  PE Size               4.00 MiB
  Total PE              1279
  Alloc PE / Size       0 / 0
  Free  PE / Size       1279 / <5.00 GiB
  VG UUID               bb0daz-hhRM-Xr0l-1Cw4-5s8r-j8BM-vzJPbk
*/

-- Step 34 -->> On All Nodes (LVM Partition Configuration - Less Than VG Size)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# lvcreate -n datastore_lv -L 4.9GB datastore_vg
/*
  Rounding up size to full physical extent 4.90 GiB
  Logical volume "datastore_lv" created.
*/

-- Step 35 -->> On All Nodes (LVM Partition Configuration - Less Than VG Size)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# lvcreate -n backupstore_lv -L 4.9GB backupstore_vg
/*
   Rounding up size to full physical extent 4.90 GiB
  Logical volume "backupstore_lv" created.

*/

-- Step 36 -->> On All Nodes (LVM Partition Configuration - Verify)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# lvs
/*
  LV             VG             Attr       LSize  Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  root           Ubuntu-lvm     -wi-ao---- 25.00g
  swap           Ubuntu-lvm     -wi-ao---- <9.00g
  tmp            Ubuntu-lvm     -wi-ao----  6.00g
  usr            Ubuntu-lvm     -wi-ao----  8.00g
  usr_var        Ubuntu-lvm     -wi-ao----  8.00g
  var            Ubuntu-lvm     -wi-ao----  8.00g
  backupstore_lv backupstore_vg -wi-a-----  4.90g
  datastore_lv   datastore_vg   -wi-a-----  4.90g
*/

-- Step 37 -->> On All Nodes (LVM Partition Configuration - Verify)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# fdisk -ll | grep lv
/*
root@mongodbtest-pri:~# fdisk -ll | grep lv
Disk /dev/mapper/Ubuntu--lvm-root: 25 GiB, 26843545600 bytes, 52428800 sectors
Disk /dev/mapper/Ubuntu--lvm-var: 8 GiB, 8589934592 bytes, 16777216 sectors
Disk /dev/mapper/Ubuntu--lvm-usr: 8 GiB, 8589934592 bytes, 16777216 sectors
Disk /dev/mapper/Ubuntu--lvm-usr_var: 8 GiB, 8589934592 bytes, 16777216 sectors
Disk /dev/mapper/Ubuntu--lvm-tmp: 6 GiB, 6442450944 bytes, 12582912 sectors
Disk /dev/mapper/Ubuntu--lvm-swap: 9 GiB, 9659482112 bytes, 18866176 sectors
Disk /dev/mapper/datastore_vg-datastore_lv: 4.9 GiB, 5263851520 bytes, 10280960 sectors
Disk /dev/mapper/backupstore_vg-backupstore_lv: 4.9 GiB, 5263851520 bytes, 10280960 sectors

*/

-- Step 38 -->> On Node 1 (LVM Partition Configuration - Verify)
root@mongodbtest-pri:~# lvdisplay /dev/mapper/datastore_vg-datastore_lv
/*
  --- Logical volume ---
  LV Path                /dev/datastore_vg/datastore_lv
  LV Name                datastore_lv
  VG Name                datastore_vg
  LV UUID                FZ8DoW-XWde-56yZ-AFDA-mgeq-frkN-ljukPu
  LV Write Access        read/write
  LV Creation host, time mongodbtest-pri.com.np, 2024-06-20 09:54:52 +0000
  LV Status              available
  # open                 0
  LV Size                4.90 GiB
  Current LE             1255
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:6

*/

-- Step 38.1 -->> On Node 2 (LVM Partition Configuration - Verify)
root@mongodbtest-sec:~# lvdisplay /dev/mapper/datastore_vg-datastore_lv
/*
   --- Logical volume ---
  LV Path                /dev/datastore_vg/datastore_lv
  LV Name                datastore_lv
  VG Name                datastore_vg
  LV UUID                8zWwyH-jyZq-QzWV-0Ba2-Brjy-P6wG-lkwgPU
  LV Write Access        read/write
  LV Creation host, time mongodbtest-sec.com.np, 2024-06-20 09:55:54 +0000
  LV Status              available
  # open                 0
  LV Size                4.90 GiB
  Current LE             1255
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:6

*/

-- Step 38.2 -->> On Node 3 (LVM Partition Configuration - Verify)
root@mongotest-arb:~# lvdisplay /dev/mapper/datastore_vg-datastore_lv
/*
   --- Logical volume ---
  LV Path                /dev/datastore_vg/datastore_lv
  LV Name                datastore_lv
  VG Name                datastore_vg
  LV UUID                YWh7kq-v0cs-eiH1-KBmR-mY31-apAY-uZ8Ahu
  LV Write Access        read/write
  LV Creation host, time mongotest-arb.com.np, 2024-06-20 09:56:03 +0000
  LV Status              available
  # open                 0
  LV Size                4.90 GiB
  Current LE             1255
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:6

*/

-- Step 39 -->> On Node 1 (LVM Partition Configuration - Verify)
root@mongodbtest-pri:~# lvdisplay /dev/mapper/backupstore_vg-backupstore_lv
/*
   --- Logical volume ---
  LV Path                /dev/backupstore_vg/backupstore_lv
  LV Name                backupstore_lv
  VG Name                backupstore_vg
  LV UUID                9Nso4O-yDG3-myoz-HWc1-SWuv-tHHw-TMLHWD
  LV Write Access        read/write
  LV Creation host, time mongodbtest-pri.com.np, 2024-06-20 09:55:44 +0000
  LV Status              available
  # open                 0
  LV Size                4.90 GiB
  Current LE             1255
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:7
*/

-- Step 39.1 -->> On Node 1 (LVM Partition Configuration - Verify)
root@mongodbtest-sec:~# lvdisplay /dev/mapper/backupstore_vg-backupstore_lv
/*
  --- Logical volume ---
  LV Path                /dev/backupstore_vg/backupstore_lv
  LV Name                backupstore_lv
  VG Name                backupstore_vg
  LV UUID                KXZCSG-JKtP-eMul-Desv-rsUy-6AfG-wPkvCC
  LV Write Access        read/write
  LV Creation host, time mongodbtest-sec.com.np, 2024-06-20 09:56:13 +0000
  LV Status              available
  # open                 0
  LV Size                4.90 GiB
  Current LE             1255
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:7

*/

-- Step 39.2 -->> On Node 1 (LVM Partition Configuration - Verify)
root@mongotest-arb:~# lvdisplay /dev/mapper/backupstore_vg-backupstore_lv
/*
  ---- Logical volume ---
  LV Path                /dev/backupstore_vg/backupstore_lv
  LV Name                backupstore_lv
  VG Name                backupstore_vg
  LV UUID                V9J0lo-HPhP-Z05T-AoJ9-aJOZ-5YE9-NyGxwd
  LV Write Access        read/write
  LV Creation host, time mongotest-arb.com.np, 2024-06-20 09:56:16 +0000
  LV Status              available
  # open                 0
  LV Size                4.90 GiB
  Current LE             1255
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:7
*/

-- Step 40 -->> On All Nodes (LVM Partition Configuration - Format LVM Partition)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# mkfs.xfs /dev/mapper/datastore_vg-datastore_lv
/*
mmeta-data=/dev/mapper/datastore_vg-datastore_lv isize=512    agcount=4, agsize=321280 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1    bigtime=0 inobtcount=0
data     =                       bsize=4096   blocks=1285120, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

*/

-- Step 41 -->> On All Nodes (LVM Partition Configuration - Format LVM Partition)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# mkfs.xfs /dev/mapper/backupstore_vg-backupstore_lv
/*
meta-data=/dev/mapper/backupstore_vg-backupstore_lv isize=512    agcount=4, agsize=321280 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1    bigtime=0 inobtcount=0
data     =                       bsize=4096   blocks=1285120, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

*/

-- Step 42 -->> On All Nodes (LVM Partition Configuration - Verify)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# lsblk
/*
NAME                    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
loop0                     7:0    0 63.9M  1 loop /snap/core20/2105
loop1                     7:1    0   87M  1 loop /snap/lxd/27037
loop2                     7:2    0 40.4M  1 loop /snap/snapd/20671
sda                       8:0    0   90G  0 disk
├─sda1                    8:1    0    1M  0 part
├─sda2                    8:2    0    2G  0 part /boot
└─sda3                    8:3    0   88G  0 part
  ├─mongodb-root        252:0    0   31G  0 lvm  /
  ├─mongodb-home        252:1    0    8G  0 lvm  /home
  ├─mongodb-srv         252:2    0    8G  0 lvm  /srv
  ├─mongodb-usr         252:3    0    8G  0 lvm  /usr
  ├─mongodb-var         252:4    0    8G  0 lvm  /var
  ├─mongodb-var_lib     252:5    0    8G  0 lvm  /var/lib
  ├─mongodb-tmp         252:6    0    8G  0 lvm  /tmp
  └─mongodb-swap        252:7    0    8G  0 lvm  [SWAP]
sdb                       8:16   0   10G  0 disk
└─sdb1                    8:17   0   10G  0 part
  └─data_vg-data_lv     252:8    0  9.9G  0 lvm
sdc                       8:32   0   10G  0 disk
└─sdc1                    8:33   0   10G  0 part
  └─backup_vg-backup_lv 252:9    0  9.9G  0 lvm
sr0                      11:0    1    2G  0 rom
*/

-- Step 43 -->> On Node 1 (LVM Partition Configuration - Verify)
root@mongodbtest-pri:~# blkid
/*
/dev/mapper/mongodb-home: UUID="4b9c2b5e-799f-4368-b7c1-d5c81daee418" BLOCK_SIZE="512" TYPE="xfs"
/dev/mapper/mongodb-tmp: UUID="cb85fe59-bfdf-4961-85b5-949160c4b242" BLOCK_SIZE="512" TYPE="xfs"
/dev/mapper/mongodb-var: UUID="8d48ce8c-56b5-4b17-970b-62000ee5ddd1" BLOCK_SIZE="512" TYPE="xfs"
/dev/sr0: BLOCK_SIZE="2048" UUID="2024-02-16-23-52-30-00" LABEL="Ubuntu-Server 22.04.4 LTS amd64" TYPE="iso9660" PTTYPE="PMBR"
/dev/mapper/mongodb-srv: UUID="af00ff68-fe95-4460-abd2-ecd207705500" BLOCK_SIZE="512" TYPE="xfs"
/dev/mapper/mongodb-root: UUID="45a3cf65-bfcc-40dd-99cd-4338bfcb2750" BLOCK_SIZE="512" TYPE="xfs"
/dev/mapper/mongodb-swap: UUID="2951c1d8-02f5-4f90-9641-17a862e45985" TYPE="swap"
/dev/sda2: UUID="682b2783-b60a-48d5-bbf8-9763182930fa" BLOCK_SIZE="512" TYPE="xfs" PARTUUID="9cfff297-8843-406e-bbf6-533850c16f79"
/dev/sda3: UUID="QBsdNh-LU9X-8Q9i-BsJA-Rl09-sqFD-LalfP5" TYPE="LVM2_member" PARTUUID="b690948e-387a-47d5-8e86-5f3641f5f1d5"
/dev/mapper/mongodb-var_lib: UUID="5bf89ca3-6712-43f2-bb83-8d15dfc0fdb0" BLOCK_SIZE="512" TYPE="xfs"
/dev/mapper/mongodb-usr: UUID="819321d4-26dc-48d7-a4b5-c728c127c9ae" BLOCK_SIZE="512" TYPE="xfs"
/dev/loop1: TYPE="squashfs"
/dev/mapper/data_vg-data_lv: UUID="f207b96f-597b-4391-9c05-307bd9102c9a" BLOCK_SIZE="512" TYPE="xfs"
/dev/sdb1: UUID="uzIAQQ-qISP-o0jT-mLhN-rbV2-5G6I-RRrpvg" TYPE="LVM2_member" PARTUUID="8ac75535-01"
/dev/loop2: TYPE="squashfs"
/dev/loop0: TYPE="squashfs"
/dev/mapper/backup_vg-backup_lv: UUID="42bfdeba-34e8-41e0-a6b1-113add0250cd" BLOCK_SIZE="512" TYPE="xfs"
/dev/sdc1: UUID="AszBlT-87SP-Eo3j-Np8N-mBE3-aZYY-LJeqU3" TYPE="LVM2_member" PARTUUID="1fd490e3-01"
/dev/sda1: PARTUUID="501f7fb7-ae44-4942-a999-33e09df25c39"
*/

-- Step 43.1 -->> On Node 2 (LVM Partition Configuration - Verify)
root@mongodbtest-sec:~# blkid
/*
/dev/mapper/Ubuntu--lvm-var: UUID="496fe04a-9864-4966-965e-fbcfb467e306" BLOCK_SIZE="512" TYPE="xfs"
/dev/mapper/Ubuntu--lvm-tmp: UUID="847be3ce-7967-4e45-aa9d-f29a705a4086" BLOCK_SIZE="512" TYPE="xfs"
/dev/mapper/Ubuntu--lvm-usr: UUID="323da2b8-18e7-4903-a622-56210bdbc326" BLOCK_SIZE="512" TYPE="xfs"
/dev/mapper/Ubuntu--lvm-root: UUID="46d38ba2-ceda-4708-b4a1-147188b0176a" BLOCK_SIZE="512" TYPE="xfs"
/dev/sda2: UUID="ca404bb9-d842-430b-9627-718aefec7709" BLOCK_SIZE="512" TYPE="xfs" PARTUUID="f061e28a-9d4b-42d1-8257-8a1358acace3"
/dev/sda3: UUID="1JrdPw-HV5b-Sb18-gAC7-JC2j-Pytx-dxaCJ5" TYPE="LVM2_member" PARTUUID="29b5892a-cc66-4aee-b1b3-8d7950cb98fb"
/dev/mapper/Ubuntu--lvm-swap: UUID="2c41ee05-36df-4c7d-ae7c-03dc2a05dc98" TYPE="swap"
/dev/mapper/Ubuntu--lvm-usr_var: UUID="14bdf0c1-d35e-4b76-aa85-931ec11b0268" BLOCK_SIZE="512" TYPE="xfs"
/dev/sdb1: UUID="0ew2TC-eWhh-d52U-bGg3-kdrA-bVgA-whoCkC" TYPE="LVM2_member" PARTUUID="c67b580d-01"
/dev/mapper/datastore_vg-datastore_lv: UUID="af17b417-8b5c-41bc-9991-206ff3897f10" BLOCK_SIZE="512" TYPE="xfs"
/dev/loop2: TYPE="squashfs"
/dev/loop0: TYPE="squashfs"
/dev/sdc1: UUID="XjU5xQ-vvGy-wrse-2H73-mEGa-4k2W-5Tc2jQ" TYPE="LVM2_member" PARTUUID="9158197a-01"
/dev/mapper/backupstore_vg-backupstore_lv: UUID="2ea7e123-cd53-4190-b42c-1777cdad7f66" BLOCK_SIZE="512" TYPE="xfs"
/dev/sda1: PARTUUID="8e39a13d-2b91-4ae6-8bb7-62287dc1a4e8"
*/

-- Step 43.2 -->> On Node 3 (LVM Partition Configuration - Verify)
root@mongotest-arb:~# blkid
/*
/dev/mapper/Ubuntu--lvm-var: UUID="496fe04a-9864-4966-965e-fbcfb467e306" BLOCK_SIZE="512" TYPE="xfs"
/dev/mapper/Ubuntu--lvm-tmp: UUID="847be3ce-7967-4e45-aa9d-f29a705a4086" BLOCK_SIZE="512" TYPE="xfs"
/dev/mapper/Ubuntu--lvm-usr: UUID="323da2b8-18e7-4903-a622-56210bdbc326" BLOCK_SIZE="512" TYPE="xfs"
/dev/mapper/Ubuntu--lvm-root: UUID="46d38ba2-ceda-4708-b4a1-147188b0176a" BLOCK_SIZE="512" TYPE="xfs"
/dev/sda2: UUID="ca404bb9-d842-430b-9627-718aefec7709" BLOCK_SIZE="512" TYPE="xfs" PARTUUID="f061e28a-9d4b-42d1-8257-8a1358acace3"
/dev/sda3: UUID="1JrdPw-HV5b-Sb18-gAC7-JC2j-Pytx-dxaCJ5" TYPE="LVM2_member" PARTUUID="29b5892a-cc66-4aee-b1b3-8d7950cb98fb"
/dev/mapper/Ubuntu--lvm-swap: UUID="2c41ee05-36df-4c7d-ae7c-03dc2a05dc98" TYPE="swap"
/dev/mapper/Ubuntu--lvm-usr_var: UUID="14bdf0c1-d35e-4b76-aa85-931ec11b0268" BLOCK_SIZE="512" TYPE="xfs"
/dev/loop1: TYPE="squashfs"
/dev/sdb1: UUID="YZkh6B-5vyT-gief-H986-Iqhc-rlEL-TXGjIi" TYPE="LVM2_member" PARTUUID="440bfa88-01"
/dev/mapper/datastore_vg-datastore_lv: UUID="c7acb5be-b9e1-48f0-b57f-fb23643b709b" BLOCK_SIZE="512" TYPE="xfs"
/dev/loop0: TYPE="squashfs"
/dev/sdc1: UUID="6KAQU1-7QH8-REHT-KFsW-DDdq-G4hH-vqPGe4" TYPE="LVM2_member" PARTUUID="fa189366-01"
/dev/mapper/backupstore_vg-backupstore_lv: UUID="cf47f0a0-dce0-4423-81d9-56b543861021" BLOCK_SIZE="512" TYPE="xfs"
/dev/sda1: PARTUUID="8e39a13d-2b91-4ae6-8bb7-62287dc1a4e8"
*/

-- Step 44 -->> On All Nodes (LVM Partition Configuration - Before)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# df -Th
/*
Filesystem                                                                                   Type   Size  Used Avail Use% Mounted on
tmpfs                                                                                        tmpfs  193M  1.3M  192M   1% /run
/dev/mapper/Ubuntu--lvm-root                                                                 xfs     25G  4.1G   21G  17% /
/dev/disk/by-id/dm-uuid-LVM-aQ6HcOyCreCv48lHoDG1hR8RLOrZAlOf0nRIeARLZS9taPsERnFRRrSbV4ap7K0A xfs    8.0G  3.2G  4.9G  40% /usr
tmpfs                                                                                        tmpfs  964M     0  964M   0% /dev/shm
tmpfs                                                                                        tmpfs  5.0M     0  5.0M   0% /run/lock
/dev/mapper/Ubuntu--lvm-var                                                                  xfs    8.0G  332M  7.7G   5% /var
/dev/sda2                                                                                    xfs   1014M  292M  722M  29% /boot
/dev/mapper/Ubuntu--lvm-tmp                                                                  xfs    6.0G   76M  6.0G   2% /tmp
/dev/mapper/Ubuntu--lvm-usr_var                                                              xfs    8.0G  794M  7.3G  10% /var/lib
tmpfs                                                                                        tmpfs  193M  4.0K  193M   1% /run/user/1000

*/

-- Step 45 -->> On All Nodes (LVM Partition Configuration - Mount Additional LVM)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# mkdir -p /datastore
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# mkdir -p /backupstore
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# mount /dev/mapper/datastore_vg-datastore_lv /datastore
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# mount /dev/mapper/backupstore_vg-backupstore_lv /backupstore
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# df -Th
/*
Filesystem                                                                                   Type   Size  Used Avail Use% Mounted on
tmpfs                                                                                        tmpfs  193M  1.3M  192M   1% /run
/dev/mapper/Ubuntu--lvm-root                                                                 xfs     25G  4.1G   21G  17% /
/dev/disk/by-id/dm-uuid-LVM-aQ6HcOyCreCv48lHoDG1hR8RLOrZAlOf0nRIeARLZS9taPsERnFRRrSbV4ap7K0A xfs    8.0G  3.2G  4.9G  40% /usr
tmpfs                                                                                        tmpfs  964M     0  964M   0% /dev/shm
tmpfs                                                                                        tmpfs  5.0M     0  5.0M   0% /run/lock
/dev/mapper/Ubuntu--lvm-var                                                                  xfs    8.0G  332M  7.7G   5% /var
/dev/sda2                                                                                    xfs   1014M  292M  722M  29% /boot
/dev/mapper/Ubuntu--lvm-tmp                                                                  xfs    6.0G   76M  6.0G   2% /tmp
/dev/mapper/Ubuntu--lvm-usr_var                                                              xfs    8.0G  794M  7.3G  10% /var/lib
tmpfs                                                                                        tmpfs  193M  4.0K  193M   1% /run/user/1000
/dev/mapper/datastore_vg-datastore_lv                                                        xfs    4.9G   68M  4.9G   2% /datastore
/dev/mapper/backupstore_vg-backupstore_lv                                                    xfs    4.9G   68M  4.9G   2% /backupstore
*/

-- Step 46 -->> On All Nodes (LVM Partition Configuration - UMount Additional LVM)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# umount /datastore

-- Step 47 -->> On All Nodes (LVM Partition Configuration - UMount Additional LVM)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# umount /backupstore

-- Step 48 -->> On All Nodes (LVM Partition Configuration - Verify)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# df -Th
/*
Filesystem                                                                                   Type   Size  Used Avail Use% Mounted on
tmpfs                                                                                        tmpfs  193M  1.3M  192M   1% /run
/dev/mapper/Ubuntu--lvm-root                                                                 xfs     25G  4.1G   21G  17% /
/dev/disk/by-id/dm-uuid-LVM-aQ6HcOyCreCv48lHoDG1hR8RLOrZAlOf0nRIeARLZS9taPsERnFRRrSbV4ap7K0A xfs    8.0G  3.2G  4.9G  40% /usr
tmpfs                                                                                        tmpfs  964M     0  964M   0% /dev/shm
tmpfs                                                                                        tmpfs  5.0M     0  5.0M   0% /run/lock
/dev/mapper/Ubuntu--lvm-var                                                                  xfs    8.0G  332M  7.7G   5% /var
/dev/sda2                                                                                    xfs   1014M  292M  722M  29% /boot
/dev/mapper/Ubuntu--lvm-tmp                                                                  xfs    6.0G   76M  6.0G   2% /tmp
/dev/mapper/Ubuntu--lvm-usr_var                                                              xfs    8.0G  794M  7.3G  10% /var/lib
tmpfs                                                                                        tmpfs  193M  4.0K  193M   1% /run/user/1000
*/

-- Step 49 -->> On Node 1 (LVM Partition Configuration - Verify)
root@mongodbtest-pri:~# blkid
/*
/dev/mapper/Ubuntu--lvm-var: UUID="496fe04a-9864-4966-965e-fbcfb467e306" BLOCK_SIZE="512" TYPE="xfs"
/dev/mapper/Ubuntu--lvm-tmp: UUID="847be3ce-7967-4e45-aa9d-f29a705a4086" BLOCK_SIZE="512" TYPE="xfs"
/dev/sr0: BLOCK_SIZE="2048" UUID="2022-03-30-02-46-35-00" LABEL="Ubuntu-Server 22.04 LTS amd64" TYPE="iso9660" PTTYPE="PMBR"
/dev/mapper/Ubuntu--lvm-usr: UUID="323da2b8-18e7-4903-a622-56210bdbc326" BLOCK_SIZE="512" TYPE="xfs"
/dev/mapper/Ubuntu--lvm-root: UUID="46d38ba2-ceda-4708-b4a1-147188b0176a" BLOCK_SIZE="512" TYPE="xfs"
/dev/sda2: UUID="ca404bb9-d842-430b-9627-718aefec7709" BLOCK_SIZE="512" TYPE="xfs" PARTUUID="f061e28a-9d4b-42d1-8257-8a1358acace3"
/dev/sda3: UUID="1JrdPw-HV5b-Sb18-gAC7-JC2j-Pytx-dxaCJ5" TYPE="LVM2_member" PARTUUID="29b5892a-cc66-4aee-b1b3-8d7950cb98fb"
/dev/mapper/Ubuntu--lvm-swap: UUID="2c41ee05-36df-4c7d-ae7c-03dc2a05dc98" TYPE="swap"
/dev/mapper/Ubuntu--lvm-usr_var: UUID="14bdf0c1-d35e-4b76-aa85-931ec11b0268" BLOCK_SIZE="512" TYPE="xfs"
/dev/sdb1: UUID="yU0L0T-CH6i-pB9l-KqAv-8yS1-2UAx-Yuz66w" TYPE="LVM2_member" PARTUUID="c667cde5-01"
/dev/mapper/datastore_vg-datastore_lv: UUID="ead311d0-4667-492d-81b3-a058b1d793d2" BLOCK_SIZE="512" TYPE="xfs"
/dev/loop0: TYPE="squashfs"
/dev/sdc1: UUID="U33QgN-387d-1w8W-vGHA-78rc-jv0a-70DOyw" TYPE="LVM2_member" PARTUUID="3ec2927b-01"
/dev/mapper/backupstore_vg-backupstore_lv: UUID="18309781-6fea-4f02-ba66-0be13467ecc9" BLOCK_SIZE="512" TYPE="xfs"
/dev/loop3: TYPE="squashfs"
/dev/sda1: PARTUUID="8e39a13d-2b91-4ae6-8bb7-62287dc1a4e8"
*/

-- Step 49.1 -->> On Node 2 (LVM Partition Configuration - Verify)
root@mongodbtest-sec:~# blkid
/*
/dev/mapper/Ubuntu--lvm-var: UUID="496fe04a-9864-4966-965e-fbcfb467e306" BLOCK_SIZE="512" TYPE="xfs"
/dev/mapper/Ubuntu--lvm-tmp: UUID="847be3ce-7967-4e45-aa9d-f29a705a4086" BLOCK_SIZE="512" TYPE="xfs"
/dev/mapper/Ubuntu--lvm-usr: UUID="323da2b8-18e7-4903-a622-56210bdbc326" BLOCK_SIZE="512" TYPE="xfs"
/dev/mapper/Ubuntu--lvm-root: UUID="46d38ba2-ceda-4708-b4a1-147188b0176a" BLOCK_SIZE="512" TYPE="xfs"
/dev/sda2: UUID="ca404bb9-d842-430b-9627-718aefec7709" BLOCK_SIZE="512" TYPE="xfs" PARTUUID="f061e28a-9d4b-42d1-8257-8a1358acace3"
/dev/sda3: UUID="1JrdPw-HV5b-Sb18-gAC7-JC2j-Pytx-dxaCJ5" TYPE="LVM2_member" PARTUUID="29b5892a-cc66-4aee-b1b3-8d7950cb98fb"
/dev/mapper/Ubuntu--lvm-swap: UUID="2c41ee05-36df-4c7d-ae7c-03dc2a05dc98" TYPE="swap"
/dev/mapper/Ubuntu--lvm-usr_var: UUID="14bdf0c1-d35e-4b76-aa85-931ec11b0268" BLOCK_SIZE="512" TYPE="xfs"
/dev/sdb1: UUID="0ew2TC-eWhh-d52U-bGg3-kdrA-bVgA-whoCkC" TYPE="LVM2_member" PARTUUID="c67b580d-01"
/dev/mapper/datastore_vg-datastore_lv: UUID="af17b417-8b5c-41bc-9991-206ff3897f10" BLOCK_SIZE="512" TYPE="xfs"
/dev/loop2: TYPE="squashfs"
/dev/loop0: TYPE="squashfs"
/dev/sdc1: UUID="XjU5xQ-vvGy-wrse-2H73-mEGa-4k2W-5Tc2jQ" TYPE="LVM2_member" PARTUUID="9158197a-01"
/dev/mapper/backupstore_vg-backupstore_lv: UUID="2ea7e123-cd53-4190-b42c-1777cdad7f66" BLOCK_SIZE="512" TYPE="xfs"
/dev/sda1: PARTUUID="8e39a13d-2b91-4ae6-8bb7-62287dc1a4e8"
*/

-- Step 49.2 -->> On Node 3 (LVM Partition Configuration - Verify)
root@mongotest-arb:~# blkid
/*
/dev/mapper/Ubuntu--lvm-var: UUID="496fe04a-9864-4966-965e-fbcfb467e306" BLOCK_SIZE="512" TYPE="xfs"
/dev/mapper/Ubuntu--lvm-tmp: UUID="847be3ce-7967-4e45-aa9d-f29a705a4086" BLOCK_SIZE="512" TYPE="xfs"
/dev/mapper/Ubuntu--lvm-usr: UUID="323da2b8-18e7-4903-a622-56210bdbc326" BLOCK_SIZE="512" TYPE="xfs"
/dev/mapper/Ubuntu--lvm-root: UUID="46d38ba2-ceda-4708-b4a1-147188b0176a" BLOCK_SIZE="512" TYPE="xfs"
/dev/sda2: UUID="ca404bb9-d842-430b-9627-718aefec7709" BLOCK_SIZE="512" TYPE="xfs" PARTUUID="f061e28a-9d4b-42d1-8257-8a1358acace3"
/dev/sda3: UUID="1JrdPw-HV5b-Sb18-gAC7-JC2j-Pytx-dxaCJ5" TYPE="LVM2_member" PARTUUID="29b5892a-cc66-4aee-b1b3-8d7950cb98fb"
/dev/mapper/Ubuntu--lvm-swap: UUID="2c41ee05-36df-4c7d-ae7c-03dc2a05dc98" TYPE="swap"
/dev/mapper/Ubuntu--lvm-usr_var: UUID="14bdf0c1-d35e-4b76-aa85-931ec11b0268" BLOCK_SIZE="512" TYPE="xfs"
/dev/loop1: TYPE="squashfs"
/dev/sdb1: UUID="YZkh6B-5vyT-gief-H986-Iqhc-rlEL-TXGjIi" TYPE="LVM2_member" PARTUUID="440bfa88-01"
/dev/mapper/datastore_vg-datastore_lv: UUID="c7acb5be-b9e1-48f0-b57f-fb23643b709b" BLOCK_SIZE="512" TYPE="xfs"
/dev/loop0: TYPE="squashfs"
/dev/sdc1: UUID="6KAQU1-7QH8-REHT-KFsW-DDdq-G4hH-vqPGe4" TYPE="LVM2_member" PARTUUID="fa189366-01"
/dev/mapper/backupstore_vg-backupstore_lv: UUID="cf47f0a0-dce0-4423-81d9-56b543861021" BLOCK_SIZE="512" TYPE="xfs"
/dev/sda1: PARTUUID="8e39a13d-2b91-4ae6-8bb7-62287dc1a4e8"

*/

-- Step 50 -->> On Node 1 (LVM Partition Configuration - Add the id's of LVM to make permanent mount)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# vi /etc/fstab
/*
# /etc/fstab: static file system information.
#
# Use 'blkid' to print the universally unique identifier for a
# device; this may be used with UUID= as a more robust way to name devices
# that works even if disks are added and removed. See fstab(5).
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
/dev/disk/by-id/dm-uuid-LVM-3ptCeLXDFgsxMn412K5qwRMotc1eqWRhV90Cr9phhH7DGVFE4mB84aBsFsN5myvr none swap sw 0 0
# / was on /dev/mongodb_1_p/root during curtin installation
/dev/disk/by-id/dm-uuid-LVM-3ptCeLXDFgsxMn412K5qwRMotc1eqWRh49L15chgkda6mVsp2MW143GHrAxkwg41 / xfs defaults 0 1
# /boot was on /dev/sda2 during curtin installation
/dev/disk/by-uuid/682b2783-b60a-48d5-bbf8-9763182930fa /boot xfs defaults 0 1
# /home was on /dev/mongodb_1_p/home during curtin installation
/dev/disk/by-id/dm-uuid-LVM-3ptCeLXDFgsxMn412K5qwRMotc1eqWRhd38yTQA0ijRGrw3hi9y1no4P6vJ7d2yc /home xfs defaults 0 1
# /srv was on /dev/mongodb_1_p/srv during curtin installation
/dev/disk/by-id/dm-uuid-LVM-3ptCeLXDFgsxMn412K5qwRMotc1eqWRhtQ7QUnK3EhEhvZBhVSlGJi3qa6eZnglV /srv xfs defaults 0 1
# /usr was on /dev/mongodb_1_p/usr during curtin installation
/dev/disk/by-id/dm-uuid-LVM-3ptCeLXDFgsxMn412K5qwRMotc1eqWRhYVA9bhAXVnBn98NZplLdnF5JkdxNYsOC /usr xfs defaults 0 1
# /var was on /dev/mongodb_1_p/var during curtin installation
/dev/disk/by-id/dm-uuid-LVM-3ptCeLXDFgsxMn412K5qwRMotc1eqWRhQvQGF7G38QQT7W1l9AizATgZrDXzUWHJ /var xfs defaults 0 1
# /var/lib was on /dev/mongodb_1_p/var_lib during curtin installation
/dev/disk/by-id/dm-uuid-LVM-3ptCeLXDFgsxMn412K5qwRMotc1eqWRhB12gPksBZQxnQNE3fTBTUWrCpDVbbg7l /var/lib xfs defaults 0 1
# /tmp was on /dev/mongodb_1_p/tmp during curtin installation
/dev/disk/by-id/dm-uuid-LVM-3ptCeLXDFgsxMn412K5qwRMotc1eqWRhmmqGtgFwf5u8l65xi0AN5c3H9F1gpwXc /tmp xfs defaults 0 1
#data
/dev/mapper/datastore_vg-datastore_lv /datastore xfs defaults 0 1
#backup
/dev/mapper/backupstore_vg-backupstore_lv /backupstore xfs defaults 0 1
*/

-- Step 51 -->> On All Nodes (LVM Partition Configuration - Verify)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# df -Th
/*
Filesystem                                                                                   Type   Size  Used Avail Use% Mounted on
tmpfs                                                                                        tmpfs  193M  1.3M  192M   1% /run
/dev/mapper/Ubuntu--lvm-root                                                                 xfs     25G  4.1G   21G  17% /
/dev/disk/by-id/dm-uuid-LVM-aQ6HcOyCreCv48lHoDG1hR8RLOrZAlOf0nRIeARLZS9taPsERnFRRrSbV4ap7K0A xfs    8.0G  3.2G  4.9G  40% /usr
tmpfs                                                                                        tmpfs  964M     0  964M   0% /dev/shm
tmpfs                                                                                        tmpfs  5.0M     0  5.0M   0% /run/lock
/dev/mapper/Ubuntu--lvm-var                                                                  xfs    8.0G  332M  7.7G   5% /var
/dev/sda2                                                                                    xfs   1014M  292M  722M  29% /boot
/dev/mapper/Ubuntu--lvm-tmp                                                                  xfs    6.0G   76M  6.0G   2% /tmp
/dev/mapper/Ubuntu--lvm-usr_var                                                              xfs    8.0G  794M  7.3G  10% /var/lib
tmpfs                                                                                        tmpfs  193M  4.0K  193M   1% /run/user/1000

*/

-- Step 52 -->> On All Nodes (LVM Partition Configuration - Make permanent mount)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# mount -a

-- Step 53 -->> On All Nodes (LVM Partition Configuration - Verify)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# df -Th
/*
Filesystem                                                                                   Type   Size  Used Avail Use% Mounted on
tmpfs                                                                                        tmpfs  193M  1.3M  192M   1% /run
/dev/mapper/Ubuntu--lvm-root                                                                 xfs     25G  4.1G   21G  17% /
/dev/disk/by-id/dm-uuid-LVM-aQ6HcOyCreCv48lHoDG1hR8RLOrZAlOf0nRIeARLZS9taPsERnFRRrSbV4ap7K0A xfs    8.0G  3.2G  4.9G  40% /usr
tmpfs                                                                                        tmpfs  964M     0  964M   0% /dev/shm
tmpfs                                                                                        tmpfs  5.0M     0  5.0M   0% /run/lock
/dev/mapper/Ubuntu--lvm-var                                                                  xfs    8.0G  332M  7.7G   5% /var
/dev/sda2                                                                                    xfs   1014M  292M  722M  29% /boot
/dev/mapper/Ubuntu--lvm-tmp                                                                  xfs    6.0G   76M  6.0G   2% /tmp
/dev/mapper/Ubuntu--lvm-usr_var                                                              xfs    8.0G  794M  7.3G  10% /var/lib
tmpfs                                                                                        tmpfs  193M  4.0K  193M   1% /run/user/1000
/dev/mapper/datastore_vg-datastore_lv                                                        xfs    4.9G   68M  4.9G   2% /datastore
/dev/mapper/backupstore_vg-backupstore_lv                                                    xfs    4.9G   68M  4.9G   2% /backupstore
*/

-- Step 54 -->> On All Nodes (LVM Partition Configuration - Reboot)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# init 6

-- Step 55 -->> On All Nodes (LVM Partition Configuration - Verify)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# df -Th
/*
Filesystem                                                                                   Type   Size  Used Avail Use% Mounted on
tmpfs                                                                                        tmpfs  388M  1.5M  386M   1% /run
/dev/mapper/mongodb-root                                                                     xfs     31G  269M   31G   1% /
/dev/disk/by-id/dm-uuid-LVM-3ptCeLXDFgsxMn412K5qwRMotc1eqWRhYVA9bhAXVnBn98NZplLdnF5JkdxNYsOC xfs    8.0G  3.5G  4.6G  43% /usr
tmpfs                                                                                        tmpfs  1.9G     0  1.9G   0% /dev/shm
tmpfs                                                                                        tmpfs  5.0M     0  5.0M   0% /run/lock
/dev/mapper/backup_vg-backup_lv                                                              xfs    9.9G  103M  9.8G   2% /backup
/dev/mapper/data_vg-data_lv                                                                  xfs    9.9G  103M  9.8G   2% /data
/dev/mapper/mongodb-srv                                                                      xfs    8.0G   90M  8.0G   2% /srv
/dev/mapper/mongodb-home                                                                     xfs    8.0G   90M  8.0G   2% /home
/dev/mapper/mongodb-tmp                                                                      xfs    8.0G   90M  8.0G   2% /tmp
/dev/sda2                                                                                    xfs    2.0G  338M  1.7G  17% /boot
/dev/mapper/mongodb-var                                                                      xfs    8.0G  258M  7.8G   4% /var
/dev/mapper/mongodb-var_lib                                                                  xfs    8.0G  711M  7.3G   9% /var/lib
tmpfs                                                                                        tmpfs  388M  4.0K  388M   1% /run/user/1000

*/

-- Step 56 -->> On All Nodes (LVM Partition Configuration - Verify)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# lsblk
/*
NAME                    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
loop0                     7:0    0 63.9M  1 loop /snap/core20/2105
loop1                     7:1    0   87M  1 loop /snap/lxd/27037
loop2                     7:2    0 40.4M  1 loop /snap/snapd/20671
sda                       8:0    0   90G  0 disk
├─sda1                    8:1    0    1M  0 part
├─sda2                    8:2    0    2G  0 part /boot
└─sda3                    8:3    0   88G  0 part
  ├─mongodb-root        252:0    0   31G  0 lvm  /
  ├─mongodb-home        252:1    0    8G  0 lvm  /home
  ├─mongodb-srv         252:2    0    8G  0 lvm  /srv
  ├─mongodb-usr         252:3    0    8G  0 lvm  /usr
  ├─mongodb-var         252:4    0    8G  0 lvm  /var
  ├─mongodb-var_lib     252:5    0    8G  0 lvm  /var/lib
  ├─mongodb-tmp         252:6    0    8G  0 lvm  /tmp
  └─mongodb-swap        252:7    0    8G  0 lvm  [SWAP]
sdb                       8:16   0   10G  0 disk
└─sdb1                    8:17   0   10G  0 part
  └─data_vg-data_lv     252:9    0  9.9G  0 lvm  /data
sdc                       8:32   0   10G  0 disk
└─sdc1                    8:33   0   10G  0 part
  └─backup_vg-backup_lv 252:8    0  9.9G  0 lvm  /backup
sr0                      11:0    1    2G  0 rom

*/

-- Step 57 -->> On All Nodes (Create Backup Directories)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:/# mkdir -p /backupstore/mongodbFullBackup
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:/# chown -R mongodb:mongodb /backupstore/
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:/# chmod -R 775 /backupstore/

-- Step 58 -->> On All Nodes
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:/# ll | grep backupstore
/*

*/

-- Step 59 -->> On All Nodes
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:/# ll  backupstore/
/*
drwxrwxr-x.  3 mongodb mongodb   31 Jun 23 06:54 ./
drwxr-xr-x. 20 root    root    4096 Jun 20 16:00 ../
drwxrwxr-x.  2 mongodb mongodb    6 Jun 23 06:54 mongodbFullBackup/

*/

-- Step 60 -->> On All Nodes (Create Data/Log Directories)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:/# mkdir -p /datastore/mongodb
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:/# mkdir -p /datastore/log
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:/# chown -R mongodb:mongodb /datastore/
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:/# chmod -R 777 /datastore/

-- Step 61 -->> On All Nodes
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:/# ll | grep datastore
/*

*/

-- Step 62 -->> On All Nodes
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:/# ll  datastore/
/*
drwxrwxrwx.  4 mongodb mongodb   32 Jun 23 07:01 ./
drwxr-xr-x. 21 root    root    4096 Jun 23 07:00 ../
drwxrwxrwx.  2 mongodb mongodb    6 Jun 23 07:01 log/
drwxrwxrwx.  2 mongodb mongodb    6 Jun 23 07:00 mongodb/
*/

-- Step 63 -->> On Node 1 (Verfy the ssh connection)
root@mongodbtest-pri:~# ssh mongodb@192.168.120.70

-- Step 63.1 -->> On Node 2 (Verfy the ssh connection)
root@mongodbtest-sec:~# ssh mongodb@192.168.120.71

-- Step 63.2 -->> On Node 3 (Verfy the ssh connection)
root@mongotest-arb:~# ssh mongodb@192.168.120.72


-- Step 64 -->> On All Nodes (Install gnupg and curl)
mongodb@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~$ sudo apt-get install gnupg curl
/*
[sudo] password for mongodb:mongodb
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
curl is already the newest version (7.81.0-1ubuntu1.16).
curl set to manually installed.
gnupg is already the newest version (2.2.27-3ubuntu2.1).
gnupg set to manually installed.
The following packages were automatically installed and are no longer required:
  libflashrom1 libftdi1-2 ltrace
Use 'sudo apt autoremove' to remove them.
0 upgraded, 0 newly installed, 0 to remove and 2 not upgraded.

*/

-- Step 65 -->> On All Nodes (To import the MongoDB public GPG key)
mongodb@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~$ curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
   --dearmor

-- Step 66 -->> On All Nodes (Verification)
mongodb@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~$ apt-key list
/*
Warning: apt-key is deprecated. Manage keyring files in trusted.gpg.d instead (see apt-key(8)).
/etc/apt/trusted.gpg.d/ubuntu-keyring-2012-cdimage.gpg
------------------------------------------------------
pub   rsa4096 2012-05-11 [SC]
      8439 38DF 228D 22F7 B374  2BC0 D94A A3F0 EFE2 1092
uid           [ unknown] Ubuntu CD Image Automatic Signing Key (2012) <cdimage@ubuntu.com>

/etc/apt/trusted.gpg.d/ubuntu-keyring-2018-archive.gpg
------------------------------------------------------
pub   rsa4096 2018-09-17 [SC]
      F6EC B376 2474 EDA9 D21B  7022 8719 20D1 991B C93C
uid           [ unknown] Ubuntu Archive Automatic Signing Key (2018) <ftpmaster@ubuntu.com>

*/

-- Step 67 -->> On All Nodes (Create the repo-list file /etc/apt/sources.list.d/mongodb-org-7.0.list)
mongodb@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~$ echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
/*
deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse
*/

-- Step 68 -->> On All Nodes (Update the Local RPM's)
mongodb@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~$ sudo apt-get update
/*
Ign:1 https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 InRelease
Hit:2 http://np.archive.ubuntu.com/ubuntu jammy InRelease
Get:3 http://np.archive.ubuntu.com/ubuntu jammy-updates InRelease [128 kB]
Get:4 https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 Release [2,090 B]
Get:5 https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 Release.gpg [866 B]
Hit:6 http://np.archive.ubuntu.com/ubuntu jammy-backports InRelease
Get:7 http://np.archive.ubuntu.com/ubuntu jammy-security InRelease [129 kB]
Get:8 http://np.archive.ubuntu.com/ubuntu jammy-updates/main amd64 Packages [1,734 kB]
Get:9 https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0/multiverse amd64 Packages [42.7 kB]
Get:10 https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0/multiverse arm64 Packages [41.4 kB]
Get:11 http://np.archive.ubuntu.com/ubuntu jammy-updates/main Translation-en [319 kB]
Get:12 http://np.archive.ubuntu.com/ubuntu jammy-updates/restricted amd64 Packages [1,997 kB]
Get:13 http://np.archive.ubuntu.com/ubuntu jammy-updates/restricted Translation-en [339 kB]
Get:14 http://np.archive.ubuntu.com/ubuntu jammy-updates/universe amd64 Packages [1,087 kB]
Get:15 http://np.archive.ubuntu.com/ubuntu jammy-updates/universe Translation-en [251 kB]
Get:16 http://np.archive.ubuntu.com/ubuntu jammy-updates/multiverse amd64 Packages [43.3 kB]
Get:17 http://np.archive.ubuntu.com/ubuntu jammy-updates/multiverse Translation-en [10.8 kB]
Get:18 http://np.archive.ubuntu.com/ubuntu jammy-security/main amd64 Packages [1,526 kB]
Get:19 http://np.archive.ubuntu.com/ubuntu jammy-security/main Translation-en [261 kB]
Get:20 http://np.archive.ubuntu.com/ubuntu jammy-security/restricted amd64 Packages [1,937 kB]
Get:21 http://np.archive.ubuntu.com/ubuntu jammy-security/restricted Translation-en [330 kB]
Get:22 http://np.archive.ubuntu.com/ubuntu jammy-security/universe amd64 Packages [860 kB]
Get:23 http://np.archive.ubuntu.com/ubuntu jammy-security/universe Translation-en [167 kB]
Fetched 11.2 MB in 8s (1,417 kB/s)
Reading package lists... Done

*/

-- Step 69 -->> On All Nodes (Verification)
mongodb@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~$ sudo apt list --upgradable
/*
Listing... Done
python3-update-manager/jammy-updates 1:22.04.20 all [upgradable from: 1:22.04.9]
update-manager-core/jammy-updates 1:22.04.20 all [upgradable from: 1:22.04.9]

*/

mongodb@mongodbtest-sec:~$ sudo apt-get upgrade python3-update-manager update-manager-core
/*
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
Calculating upgrade... Done
The following packages were automatically installed and are no longer required:
  libflashrom1 libftdi1-2 ltrace
Use 'sudo apt autoremove' to remove them.
The following packages will be upgraded:
  python3-update-manager update-manager-core
2 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
Need to get 50.7 kB of archives.
After this operation, 6,144 B of additional disk space will be used.
Do you want to continue? [Y/n] y
Get:1 http://np.archive.ubuntu.com/ubuntu jammy-updates/main amd64 python3-update-manager all 1:22.04.20 [39.1 kB]
Get:2 http://np.archive.ubuntu.com/ubuntu jammy-updates/main amd64 update-manager-core all 1:22.04.20 [11.5 kB]
Fetched 50.7 kB in 1s (44.4 kB/s)
(Reading database ... 113536 files and directories currently installed.)
Preparing to unpack .../python3-update-manager_1%3a22.04.20_all.deb ...
Unpacking python3-update-manager (1:22.04.20) over (1:22.04.9) ...
Preparing to unpack .../update-manager-core_1%3a22.04.20_all.deb ...
Unpacking update-manager-core (1:22.04.20) over (1:22.04.9) ...
Setting up python3-update-manager (1:22.04.20) ...
Setting up update-manager-core (1:22.04.20) ...
Scanning processes...
Scanning linux images...

Running kernel seems to be up-to-date.

No services need to be restarted.

No containers need to be restarted.

No user sessions are running outdated binaries.

No VM guests are running outdated hypervisor (qemu) binaries on this host.
*/



-- Step 70 -->> On All Nodes (Install the MongoDB packages)
mongodb@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~$ sudo apt-get install -y mongodb-org
/*
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following packages were automatically installed and are no longer required:
  libflashrom1 libftdi1-2 ltrace
Use 'sudo apt autoremove' to remove them.
The following additional packages will be installed:
  mongodb-database-tools mongodb-mongosh mongodb-org-database mongodb-org-database-tools-extra mongodb-org-mongos mongodb-org-server mongodb-org-shell
  mongodb-org-tools
The following NEW packages will be installed:
  mongodb-database-tools mongodb-mongosh mongodb-org mongodb-org-database mongodb-org-database-tools-extra mongodb-org-mongos mongodb-org-server
  mongodb-org-shell mongodb-org-tools
0 upgraded, 9 newly installed, 0 to remove and 0 not upgraded.
Need to get 169 MB of archives.
After this operation, 577 MB of additional disk space will be used.
Get:1 https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0/multiverse amd64 mongodb-database-tools amd64 100.9.5 [53.1 MB]
Get:2 https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0/multiverse amd64 mongodb-mongosh amd64 2.2.9 [53.4 MB]
Get:3 https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0/multiverse amd64 mongodb-org-shell amd64 7.0.11 [2,984 B]
Get:4 https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0/multiverse amd64 mongodb-org-server amd64 7.0.11 [36.7 MB]
Get:5 https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0/multiverse amd64 mongodb-org-mongos amd64 7.0.11 [25.6 MB]
Get:6 https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0/multiverse amd64 mongodb-org-database-tools-extra amd64 7.0.11 [7,778 B]
Get:7 https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0/multiverse amd64 mongodb-org-database amd64 7.0.11 [3,426 B]
Get:8 https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0/multiverse amd64 mongodb-org-tools amd64 7.0.11 [2,772 B]
Get:9 https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0/multiverse amd64 mongodb-org amd64 7.0.11 [2,804 B]
Fetched 169 MB in 13s (12.9 MB/s)
Selecting previously unselected package mongodb-database-tools.
(Reading database ... 113536 files and directories currently installed.)
Preparing to unpack .../0-mongodb-database-tools_100.9.5_amd64.deb ...
Unpacking mongodb-database-tools (100.9.5) ...
Selecting previously unselected package mongodb-mongosh.
Preparing to unpack .../1-mongodb-mongosh_2.2.9_amd64.deb ...
Unpacking mongodb-mongosh (2.2.9) ...
Selecting previously unselected package mongodb-org-shell.
Preparing to unpack .../2-mongodb-org-shell_7.0.11_amd64.deb ...
Unpacking mongodb-org-shell (7.0.11) ...
Selecting previously unselected package mongodb-org-server.
Preparing to unpack .../3-mongodb-org-server_7.0.11_amd64.deb ...
Unpacking mongodb-org-server (7.0.11) ...
Selecting previously unselected package mongodb-org-mongos.
Preparing to unpack .../4-mongodb-org-mongos_7.0.11_amd64.deb ...
Unpacking mongodb-org-mongos (7.0.11) ...
Selecting previously unselected package mongodb-org-database-tools-extra.
Preparing to unpack .../5-mongodb-org-database-tools-extra_7.0.11_amd64.deb ...
Unpacking mongodb-org-database-tools-extra (7.0.11) ...
Selecting previously unselected package mongodb-org-database.
Preparing to unpack .../6-mongodb-org-database_7.0.11_amd64.deb ...
Unpacking mongodb-org-database (7.0.11) ...
Selecting previously unselected package mongodb-org-tools.
Preparing to unpack .../7-mongodb-org-tools_7.0.11_amd64.deb ...
Unpacking mongodb-org-tools (7.0.11) ...
Selecting previously unselected package mongodb-org.
Preparing to unpack .../8-mongodb-org_7.0.11_amd64.deb ...
Unpacking mongodb-org (7.0.11) ...
Setting up mongodb-mongosh (2.2.9) ...
Setting up mongodb-org-server (7.0.11) ...
Setting up mongodb-org-shell (7.0.11) ...
Setting up mongodb-database-tools (100.9.5) ...
Setting up mongodb-org-mongos (7.0.11) ...
Setting up mongodb-org-database-tools-extra (7.0.11) ...
Setting up mongodb-org-database (7.0.11) ...
Setting up mongodb-org-tools (7.0.11) ...
Setting up mongodb-org (7.0.11) ...
Processing triggers for man-db (2.10.2-1) ...
Scanning processes...
Scanning linux images...

Running kernel seems to be up-to-date.

No services need to be restarted.

No containers need to be restarted.

No user sessions are running outdated binaries.

No VM guests are running outdated hypervisor (qemu) binaries on this host.

*/

-- Step 71 -->> On All Nodes (MongoDB Configuration)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:/# cp -r /etc/mongod.conf /etc/mongod.conf.backup

-- Step 72 -->> On All Nodes (MongoDB Configuration)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:/# ll /etc/ | grep mongo
/*
-rw-r--r--.  1 root root        578 Dec 19  2013 mongod.conf
-rw-r--r--.  1 root root        578 Jun 23 07:23 mongod.conf.backup
*/

-- Step 73 -->> On All Nodes (MongoDB Configuration)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:/# vi /etc/mongod.conf
/*
# mongod.conf

# for documentation of all options, see:
#   http://docs.mongodb.org/manual/reference/configuration-options/

# Where and how to store data.
storage:
  dbPath: /datastore/mongodb
#  engine:
#  wiredTiger:

# where to write logging data.
systemLog:
  destination: file
  logAppend: true
  path: /datastore/log/mongod.log

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

-- Step 74 -->> On Node 1 (Tuning For MongoDB)
root@mongodbtest-pri:/# vi /etc/mongod.conf
/*
# network interfaces
net:
  port: 27017
  bindIp: 127.0.0.1,192.168.56.159
  maxIncomingConnections: 999999
*/

-- Step 74.1 -->> On Node 2 (Tuning For MongoDB)
root@mongodbtest-sec:/# vi /etc/mongod.conf
/*
# network interfaces
net:
  port: 27017
  bindIp: 127.0.0.1,192.168.56.160
  maxIncomingConnections: 999999
*/

-- Step 74.2 -->> On Node 3 (Tuning For MongoDB)
root@mongotest-arb:/# vi /etc/mongod.conf
/*
# network interfaces
net:
  port: 27017
  bindIp: 127.0.0.1,192.168.56.161
  maxIncomingConnections: 999999
*/

-- Step 75 -->> On All Nodes (Tuning For MongoDB)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:/# ulimit -a
/*
real-time non-blocking time  (microseconds, -R) unlimited
core file size              (blocks, -c) 0
data seg size               (kbytes, -d) unlimited
scheduling priority                 (-e) 0
file size                   (blocks, -f) unlimited
pending signals                     (-i) 7251
max locked memory           (kbytes, -l) 246748
max memory size             (kbytes, -m) unlimited
open files                          (-n) 1024
pipe size                (512 bytes, -p) 8
POSIX message queues         (bytes, -q) 819200
real-time priority                  (-r) 0
stack size                  (kbytes, -s) 8192
cpu time                   (seconds, -t) unlimited
max user processes                  (-u) 7251
virtual memory              (kbytes, -v) unlimited
file locks                          (-x) unlimited

*/

-- Step 76 -->> On All Nodes (Tuning For MongoDB)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:/# ulimit -n 64000

-- Step 77 -->> On All Nodes (Tuning For MongoDB)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:/# ulimit -a
/*
real-time non-blocking time  (microseconds, -R) unlimited
core file size              (blocks, -c) 0
data seg size               (kbytes, -d) unlimited
scheduling priority                 (-e) 0
file size                   (blocks, -f) unlimited
pending signals                     (-i) 7251
max locked memory           (kbytes, -l) 246748
max memory size             (kbytes, -m) unlimited
open files                          (-n) 64000
pipe size                (512 bytes, -p) 8
POSIX message queues         (bytes, -q) 819200
real-time priority                  (-r) 0
stack size                  (kbytes, -s) 8192
cpu time                   (seconds, -t) unlimited
max user processes                  (-u) 7251
virtual memory              (kbytes, -v) unlimited
file locks                          (-x) unlimited

*/

-- Step 78 -->> On All Nodes (Tuning For MongoDB)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:/# echo "mongodb           soft    nofile          9999999" | tee -a /etc/security/limits.conf
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:/# echo "mongodb           hard    nofile          9999999" | tee -a /etc/security/limits.conf
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:/# echo "mongodb           soft    nproc           9999999" | tee -a /etc/security/limits.conf
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:/# echo "mongodb           hard    nproc           9999999" | tee -a /etc/security/limits.conf
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:/# echo "mongodb           soft    stack           9999999" | tee -a /etc/security/limits.conf
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:/# echo "mongodb           hard    stack           9999999" | tee -a /etc/security/limits.conf
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:/# echo 9999999 > /proc/sys/vm/max_map_count
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:/# echo "vm.max_map_count=9999999" | tee -a /etc/sysctl.conf
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:/# echo 1024 65530 > /proc/sys/net/ipv4/ip_local_port_range
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:/# echo "net.ipv4.ip_local_port_range = 1024 65530" | tee -a /etc/sysctl.conf

-- Step 79 -->> On All Nodes (Enable MongoDB)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:/# systemctl enable mongod --now
/*
Created symlink /etc/systemd/system/multi-user.target.wants/mongod.service → /lib/systemd/system/mongod.service.
*/

-- Step 80 -->> On All Nodes (Start MongoDB)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:/# systemctl start mongod

-- Step 81 -->> On All Nodes (Verify MongoDB)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:/# systemctl status mongod
/*
●● mongod.service - MongoDB Database Server
     Loaded: loaded (/lib/systemd/system/mongod.service; enabled; vendor preset: enabled)
     Active: active (running) since Sun 2024-06-23 07:44:22 +0545; 55s ago
       Docs: https://docs.mongodb.org/manual
   Main PID: 3616 (mongod)
     Memory: 73.7M
        CPU: 1.636s
     CGroup: /system.slice/mongod.service
             └─3616 /usr/bin/mongod --config /etc/mongod.conf

Jun 23 07:44:22 mongodbtest-pri.com.np systemd[1]: Started MongoDB Database Server.
Jun 23 07:44:22 mongodbtest-pri.com.np mongod[3616]: {"t":{"$date":"2024-06-23T01:59:22.227Z"},"s":"I",  "c":"CONTROL",  "id":7484500, "ctx":"main","msg>
*/

-- Step 82 -->> On All Nodes (Begin using MongoDB)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:/# mongosh
/*
Current Mongosh Log ID: 667781ef8e26e7e133597192
Connecting to:          mongodb://127.0.0.1:27017/?directConnection=true&serverSelectionTimeoutMS=2000&appName=mongosh+2.2.9
Using MongoDB:          7.0.11
Using Mongosh:          2.2.9

For mongosh info see: https://docs.mongodb.com/mongodb-shell/


To help improve our products, anonymous usage data is collected and sent to MongoDB periodically (https://www.mongodb.com/legal/privacy-policy).
You can opt-out by running the disableTelemetry() command.

------
   The server generated these startup warnings when booting
   2024-06-23T07:44:23.363+05:45: Access control is not enabled for the database. Read and write access to data and configuration is unrestricted


test> db.version()
7.0.11
test> show dbs
aadmin   40.00 KiB
config  12.00 KiB
local   40.00 KiB
test> quit()
*/

-- Step 83 -->> On All Nodes (Default DBPath)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# ll /var/lib/mongodb/
/*
drwxr-xr-x.  2 mongodb mongodb    6 Jun 23 07:21 ./
drwxr-xr-x. 43 root    root    4096 Jun 23 07:21 ../
*/

-- Step 84 -->> On All Nodes (Default LogPath)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# ll /var/log/mongodb/
/*
drwxr-xr-x.  2 mongodb mongodb    6 Jun 23 07:21 ./
drwxrwxr-x. 10 root    syslog  4096 Jun 23 07:21 ../

*/

-- Step 85 -->> On All Nodes (Manuall DBPath)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# ll /datastore/mongodb/
/*
drwxrwxrwx. 4 mongodb mongodb  4096 Jun 23 07:52 ./
drwxrwxrwx. 4 mongodb mongodb    32 Jun 23 07:01 ../
-rw-------. 1 mongodb mongodb 20480 Jun 23 07:45 collection-0--1213528133744675262.wt
-rw-------. 1 mongodb mongodb 20480 Jun 23 07:45 collection-2--1213528133744675262.wt
-rw-------. 1 mongodb mongodb 36864 Jun 23 07:50 collection-4--1213528133744675262.wt
drwx------. 2 mongodb mongodb    71 Jun 23 07:52 diagnostic.data/
-rw-------. 1 mongodb mongodb 20480 Jun 23 07:45 index-1--1213528133744675262.wt
-rw-------. 1 mongodb mongodb 20480 Jun 23 07:45 index-3--1213528133744675262.wt
-rw-------. 1 mongodb mongodb 36864 Jun 23 07:50 index-5--1213528133744675262.wt
-rw-------. 1 mongodb mongodb 36864 Jun 23 07:50 index-6--1213528133744675262.wt
drwx------. 2 mongodb mongodb   110 Jun 23 07:44 journal/
-rw-------. 1 mongodb mongodb 20480 Jun 23 07:45 _mdb_catalog.wt
-rw-------. 1 mongodb mongodb     5 Jun 23 07:44 mongod.lock
-rw-------. 1 mongodb mongodb 36864 Jun 23 07:50 sizeStorer.wt
-rw-------. 1 mongodb mongodb   114 Jun 23 07:44 storage.bson
-rw-------. 1 mongodb mongodb    50 Jun 23 07:44 WiredTiger
-rw-------. 1 mongodb mongodb  4096 Jun 23 07:44 WiredTigerHS.wt
-rw-------. 1 mongodb mongodb    21 Jun 23 07:44 WiredTiger.lock
-rw-------. 1 mongodb mongodb  1465 Jun 23 07:52 WiredTiger.turtle
-rw-------. 1 mongodb mongodb 69632 Jun 23 07:52 WiredTiger.wt

*/

-- Step 86 -->> On All Nodes (Manuall LogPath)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# tail -f /datastore/log/mongod.log
/*
{"t":{"$date":"2024-06-23T07:49:23.412+05:45"},"s":"I",  "c":"WTCHKPT",  "id":22430,   "ctx":"Checkpointer","msg":"WiredTiger message","attr":{"message":{"ts_sec":1719108263,"ts_usec":412579,"thread":"3616:0x7f964fbc6640","session_name":"WT_SESSION.checkpoint","category":"WT_VERB_CHECKPOINT_PROGRESS","category_id":6,"verbose_level":"DEBUG_1","verbose_level_id":1,"msg":"saving checkpoint snapshot min: 39, snapshot max: 39 snapshot count: 0, oldest timestamp: (0, 0) , meta checkpoint timestamp: (0, 0) base write gen: 1"}}}
{"t":{"$date":"2024-06-23T07:50:23.426+05:45"},"s":"I",  "c":"WTCHKPT",  "id":22430,   "ctx":"Checkpointer","msg":"WiredTiger message","attr":{"message":{"ts_sec":1719108323,"ts_usec":426454,"thread":"3616:0x7f964fbc6640","session_name":"WT_SESSION.checkpoint","category":"WT_VERB_CHECKPOINT_PROGRESS","category_id":6,"verbose_level":"DEBUG_1","verbose_level_id":1,"msg":"saving checkpoint snapshot min: 42, snapshot max: 42 snapshot count: 0, oldest timestamp: (0, 0) , meta checkpoint timestamp: (0, 0) base write gen: 1"}}}
{"t":{"$date":"2024-06-23T07:50:29.097+05:45"},"s":"I",  "c":"NETWORK",  "id":22944,   "ctx":"conn4","msg":"Connection ended","attr":{"remote":"127.0.0.1:64266","uuid":{"uuid":{"$uuid":"23f127ee-2bf4-48e2-b524-b834f64b425a"}},"connectionId":4,"connectionCount":4}}
{"t":{"$date":"2024-06-23T07:50:29.097+05:45"},"s":"I",  "c":"-",        "id":20883,   "ctx":"conn1","msg":"Interrupted operation as its client disconnected","attr":{"opId":4469}}

*/

-- Step 87 -->> On All Nodes (Stop MongoDB)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:/# systemctl stop mongod

-- Step 88 -->> On All Nodes (Find the location of MongoDB)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:/# which mongosh
/*
/usr/bin/mongosh
*/

-- Step 89 -->> On All Nodes (After MongoDB Version 4.4 the "mongo" shell is not avilable)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:/# cd /usr/bin/

-- Step 90 -->> On All Nodes
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:/usr/bin# ll | grep mongo
/*
-rwxr-xr-x.  1 root  root    182749256 Dec 19  2013 mongod*
-rwxr-xr-x.  1 rabin rabin    16100880 Jun 17 20:21 mongodump*
-rwxr-xr-x.  1 rabin rabin    15795344 Jun 17 20:21 mongoexport*
-rwxr-xr-x.  1 rabin rabin    16672816 Jun 17 20:21 mongofiles*
-rwxr-xr-x.  1 rabin rabin    16040888 Jun 17 20:21 mongoimport*
-rwxr-xr-x.  1 rabin rabin    16431696 Jun 17 20:21 mongorestore*
-rwxr-xr-x.  1 root  root    130102896 Dec 19  2013 mongos*
-rwxr-xr-x.  1 root  root    149526272 Jun 14 16:43 mongosh*
-rwxr-xr-x.  1 rabin rabin    15654160 Jun 17 20:21 mongostat*
-rwxr-xr-x.  1 rabin rabin    15225320 Jun 17 20:21 mongotop*

*/

-- Step 91 -->> On All Nodes (Make a copy of mongosh as mongo)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:/usr/bin# cp mongosh mongo

-- Step 92 -->> On All Nodes
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:/usr/bin# ll | grep mongo
/*
-rwxr-xr-x.  1 root  root    149526272 Jun 23 07:58 mongo*
-rwxr-xr-x.  1 root  root    182749256 Dec 19  2013 mongod*
-rwxr-xr-x.  1 rabin rabin    16100880 Jun 17 20:21 mongodump*
-rwxr-xr-x.  1 rabin rabin    15795344 Jun 17 20:21 mongoexport*
-rwxr-xr-x.  1 rabin rabin    16672816 Jun 17 20:21 mongofiles*
-rwxr-xr-x.  1 rabin rabin    16040888 Jun 17 20:21 mongoimport*
-rwxr-xr-x.  1 rabin rabin    16431696 Jun 17 20:21 mongorestore*
-rwxr-xr-x.  1 root  root    130102896 Dec 19  2013 mongos*
-rwxr-xr-x.  1 root  root    149526272 Jun 14 16:43 mongosh*
-rwxr-xr-x.  1 rabin rabin    15654160 Jun 17 20:21 mongostat*
-rwxr-xr-x.  1 rabin rabin    15225320 Jun 17 20:21 mongotop*

*/

-- Step 93 -->> On All Nodes (Start MongoDB)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# systemctl start mongod

-- Step 94 -->> On All Nodes (Verify MongoDB)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# systemctl status mongod
/*
● mongod.service - MongoDB Database Server
     Loaded: loaded (/lib/systemd/system/mongod.service; enabled; vendor preset: enabled)
     Active: active (running) since Sun 2024-06-23 07:59:16 +0545; 25s ago
       Docs: https://docs.mongodb.org/manual
   Main PID: 3731 (mongod)
     Memory: 178.2M
        CPU: 2.011s
     CGroup: /system.slice/mongod.service
             └─3731 /usr/bin/mongod --config /etc/mongod.conf

Jun 23 07:59:16 mongodbtest-pri.com.np systemd[1]: Started MongoDB Database Server.
Jun 23 07:59:16 mongodbtest-pri.com.np mongod[3731]: {"t":{"$date":"2024-06-23T02:14:16.360Z"},"s":"I",  "c":"CONTROL",  "id":7484500, "ctx":"main","msg>
*/

-- Step 95 -->> On All Nodes (Begin with MongoDB)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# mongosh
/*
Current Mongosh Log ID: 66778526ac0398ba73597192
Connecting to:          mongodb://127.0.0.1:27017/?directConnection=true&serverSelectionTimeoutMS=2000&appName=mongosh+2.2.9
Using MongoDB:          7.0.11
Using Mongosh:          2.2.9

For mongosh info see: https://docs.mongodb.com/mongodb-shell/

------
   The server generated these startup warnings when booting
   2024-06-23T07:59:17.973+05:45: Access control is not enabled for the database. Read and write access to data and configuration is unrestricted

------

test> db.version()
7.0.6
test> show dbs
admin   40.00 KiB
config  12.00 KiB
local   40.00 KiB
test> exit
*/

-- Step 96 -->> On All Nodes (Begin with MongoDB)
root@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~# mongo
/*
Current Mongosh Log ID: 66778551cce7707a2c597192
Connecting to:          mongodb://127.0.0.1:27017/?directConnection=true&serverSelectionTimeoutMS=2000&appName=mongosh+2.2.9
Using MongoDB:          7.0.11
Using Mongosh:          2.2.9

For mongosh info see: https://docs.mongodb.com/mongodb-shell/

------
   The server generated these startup warnings when booting
   2024-06-23T07:59:17.973+05:45: Access control is not enabled for the database. Read and write access to data and configuration is unrestricted

test> db.version()
7.0.6
test> show dbs
admin   40.00 KiB
config  12.00 KiB
local   72.00 KiB
test> exit
*/

-- Step 97 -->> On Node 1 (Switch user into MongoDB)
root@mongodbtest-pri:~# su - mongodb
mongodb@mongodbtest-pri:~$ sudo systemctl status mongod
/*
[sudo] password for mongodb:
● mongod.service - MongoDB Database Server
     Loaded: loaded (/lib/systemd/system/mongod.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2024-06-24 07:11:05 +0545; 3min 13s ago
       Docs: https://docs.mongodb.org/manual
   Main PID: 1461 (mongod)
     Memory: 264.5M
        CPU: 8.247s
     CGroup: /system.slice/mongod.service
             └─1461 /usr/bin/mongod --config /etc/mongod.conf

Jun 24 07:11:05 mongodbtest-pri.com.np systemd[1]: Started MongoDB Database Server.
Jun 24 07:11:08 mongodbtest-pri.com.np mongod[1461]: {"t":{"$date":"2024-06-24T01:26:08.206Z"},"s":"I",  "c":"CONTROL",  "id":7484500, "ctx":"main","msg>
*/

-- Step 98 -->> On Node 1 (Verify MongoDB)
mongodb@mongodbtest-pri:~$ mongosh --eval 'db.runCommand({ connectionStatus: 1 })'
/*
{
  authInfo: { authenticatedUsers: [], authenticatedUserRoles: [] },
  ok: 1
}

*/

-- Step 99 -->> On Node 1 (Begin with MongoDB - Create user for Authorized)
mongodb@mongodbtest-pri:~$ mongosh
/*
Current Mongosh Log ID: 6678cc5ae3d5e6cf0a597192
Connecting to:          mongodb://127.0.0.1:27017/?directConnection=true&serverSelectionTimeoutMS=2000&appName=mongosh+2.2.9
Using MongoDB:          7.0.11
Using Mongosh:          2.2.9

For mongosh info see: https://docs.mongodb.com/mongodb-shell/


To help improve our products, anonymous usage data is collected and sent to MongoDB periodically (https://www.mongodb.com/legal/privacy-policy).
You can opt-out by running the disableTelemetry() command.

------
   The server generated these startup warnings when booting
   2024-06-24T07:11:12.866+05:45: Access control is not enabled for the database. Read and write access to data and configuration is unrestricted

test> db.version()
7.0.11

test> show dbs
admin   40.00 KiB
config  60.00 KiB
local   72.00 KiB

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

-- Step 100 -->> On Node 1 (Stop MongoDB)
mongodb@mongodbtest-pri:~$ sudo systemctl stop mongod

-- Step 101 -->> On Node 1 (Access control is enabled for the database)
mongodb@mongodbtest-pri:~$ sudo vi /etc/mongod.conf
/*
#security:
security:
 authorization: enabled
*/

-- Step 102 -->> On Node 1 (Start MongoDB)
mongodb@mongodbtest-pri:~$ sudo systemctl start mongod

-- Step 103 -->> On Node 1 (Verify MongoDB)
mongodb@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~$ sudo systemctl status mongod
/*
● mongod.service - MongoDB Database Server
     Loaded: loaded (/lib/systemd/system/mongod.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2024-06-24 07:27:01 +0545; 14s ago
       Docs: https://docs.mongodb.org/manual
   Main PID: 2036 (mongod)
     Memory: 170.1M
        CPU: 1.656s
     CGroup: /system.slice/mongod.service
             └─2036 /usr/bin/mongod --config /etc/mongod.conf

Jun 24 07:27:01 mongodbtest-pri.com.np systemd[1]: Started MongoDB Database Server.
Jun 24 07:27:01 mongodbtest-pri.com.np mongod[2036]: {"t":{"$date":"2024-06-24T01:42:01.431Z"},"s":"I",  "c":"CONTROL",  "id":7484500, "ctx":"main","msg>
*/

-- Step 104 -->> On Node 1 (Begin with MongoDB)
mongodb@mongodbtest-pri:~$ mongosh
/*
Current Mongosh Log ID: 6678cf1f5f55d8c5ee597192
Connecting to:          mongodb://127.0.0.1:27017/?directConnection=true&serverSelectionTimeoutMS=2000&appName=mongosh+2.2.9
Using MongoDB:          7.0.11
Using Mongosh:          2.2.9

For mongosh info see: https://docs.mongodb.com/mongodb-shell/


test> db.version()
7.0.11

test> show dbs
MongoServerError[Unauthorized]: Command listDatabases requires authentication

test> quit()
*/

-- Step 105 -->> On Node 1 (Begin with MongoDB)
mongodb@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~$ mongo
/*
Current Mongosh Log ID: 65efe0292e4fc5bab3f2c39a
Connecting to:          mongodb://127.0.0.1:27017/?directConnection=true&serverSelectionTimeoutMS=2000&appName=mongosh+2.1.5
Using MongoDB:          7.0.6
Using Mongosh:          2.1.5

For mongosh info see: https://docs.mongodb.com/mongodb-shell/

test> db.version()
7.0.6

test> show dbs
MongoServerError[Unauthorized]: Command listDatabases requires authentication

test> exit
*/

-- Step 106 -->> On Node 1 (Begin with MongoDB using Access Details)
mongodb@mongodbtest-pri:~$ mongo --host 127.0.0.1 --port 27017 -u admin -p P#ssw0rd --authenticationDatabase admin
/*
Current Mongosh Log ID: 6678d06fc5cd460521597192
Connecting to:          mongodb://<credentials>@127.0.0.1:27017/?directConnection=true&serverSelectionTimeoutMS=2000&authSource=admin&appName=mongosh+2.2.9
Using MongoDB:          7.0.11
Using Mongosh:          2.2.9

For mongosh info see: https://docs.mongodb.com/mongodb-shell/


test> db.version()
7.0.11

test> show dbs
admin   132.00 KiB
config   96.00 KiB
local    72.00 KiB


test> quit()
*/

-- Step 107 -->> On Node 1 (Begin with MongoDB using Access Details)
mongodb@mongodbtest-pri:~$ mongosh --host 192.168.120.70 --port 27017 -u admin -p P#ssw0rd --authenticationDatabase admin
/*
Current Mongosh Log ID: 6678d0e406db529b03597192
Connecting to:          mongodb://<credentials>@192.168.120.70:27017/?directConnection=true&authSource=admin&appName=mongosh+2.2.9
Using MongoDB:          7.0.11
Using Mongosh:          2.2.9

For mongosh info see: https://docs.mongodb.com/mongodb-shell/


test> db.version()
7.0.6

test> show dbs
admin   132.00 KiB
config   96.00 KiB
local    72.00 KiB

test> use admin
switched to db admin

admin> db
admin

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

admin> exit
*/

-- Step 108 -->> On Node 2 (Begin with MongoDB)
root@mongodbtest-sec:~# su - mongodb
mongodb@mongodbtest-sec:~$ sudo systemctl status mongod
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

Jun 24 07:11:07 mongodbtest-sec.com.np systemd[1]: Started MongoDB Database Server.
Jun 24 07:11:09 mongodbtest-sec.com.np mongod[1457]: {"t":{"$date":"2024-06-24T01:26:09.885Z"},"s":"I",  "c":"CONTROL",  "id":7484500, "ctx":"main","msg>
*/

-- Step 109 -->> On Node 2 (Begin with MongoDB - Access control is enabled for the database)
mongodb@mongodbtest-sec:~$ sudo systemctl stop mongod

-- Step 110 -->> On Node 2 (Begin with MongoDB - Access control is enabled for the database)
mongodb@mongodbtest-sec:~$ sudo vi /etc/mongod.conf
/*
#security:
security:
 authorization: enabled
*/

-- Step 111 -->> On Node 2
mongodb@mongodbtest-sec:~$ sudo systemctl start mongod

-- Step 112 -->> On Node 2
mongodb@mongodbtest-sec:~$ sudo systemctl status mongod
/*
●● mongod.service - MongoDB Database Server
     Loaded: loaded (/lib/systemd/system/mongod.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2024-06-24 07:40:26 +0545; 6s ago
       Docs: https://docs.mongodb.org/manual
   Main PID: 2028 (mongod)
     Memory: 169.7M
        CPU: 1.565s
     CGroup: /system.slice/mongod.service
             └─2028 /usr/bin/mongod --config /etc/mongod.conf

Jun 24 07:40:26 mongodbtest-sec.com.np systemd[1]: Started MongoDB Database Server.
Jun 24 07:40:26 mongodbtest-sec.com.np mongod[2028]: {"t":{"$date":"2024-06-24T01:55:26.673Z"},"s":"I",  "c":"CONTROL",  "id":7484500, "ctx":"main","msg>
*/

-- Step 113 -->> On Node 3
root@mongotest-arb:~# su - mongodb
mongodb@mongotest-arb:~$ sudo systemctl status mongod
/*
● mongod.service - MongoDB Database Server
     Loaded: loaded (/lib/systemd/system/mongod.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2024-06-24 07:11:14 +0545; 30min ago
       Docs: https://docs.mongodb.org/manual
   Main PID: 1463 (mongod)
     Memory: 264.8M
        CPU: 27.709s
     CGroup: /system.slice/mongod.service
             └─1463 /usr/bin/mongod --config /etc/mongod.conf

Jun 24 07:11:14 mongotest-arb.com.np systemd[1]: Started MongoDB Database Server.
Jun 24 07:11:15 mongotest-arb.com.np mongod[1463]: {"t":{"$date":"2024-06-24T01:26:15.182Z"},"s":"I",  "c":"CONTROL",  "id":7484500, "ctx":"main","msg":>
*/

-- Step 114 -->> On Node 3 (Begin with MongoDB - Access control is enabled for the database)
mongodb@mongotest-arb:~$ sudo systemctl stop mongod

-- Step 115 -->> On Node 3 (Begin with MongoDB - Access control is enabled for the database)
mongodb@mongotest-arb:~$ sudo vi /etc/mongod.conf
/*
#security:
security:
  authorization: enabled
*/

-- Step 116 -->> On Node 3
mongodb@mongotest-arb:~$ sudo systemctl start mongod

-- Step 117 -->> On Node 3
mongodb@mongotest-arb:~$ sudo systemctl status mongod
/*
● mongod.service - MongoDB Database Server
     Loaded: loaded (/lib/systemd/system/mongod.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2024-06-24 07:43:04 +0545; 5s ago
       Docs: https://docs.mongodb.org/manual
   Main PID: 1925 (mongod)
     Memory: 171.8M
        CPU: 1.509s
     CGroup: /system.slice/mongod.service
             └─1925 /usr/bin/mongod --config /etc/mongod.conf

Jun 24 07:43:04 mongotest-arb.com.np systemd[1]: Started MongoDB Database Server.
Jun 24 07:43:04 mongotest-arb.com.np mongod[1925]: {"t":{"$date":"2024-06-24T01:58:04.401Z"},"s":"I",  "c":"CONTROL",  "id":7484500, "ctx":"main","msg":>
*/

-- Step 118 -->> On All Nodes (Verify the Status of MongoDB)
mongodb@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~$ sudo systemctl status mongod
/*
● mongod.service - MongoDB Database Server
     Loaded: loaded (/lib/systemd/system/mongod.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2024-06-24 07:27:01 +0545; 17min ago
       Docs: https://docs.mongodb.org/manual
   Main PID: 2036 (mongod)
     Memory: 172.1M
        CPU: 14.336s
     CGroup: /system.slice/mongod.service
             └─2036 /usr/bin/mongod --config /etc/mongod.conf

Jun 24 07:27:01 mongodbtest-pri.com.np systemd[1]: Started MongoDB Database Server.
Jun 24 07:27:01 mongodbtest-pri.com.np mongod[2036]: {"t":{"$date":"2024-06-24T01:42:01.431Z"},"s":"I",  "c":"CONTROL",  "id":7484500, "ctx":"main","msg>
*/

-- Step 119 -->> On All Nodes (Configure ReplicaSets)
mongodb@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~$ sudo vi /etc/mongod.conf
/*
#replication:
replication:
  replSetName: rs0
*/

-- Step 120 -->> On Node 1 (Configure ReplicaSets)
mongodb@mongodbtest-pri:~$ cd /datastore/mongodb/

-- Step 121 -->> On Node 1 (Configure ReplicaSets)
mongodb@mongodbtest-pri:/datastore/mongodb$ ll
/*
drwxrwxrwx. 4 mongodb mongodb  4096 Jun 24 07:47 ./
drwxrwxrwx. 4 mongodb mongodb    32 Jun 23 07:01 ../
-rw-------. 1 mongodb mongodb 36864 Jun 24 07:27 collection-0--1213528133744675262.wt
-rw-------. 1 mongodb mongodb 20480 Jun 24 07:27 collection-0-6731314958581996372.wt
-rw-------. 1 mongodb mongodb 36864 Jun 24 07:28 collection-2--1213528133744675262.wt
-rw-------. 1 mongodb mongodb 36864 Jun 24 07:47 collection-4--1213528133744675262.wt
drwx------. 2 mongodb mongodb  4096 Jun 24 07:47 diagnostic.data/
-rw-------. 1 mongodb mongodb 36864 Jun 24 07:27 index-1--1213528133744675262.wt
-rw-------. 1 mongodb mongodb 20480 Jun 24 07:26 index-1-6731314958581996372.wt
-rw-------. 1 mongodb mongodb 20480 Jun 24 07:33 index-2-6731314958581996372.wt
-rw-------. 1 mongodb mongodb 36864 Jun 24 07:28 index-3--1213528133744675262.wt
-rw-------. 1 mongodb mongodb 36864 Jun 24 07:47 index-5--1213528133744675262.wt
-rw-------. 1 mongodb mongodb 36864 Jun 24 07:47 index-6--1213528133744675262.wt
drwx------. 2 mongodb mongodb   110 Jun 24 07:27 journal/
-rw-------. 1 mongodb mongodb 36864 Jun 24 07:27 _mdb_catalog.wt
-rw-------. 1 mongodb mongodb     5 Jun 24 07:27 mongod.lock
-rw-------. 1 mongodb mongodb 36864 Jun 24 07:47 sizeStorer.wt
-rw-------. 1 mongodb mongodb   114 Jun 23 07:44 storage.bson
-rw-------. 1 mongodb mongodb    50 Jun 23 07:44 WiredTiger
-rw-------. 1 mongodb mongodb  4096 Jun 24 07:27 WiredTigerHS.wt
-rw-------. 1 mongodb mongodb    21 Jun 23 07:44 WiredTiger.lock
-rw-------. 1 mongodb mongodb  1472 Jun 24 07:47 WiredTiger.turtle
-rw-------. 1 mongodb mongodb 77824 Jun 24 07:47 WiredTiger.wt

*/

-- Step 122 -->> On Node 1 (Configure ReplicaSets)
mongodb@mongodbtest-pri:/datastore/mongodb$ openssl rand -base64 756 > keyfile

-- Step 123 -->> On Node 1 (Configure ReplicaSets)
mongodb@mongodbtest-pri:/datastore/mongodb$ chmod 400 keyfile

-- Step 124 -->> On Node 1 (Configure ReplicaSets)
mongodb@mongodbtest-pri:/datastore/mongodb$ ll
/*
drwxrwxrwx. 4 mongodb mongodb  4096 Jun 24 08:02 ./
drwxrwxrwx. 4 mongodb mongodb    32 Jun 23 07:01 ../
-rw-------. 1 mongodb mongodb 36864 Jun 24 07:27 collection-0--1213528133744675262.wt
-rw-------. 1 mongodb mongodb 20480 Jun 24 07:27 collection-0-6731314958581996372.wt
-rw-------. 1 mongodb mongodb 36864 Jun 24 07:28 collection-2--1213528133744675262.wt
-rw-------. 1 mongodb mongodb 24576 Jun 24 07:52 collection-4--1213528133744675262.wt
drwx------. 2 mongodb mongodb  4096 Jun 24 08:02 diagnostic.data/
-rw-------. 1 mongodb mongodb 36864 Jun 24 07:27 index-1--1213528133744675262.wt
-rw-------. 1 mongodb mongodb 20480 Jun 24 07:26 index-1-6731314958581996372.wt
-rw-------. 1 mongodb mongodb 20480 Jun 24 07:33 index-2-6731314958581996372.wt
-rw-------. 1 mongodb mongodb 36864 Jun 24 07:28 index-3--1213528133744675262.wt
-rw-------. 1 mongodb mongodb 36864 Jun 24 07:52 index-5--1213528133744675262.wt
-rw-------. 1 mongodb mongodb 24576 Jun 24 07:52 index-6--1213528133744675262.wt
drwx------. 2 mongodb mongodb   110 Jun 24 07:27 journal/
-rw-rw-r--. 1 mongodb mongodb  1024 Jun 24 08:01 keyfile
-rw-------. 1 mongodb mongodb 36864 Jun 24 07:27 _mdb_catalog.wt
-rw-------. 1 mongodb mongodb     5 Jun 24 07:27 mongod.lock
-rw-------. 1 mongodb mongodb 36864 Jun 24 07:52 sizeStorer.wt
-rw-------. 1 mongodb mongodb   114 Jun 23 07:44 storage.bson
-rw-------. 1 mongodb mongodb    50 Jun 23 07:44 WiredTiger
-rw-------. 1 mongodb mongodb  4096 Jun 24 07:27 WiredTigerHS.wt
-rw-------. 1 mongodb mongodb    21 Jun 23 07:44 WiredTiger.lock
-rw-------. 1 mongodb mongodb  1472 Jun 24 08:02 WiredTiger.turtle
-rw-------. 1 mongodb mongodb 77824 Jun 24 08:02 WiredTiger.wt

*/

-- Step 125 -->> On Node 1 (Configure ReplicaSets)
mongodb@mongodbtest-pri:/datastore/mongodb$ ll | grep keyfile
/*
-r--------. 1 mongodb mongodb  1024 Jun 24 08:01 keyfile
*/

-- Step 126 -->> On Node 1 (Copy the KeyFile from Primary to Secondary Node)
mongodb@mongodbtest-pri:/datastore/mongodb$ scp -r keyfile mongodb@mongodbtest-sec:/datastore/mongodb
/*
TThe authenticity of host 'mongodbtest-sec (192.168.120.71)' can't be established.
ED25519 key fingerprint is SHA256:XNR7nWEbZFHy7mMW8jp+ZcW2wVMoJNlJxQMpvn32GL4.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'mongodbtest-sec' (ED25519) to the list of known hosts.
mongodb@mongodbtest-sec's password:
keyfile     100% 1024   341.6KB/s   00:00
*/

-- Step 127 -->> On Node 1 (Copy the KeyFile from Primary to Arbiter  Node)
mongodb@mongodbtest-pri:/datastore/mongodb$ scp -r keyfile mongodb@mongotest-arb:/datastore/mongodb
/*
The authenticity of host 'mongotest-arb (192.168.120.72)' can't be established.
ED25519 key fingerprint is SHA256:XNR7nWEbZFHy7mMW8jp+ZcW2wVMoJNlJxQMpvn32GL4.
This host key is known by the following other names/addresses:
    ~/.ssh/known_hosts:1: [hashed name]
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'mongotest-arb' (ED25519) to the list of known hosts.
mongodb@mongotest-arb's password:
keyfile                                       100% 1024   575.7KB/s   00:00

*/

-- Step 128 -->> On Node 2 (Verify the KeyFile on Secondary Node)
mongodb@mongodbtest-sec:~$ cd /datastore/mongodb/

-- Step 129 -->> On Node 2 (Verify the KeyFile on Secondary Node)
mongodb@mongodbtest-sec:/datastore/mongodb$ ll | grep keyfile
/*
-r--------. 1 mongodb mongodb  1024 Mar 12 07:53 keyfile
*/

-- Step 130 -->> On Node 3 (Verify the KeyFile on Arbiter Node)
mongodb@mongotest-arb:~$ cd /datastore/mongodb/

-- Step 131 -->> On Node 3 (Verify the KeyFile on Arbiter Node)
mongodb@mongotest-arb:/datastore/mongodb$ ll | grep keyfile
/*
-r--------. 1 mongodb mongodb  1024 Mar 12 07:55 keyfile
*/

-- Step 132 -->> On All Nodes (Add the KeyFile on Each Nodes)
mongodb@mongodbtest-pri/mongodbtest-sec/mongotest-arb:/datastore/mongodb$ sudo vi /etc/mongod.conf
/*
#security:
security:
  authorization: enabled
  keyFile: /datastore/mongodb/keyfile
*/

-- Step 133 -->> On All Nodes (Restart the MongoDB on Each Nodes)
mongodb@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~$ sudo systemctl restart mongod

-- Step 134 -->> On All Nodes (Verify the MongoDB Status on Each Nodes)
mongodb@mongodbtest-pri/mongodbtest-sec/mongotest-arb:~$ sudo systemctl status mongod
/*
● mongod.service - MongoDB Database Server
     Loaded: loaded (/lib/systemd/system/mongod.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2024-06-24 08:11:30 +0545; 27s ago
       Docs: https://docs.mongodb.org/manual
   Main PID: 2845 (mongod)
     Memory: 175.4M
        CPU: 964ms
     CGroup: /system.slice/mongod.service
             └─2845 /usr/bin/mongod --config /etc/mongod.conf

Jun 24 08:11:30 mongodbtest-pri.com.np systemd[1]: Started MongoDB Database Server.
Jun 24 08:11:30 mongodbtest-pri.com.np mongod[2845]: {"t":{"$date":"2024-06-24T02:26:30.196Z"},"s":"I",  "c":"CONTROL",  "id":7484500, "ctx":"main","msg>

*/

-- Step 135 -->> On Node 1 (Configure the Primary Node for Secondary Replica Sets)
mongodb@mongodbtest-pri:~$ mongosh --host 192.168.120.70  --port 27017 -u admin -p P#ssw0rd --authenticationDatabase admin
/*
Current Mongosh Log ID: 6678d9f1044203e1e5597192
Connecting to:          mongodb://<credentials>@192.168.120.70:27017/?directConnection=true&authSource=admin&appName=mongosh+2.2.9
Using MongoDB:          7.0.11
Using Mongosh:          2.2.9

For mongosh info see: https://docs.mongodb.com/mongodb-shell/


test> db.version()
7.0.11

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
              { _id: 0, host : "mongodbtest-pri:27017" }
           ]
        }
     )
{ ok: 1 }

rs0 [direct: other] admin> rs.add("mongodbtest-sec:27017");
{
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1719237766, i: 1 }),
    signature: {
      hash: Binary.createFromBase64('NEQAYv3Qq1s7Q/VOEyroA/CFt7k=', 0),
      keyId: Long('7384069845874114566')
    }
  },
  operationTime: Timestamp({ t: 1719237766, i: 1 })
}


rs0 [direct: primary] admin> quit()
*/

-- Step 136 -->> On Node 1 (Verify the Primary Node)
mongodb@mongodbtest-pri:~$ mongosh --host 192.168.120.70  --port 27017 -u admin -p P#ssw0rd --authenticationDatabase admin
/*
Current Mongosh Log ID: 66797cc5ec0a5f6309597192
Connecting to:          mongodb://<credentials>@192.168.120.70:27017/?directConnection=true&authSource=admin&appName=mongosh+2.2.9
Using MongoDB:          7.0.11
Using Mongosh:          2.2.9

For mongosh info see: https://docs.mongodb.com/mongodb-shell/

rs0 [direct: primary] test> show dbs
admin   172.00 KiB
config  188.00 KiB
local   452.00 KiB

rs0 [direct: primary] test> use admin
switched to db admin

rs0 [direct: primary] admin> db.version()
7.0.11

rs0 [direct: primary] admin> rs.status()
{
  set: 'rs0',
  date: ISODate('2024-06-24T14:05:10.259Z'),
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
    lastCommittedOpTime: { ts: Timestamp({ t: 1719237905, i: 1 }), t: Long('1') },
    lastCommittedWallTime: ISODate('2024-06-24T14:05:05.130Z'),
    readConcernMajorityOpTime: { ts: Timestamp({ t: 1719237905, i: 1 }), t: Long('1') },
    appliedOpTime: { ts: Timestamp({ t: 1719237905, i: 1 }), t: Long('1') },
    durableOpTime: { ts: Timestamp({ t: 1719237905, i: 1 }), t: Long('1') },
    lastAppliedWallTime: ISODate('2024-06-24T14:05:05.130Z'),
    lastDurableWallTime: ISODate('2024-06-24T14:05:05.130Z')
  },
  lastStableRecoveryTimestamp: Timestamp({ t: 1719237845, i: 1 }),
  electionCandidateMetrics: {
    lastElectionReason: 'electionTimeout',
    lastElectionDate: ISODate('2024-06-24T14:02:15.093Z'),
    electionTerm: Long('1'),
    lastCommittedOpTimeAtElection: { ts: Timestamp({ t: 1719237735, i: 1 }), t: Long('-1') },
    lastSeenOpTimeAtElection: { ts: Timestamp({ t: 1719237735, i: 1 }), t: Long('-1') },
    numVotesNeeded: 1,
    priorityAtElection: 1,
    electionTimeoutMillis: Long('10000'),
    newTermStartDate: ISODate('2024-06-24T14:02:15.110Z'),
    wMajorityWriteAvailabilityDate: ISODate('2024-06-24T14:02:15.121Z')
  },
  members: [
    {
      _id: 0,
      name: 'mongodbtest-pri:27017',
      health: 1,
      state: 1,
      stateStr: 'PRIMARY',
      uptime: 558,
      optime: { ts: Timestamp({ t: 1719237905, i: 1 }), t: Long('1') },
      optimeDate: ISODate('2024-06-24T14:05:05.000Z'),
      lastAppliedWallTime: ISODate('2024-06-24T14:05:05.130Z'),
      lastDurableWallTime: ISODate('2024-06-24T14:05:05.130Z'),
      syncSourceHost: '',
      syncSourceId: -1,
      infoMessage: '',
      electionTime: Timestamp({ t: 1719237735, i: 2 }),
      electionDate: ISODate('2024-06-24T14:02:15.000Z'),
      configVersion: 3,
      configTerm: 1,
      self: true,
      lastHeartbeatMessage: ''
    },
    {
      _id: 1,
      name: 'mongodbtest-sec:27017',
      health: 1,
      state: 2,
      stateStr: 'SECONDARY',
      uptime: 144,
      optime: { ts: Timestamp({ t: 1719237905, i: 1 }), t: Long('1') },
      optimeDurable: { ts: Timestamp({ t: 1719237905, i: 1 }), t: Long('1') },
      optimeDate: ISODate('2024-06-24T14:05:05.000Z'),
      optimeDurableDate: ISODate('2024-06-24T14:05:05.000Z'),
      lastAppliedWallTime: ISODate('2024-06-24T14:05:05.130Z'),
      lastDurableWallTime: ISODate('2024-06-24T14:05:05.130Z'),
      lastHeartbeat: ISODate('2024-06-24T14:05:10.248Z'),
      lastHeartbeatRecv: ISODate('2024-06-24T14:05:08.734Z'),
      pingMs: Long('0'),
      lastHeartbeatMessage: '',
      syncSourceHost: 'mongodbtest-pri:27017',
      syncSourceId: 0,
      infoMessage: '',
      configVersion: 3,
      configTerm: 1
    }
  ],
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1719237905, i: 1 }),
    signature: {
      hash: Binary.createFromBase64('iuIqN0RpzY0EaPJ4oRkg1/y0Log=', 0),
      keyId: Long('7384069845874114566')
    }
  },
  operationTime: Timestamp({ t: 1719237905, i: 1 })
}


rs0 [direct: primary] admin> quit()
*/

-- Step 137 -->> On Node 1 (Configure the Primary Node for Arbiter)
mongodb@mongodbtest-pri:~$ mongosh --host 192.168.120.70  --port 27017 -u admin -p P#ssw0rd --authenticationDatabase admin
/*
Current Mongosh Log ID: 66797dcad13d8be48e597192
Connecting to:          mongodb://<credentials>@192.168.120.70:27017/?directConnection=true&authSource=admin&appName=mongosh+2.2.9
Using MongoDB:          7.0.11
Using Mongosh:          2.2.9

For mongosh info see: https://docs.mongodb.com/mongodb-shell/


rs0 [direct: primary] test> db.version()
7.0.11

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
    clusterTime: Timestamp({ t: 1719238165, i: 1 }),
    signature: {
      hash: Binary.createFromBase64('Ey0biFOwpVcWQ24UbF6B/mDLA74=', 0),
      keyId: Long('7384069845874114566')
    }
  },
  operationTime: Timestamp({ t: 1719238165, i: 1 })
}


rs0 [direct: primary] admin> rs.addArb("mongotest-arb:27017");

MongoServerError[NewReplicaSetConfigurationIncompatible]: Reconfig attempted to install a config that would change the implicit default write concern. Use the setDefaultRWConcern command to set a cluster-wide write concern and try the reconfig again.


-- To fix the above issue (MongoServerError: Reconfig attempted to install a config that would change the implicit default write concern. Use the setDefaultRWConcern command to set a cluster-wide write concern and try the reconfig again.)

rs0 [direct: primary] admin> db.adminCommand({
... setDefaultRWConcern: 1,
... defaultWriteConcern: { w: 1 }
... })
{
  defaultReadConcern: { level: 'local' },
  defaultWriteConcern: { w: 1, wtimeout: 0 },
  updateOpTime: Timestamp({ t: 1719238865, i: 1 }),
  updateWallClockTime: ISODate('2024-06-24T14:21:08.440Z'),
  defaultWriteConcernSource: 'global',
  defaultReadConcernSource: 'implicit',
  localUpdateWallClockTime: ISODate('2024-06-24T14:21:08.445Z'),
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1719238868, i: 2 }),
    signature: {
      hash: Binary.createFromBase64('toE6ctaGWOknVJ7jcifIIVbb3kI=', 0),
      keyId: Long('7384069845874114566')
    }
  },
  operationTime: Timestamp({ t: 1719238868, i: 2 })
}


rs0 [direct: primary] admin> rs.addArb("mongotest-arb:27017");
{
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1719239015, i: 2 }),
    signature: {
      hash: Binary.createFromBase64('CgqaG5Xynyu0Mpvy+m5SGpTT4Gg=', 0),
      keyId: Long('7384069845874114566')
    }
  },
  operationTime: Timestamp({ t: 1719239015, i: 2 })
}

rs0 [direct: primary] admin>  rs.status()
{
  set: 'rs0',
  date: ISODate('2024-06-24T14:24:10.819Z'),
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
    lastCommittedOpTime: { ts: Timestamp({ t: 1719239045, i: 1 }), t: Long('1') },
    lastCommittedWallTime: ISODate('2024-06-24T14:24:05.198Z'),
    readConcernMajorityOpTime: { ts: Timestamp({ t: 1719239045, i: 1 }), t: Long('1') },
    appliedOpTime: { ts: Timestamp({ t: 1719239045, i: 1 }), t: Long('1') },
    durableOpTime: { ts: Timestamp({ t: 1719239045, i: 1 }), t: Long('1') },
    lastAppliedWallTime: ISODate('2024-06-24T14:24:05.198Z'),
    lastDurableWallTime: ISODate('2024-06-24T14:24:05.198Z')
  },
  lastStableRecoveryTimestamp: Timestamp({ t: 1719238985, i: 1 }),
  electionCandidateMetrics: {
    lastElectionReason: 'electionTimeout',
    lastElectionDate: ISODate('2024-06-24T14:02:15.093Z'),
    electionTerm: Long('1'),
    lastCommittedOpTimeAtElection: { ts: Timestamp({ t: 1719237735, i: 1 }), t: Long('-1') },
    lastSeenOpTimeAtElection: { ts: Timestamp({ t: 1719237735, i: 1 }), t: Long('-1') },
    numVotesNeeded: 1,
    priorityAtElection: 1,
    electionTimeoutMillis: Long('10000'),
    newTermStartDate: ISODate('2024-06-24T14:02:15.110Z'),
    wMajorityWriteAvailabilityDate: ISODate('2024-06-24T14:02:15.121Z')
  },
  members: [
    {
      _id: 0,
      name: 'mongodbtest-pri:27017',
      health: 1,
      state: 1,
      stateStr: 'PRIMARY',
      uptime: 1698,
      optime: { ts: Timestamp({ t: 1719239045, i: 1 }), t: Long('1') },
      optimeDate: ISODate('2024-06-24T14:24:05.000Z'),
      lastAppliedWallTime: ISODate('2024-06-24T14:24:05.198Z'),
      lastDurableWallTime: ISODate('2024-06-24T14:24:05.198Z'),
      syncSourceHost: '',
      syncSourceId: -1,
      infoMessage: '',
      electionTime: Timestamp({ t: 1719237735, i: 2 }),
      electionDate: ISODate('2024-06-24T14:02:15.000Z'),
      configVersion: 4,
      configTerm: 1,
      self: true,
      lastHeartbeatMessage: ''
    },
    {
      _id: 1,
      name: 'mongodbtest-sec:27017',
      health: 1,
      state: 2,
      stateStr: 'SECONDARY',
      uptime: 1284,
      optime: { ts: Timestamp({ t: 1719239045, i: 1 }), t: Long('1') },
      optimeDurable: { ts: Timestamp({ t: 1719239045, i: 1 }), t: Long('1') },
      optimeDate: ISODate('2024-06-24T14:24:05.000Z'),
      optimeDurableDate: ISODate('2024-06-24T14:24:05.000Z'),
      lastAppliedWallTime: ISODate('2024-06-24T14:24:05.198Z'),
      lastDurableWallTime: ISODate('2024-06-24T14:24:05.198Z'),
      lastHeartbeat: ISODate('2024-06-24T14:24:09.244Z'),
      lastHeartbeatRecv: ISODate('2024-06-24T14:24:09.244Z'),
      pingMs: Long('0'),
      lastHeartbeatMessage: '',
      syncSourceHost: 'mongodbtest-pri:27017',
      syncSourceId: 0,
      infoMessage: '',
      configVersion: 4,
      configTerm: 1
    },
    {
      _id: 2,
      name: 'mongotest-arb:27017',
      health: 1,
      state: 7,
      stateStr: 'ARBITER',
      uptime: 35,
      lastHeartbeat: ISODate('2024-06-24T14:24:09.275Z'),
      lastHeartbeatRecv: ISODate('2024-06-24T14:24:09.289Z'),
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
    clusterTime: Timestamp({ t: 1719239045, i: 1 }),
    signature: {
      hash: Binary.createFromBase64('Xn8nh9/xrH95QC5tDrKLoXD7HHI=', 0),
      keyId: Long('7384069845874114566')
    }
  },
  operationTime: Timestamp({ t: 1719239045, i: 1 })
}


rs0 [direct: primary] admin> quit()
*/

-- Step 138 -->> On Node 1 (Verify the Primary Node And Make the Primary Node High Priority)
mongodb@mongodbtest-pri:~$ mongosh --host 192.168.120.70  --port 27017 -u admin -p P#ssw0rd --authenticationDatabase admin
/*
Current Mongosh Log ID: 66798228135a2fe802597192
Connecting to:          mongodb://<credentials>@192.168.120.70:27017/?directConnection=true&authSource=admin&appName=mongosh+2.2.9
Using MongoDB:          7.0.11
Using Mongosh:          2.2.9

For mongosh info see: https://docs.mongodb.com/mongodb-shell/


rs0 [direct: primary] test> show databases
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
      host: 'mongodbtest-pri:27017',
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
      host: 'mongodbtest-sec:27017',
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
      host: 'mongotest-arb:27017',
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

rs0 [direct: primary] admin> rs.isMaster()
{
  topologyVersion: {
    processId: ObjectId('66797ae89c4daa8cd22bf615'),
    counter: Long('9')
  },
  hosts: [ 'mongodbtest-pri:27017', 'mongodbtest-sec:27017' ],
  arbiters: [ 'mongotest-arb:27017' ],
  setName: 'rs0',
  setVersion: 4,
  ismaster: true,
  secondary: false,
  primary: 'mongodbtest-pri:27017',
  me: 'mongodbtest-pri:27017',
  electionId: ObjectId('7fffffff0000000000000001'),
  lastWrite: {
    opTime: { ts: Timestamp({ t: 1719239335, i: 1 }), t: Long('1') },
    lastWriteDate: ISODate('2024-06-24T14:28:55.000Z'),
    majorityOpTime: { ts: Timestamp({ t: 1719239335, i: 1 }), t: Long('1') },
    majorityWriteDate: ISODate('2024-06-24T14:28:55.000Z')
  },
  maxBsonObjectSize: 16777216,
  maxMessageSizeBytes: 48000000,
  maxWriteBatchSize: 100000,
  localTime: ISODate('2024-06-24T14:29:04.854Z'),
  logicalSessionTimeoutMinutes: 30,
  connectionId: 45,
  minWireVersion: 0,
  maxWireVersion: 21,
  readOnly: false,
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1719239335, i: 1 }),
    signature: {
      hash: Binary.createFromBase64('xNfAqivd48FtMpsh+BYwQxj5EJk=', 0),
      keyId: Long('7384069845874114566')
    }
  },
  operationTime: Timestamp({ t: 1719239335, i: 1 }),
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
      host: 'mongodbtest-pri:27017',
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
      host: 'mongodbtest-sec:27017',
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
      host: 'mongotest-arb:27017',
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

-- Step B - To make it High Primary Always (By chaging the priority => 10)

rs0 [direct: primary] admin> cfg.members[0].priority = 10
10

rs0 [direct: primary] admin> rs.reconfig(cfg)
{
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1719239646, i: 1 }),
    signature: {
      hash: Binary.createFromBase64('WVH20tiAaWU2FTqgkNdBUKS0OYs=', 0),
      keyId: Long('7384069845874114566')
    }
  },
  operationTime: Timestamp({ t: 1719239646, i: 1 })
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
      host: 'mongodbtest-pri:27017',
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
      host: 'mongodbtest-sec:27017',
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
      host: 'mongotest-arb:27017',
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


rs0 [direct: primary] admin> rs.isMaster()
{
  topologyVersion: {
    processId: ObjectId('66797ae89c4daa8cd22bf615'),
    counter: Long('10')
  },
  hosts: [ 'mongodbtest-pri:27017', 'mongodbtest-sec:27017' ],
  arbiters: [ 'mongotest-arb:27017' ],
  setName: 'rs0',
  setVersion: 5,
  ismaster: true,
  secondary: false,
  primary: 'mongodbtest-pri:27017',
  me: 'mongodbtest-pri:27017',
  electionId: ObjectId('7fffffff0000000000000001'),
  lastWrite: {
    opTime: { ts: Timestamp({ t: 1719239825, i: 1 }), t: Long('1') },
    lastWriteDate: ISODate('2024-06-24T14:37:05.000Z'),
    majorityOpTime: { ts: Timestamp({ t: 1719239825, i: 1 }), t: Long('1') },
    majorityWriteDate: ISODate('2024-06-24T14:37:05.000Z')
  },
  maxBsonObjectSize: 16777216,
  maxMessageSizeBytes: 48000000,
  maxWriteBatchSize: 100000,
  localTime: ISODate('2024-06-24T14:37:06.009Z'),
  logicalSessionTimeoutMinutes: 30,
  connectionId: 45,
  minWireVersion: 0,
  maxWireVersion: 21,
  readOnly: false,
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1719239825, i: 1 }),
    signature: {
      hash: Binary.createFromBase64('unirEn6U5MHJ9Nd7E5kCh+q2PZs=', 0),
      keyId: Long('7384069845874114566')
    }
  },
  operationTime: Timestamp({ t: 1719239825, i: 1 }),
  isWritablePrimary: true
}


rs0 [direct: primary] admin> quit()
*/

-- Step 139 -->> On Node 2 (Verify the Secondary Node)
mongodb@mongodbtest-sec:~$ mongosh --host 192.168.120.71 --port 27017 -u admin -p P#ssw0rd --authenticationDatabase admin
/*
Current Mongosh Log ID: 667984d409620d380a597192
Connecting to:          mongodb://<credentials>@192.168.120.71:27017/?directConnection=true&authSource=admin&appName=mongosh+2.2.9
Using MongoDB:          7.0.11
Using Mongosh:          2.2.9

For mongosh info see: https://docs.mongodb.com/mongodb-shell/



To help improve our products, anonymous usage data is collected and sent to MongoDB periodically (https://www.mongodb.com/legal/privacy-policy).
You can opt-out by running the disableTelemetry() command.

rs0 [direct: secondary] test> show dbs
admin   140.00 KiB
config  316.00 KiB
local   460.00 KiB

rs0 [direct: secondary] test> use admin
switched to db admin

rs0 [direct: secondary] admin> db
admin

rs0 [direct: secondary] admin> rs.isMaster()
{
  topologyVersion: {
    processId: ObjectId('66797b4353d47c25b759a523'),
    counter: Long('6')
  },
  hosts: [ 'mongodbtest-pri:27017', 'mongodbtest-sec:27017' ],
  arbiters: [ 'mongotest-arb:27017' ],
  setName: 'rs0',
  setVersion: 5,
  ismaster: false,
  secondary: true,
  primary: 'mongodbtest-pri:27017',
  me: 'mongodbtest-sec:27017',
  lastWrite: {
    opTime: { ts: Timestamp({ t: 1719239955, i: 1 }), t: Long('1') },
    lastWriteDate: ISODate('2024-06-24T14:39:15.000Z'),
    majorityOpTime: { ts: Timestamp({ t: 1719239955, i: 1 }), t: Long('1') },
    majorityWriteDate: ISODate('2024-06-24T14:39:15.000Z')
  },
  maxBsonObjectSize: 16777216,
  maxMessageSizeBytes: 48000000,
  maxWriteBatchSize: 100000,
  localTime: ISODate('2024-06-24T14:39:18.399Z'),
  logicalSessionTimeoutMinutes: 30,
  connectionId: 23,
  minWireVersion: 0,
  maxWireVersion: 21,
  readOnly: false,
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1719239955, i: 1 }),
    signature: {
      hash: Binary.createFromBase64('gZTcdqDLDjEX5jwUbJJFGat8vgc=', 0),
      keyId: Long('7384069845874114566')
    }
  },
  operationTime: Timestamp({ t: 1719239955, i: 1 }),
  isWritablePrimary: false
}

rs0 [direct: secondary] admin> rs.status()
{
  set: 'rs0',
  date: ISODate('2024-06-24T14:40:01.899Z'),
  myState: 2,
  term: Long('1'),
  syncSourceHost: 'mongodbtest-pri:27017',
  syncSourceId: 0,
  heartbeatIntervalMillis: Long('2000'),
  majorityVoteCount: 2,
  writeMajorityCount: 2,
  votingMembersCount: 3,
  writableVotingMembersCount: 2,
  optimes: {
    lastCommittedOpTime: { ts: Timestamp({ t: 1719239995, i: 1 }), t: Long('1') },
    lastCommittedWallTime: ISODate('2024-06-24T14:39:55.248Z'),
    readConcernMajorityOpTime: { ts: Timestamp({ t: 1719239995, i: 1 }), t: Long('1') },
    appliedOpTime: { ts: Timestamp({ t: 1719239995, i: 1 }), t: Long('1') },
    durableOpTime: { ts: Timestamp({ t: 1719239995, i: 1 }), t: Long('1') },
    lastAppliedWallTime: ISODate('2024-06-24T14:39:55.248Z'),
    lastDurableWallTime: ISODate('2024-06-24T14:39:55.248Z')
  },
  lastStableRecoveryTimestamp: Timestamp({ t: 1719239985, i: 1 }),
  members: [
    {
      _id: 0,
      name: 'mongodbtest-pri:27017',
      health: 1,
      state: 1,
      stateStr: 'PRIMARY',
      uptime: 2235,
      optime: { ts: Timestamp({ t: 1719239995, i: 1 }), t: Long('1') },
      optimeDurable: { ts: Timestamp({ t: 1719239995, i: 1 }), t: Long('1') },
      optimeDate: ISODate('2024-06-24T14:39:55.000Z'),
      optimeDurableDate: ISODate('2024-06-24T14:39:55.000Z'),
      lastAppliedWallTime: ISODate('2024-06-24T14:39:55.248Z'),
      lastDurableWallTime: ISODate('2024-06-24T14:39:55.248Z'),
      lastHeartbeat: ISODate('2024-06-24T14:40:01.231Z'),
      lastHeartbeatRecv: ISODate('2024-06-24T14:40:01.231Z'),
      pingMs: Long('0'),
      lastHeartbeatMessage: '',
      syncSourceHost: '',
      syncSourceId: -1,
      infoMessage: '',
      electionTime: Timestamp({ t: 1719237735, i: 2 }),
      electionDate: ISODate('2024-06-24T14:02:15.000Z'),
      configVersion: 5,
      configTerm: 1
    },
    {
      _id: 1,
      name: 'mongodbtest-sec:27017',
      health: 1,
      state: 2,
      stateStr: 'SECONDARY',
      uptime: 2559,
      optime: { ts: Timestamp({ t: 1719239995, i: 1 }), t: Long('1') },
      optimeDate: ISODate('2024-06-24T14:39:55.000Z'),
      lastAppliedWallTime: ISODate('2024-06-24T14:39:55.248Z'),
      lastDurableWallTime: ISODate('2024-06-24T14:39:55.248Z'),
      syncSourceHost: 'mongodbtest-pri:27017',
      syncSourceId: 0,
      infoMessage: '',
      configVersion: 5,
      configTerm: 1,
      self: true,
      lastHeartbeatMessage: ''
    },
    {
      _id: 2,
      name: 'mongotest-arb:27017',
      health: 1,
      state: 7,
      stateStr: 'ARBITER',
      uptime: 986,
      lastHeartbeat: ISODate('2024-06-24T14:40:01.231Z'),
      lastHeartbeatRecv: ISODate('2024-06-24T14:40:01.229Z'),
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
    clusterTime: Timestamp({ t: 1719239995, i: 1 }),
    signature: {
      hash: Binary.createFromBase64('h/btkA6RtUCqfbbTKJIJ2i1nkHY=', 0),
      keyId: Long('7384069845874114566')
    }
  },
  operationTime: Timestamp({ t: 1719239995, i: 1 })
}

rs0 [direct: secondary] admin> rs.conf()
{
  _id: 'rs0',
  version: 5,
  term: 1,
  members: [
    {
      _id: 0,
      host: 'mongodbtest-pri:27017',
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
      host: 'mongodbtest-sec:27017',
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
      host: 'mongotest-arb:27017',
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


rs0 [direct: secondary] admin> quit()
*/

-- Step 140 -->> On Node 3 (Verify the Arbiter Node)
mongodb@mongotest-arb:~$ mongo --host 192.168.120.72 --port 27017 -u admin -p P#ssw0rd --authenticationDatabase admin
/*
Current Mongosh Log ID: 667985b43fe363f795597192
Connecting to:          mongodb://<credentials>@192.168.120.72:27017/?directConnection=true&authSource=admin&appName=mongosh+2.2.9
Using MongoDB:          7.0.11
Using Mongosh:          2.2.9

For mongosh info see: https://docs.mongodb.com/mongodb-shell/



To help improve our products, anonymous usage data is collected and sent to MongoDB periodically (https://www.mongodb.com/legal/privacy-policy).
You can opt-out by running the disableTelemetry() command.

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
    processId: ObjectId('66797ae135733213af6f79c7'),
    counter: Long('2')
  },
  hosts: [ 'mongodbtest-pri:27017', 'mongodbtest-sec:27017' ],
  arbiters: [ 'mongotest-arb:27017' ],
  setName: 'rs0',
  setVersion: 5,
  ismaster: false,
  secondary: false,
  primary: 'mongodbtest-pri:27017',
  arbiterOnly: true,
  me: 'mongotest-arb:27017',
  lastWrite: {
    opTime: { ts: Timestamp({ t: 1719240205, i: 1 }), t: Long('1') },
    lastWriteDate: ISODate('2024-06-24T14:43:25.000Z'),
    majorityOpTime: { ts: Timestamp({ t: 1719240205, i: 1 }), t: Long('1') },
    majorityWriteDate: ISODate('2024-06-24T14:43:25.000Z')
  },
  maxBsonObjectSize: 16777216,
  maxMessageSizeBytes: 48000000,
  maxWriteBatchSize: 100000,
  localTime: ISODate('2024-06-24T14:43:26.161Z'),
  logicalSessionTimeoutMinutes: 30,
  connectionId: 14,
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

-- Step 141 -->> On Node 1 (Verify the Primary and Secondary Replication)
mongodb@mongodbtest-pri:~$ mongosh --host 192.168.120.70  --port 27017 -u admin -p P#ssw0rd --authenticationDatabase admin
/*
Current Mongosh Log ID: 667986582e84edd84e597192
Connecting to:          mongodb://<credentials>@192.168.120.70:27017/?directConnection=true&authSource=admin&appName=mongosh+2.2.9
Using MongoDB:          7.0.11
Using Mongosh:          2.2.9

For mongosh info see: https://docs.mongodb.com/mongodb-shell/


rs0 [direct: primary] test> show dbs
admin   172.00 KiB
config  252.00 KiB
local   460.00 KiB


rs0 [direct: primary] test> use admin
switched to db admin

rs0 [direct: primary] admin> db
admin

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
    clusterTime: Timestamp({ t: 1719240335, i: 1 }),
    signature: {
      hash: Binary.createFromBase64('eszgoNflzts0cLnL8yi6fiyCgPg=', 0),
      keyId: Long('7384069845874114566')
    }
  },
  operationTime: Timestamp({ t: 1719240335, i: 1 })
}


rs0 [direct: primary] admin> use rabin
switched to db rabin

rs0 [direct: primary] rabin>db
rabin

rs0 [direct: primary] rabin> db.createUser(
   {
   user:"rabin",
   pwd:"rabin123",
   roles:["readWrite"]
   }
   )
{
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1719240506, i: 1 }),
    signature: {
      hash: Binary.createFromBase64('CX4ImmTymj+dIUhv0SajxZ2EyiA=', 0),
      keyId: Long('7384069845874114566')
    }
  },
  operationTime: Timestamp({ t: 1719240506, i: 1 })
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

-- Step 142 -->> On Node 1 (Verify the Primary and Secondary Replication)
mongodb@mongodbtest-pri:~$ mongo --host 192.168.120.70  --port 27017 -u rabin -p rabin123 --authenticationDatabase rabin
/*
Current Mongosh Log ID: 667987d1fa9638abaa597192
Connecting to:          mongodb://<credentials>@192.168.120.70:27017/?directConnection=true&authSource=rabin&appName=mongosh+2.2.9
Using MongoDB:          7.0.11
Using Mongosh:          2.2.9

For mongosh info see: https://docs.mongodb.com/mongodb-shell/


rs0 [direct: primary] test> show dbs
rabin  8.00 KiB

rs0 [direct: primary] test> use rabin
switched to db rabin

rs0 [direct: primary] rabin> db.getCollectionNames()
[ 'tbl_cib' ]

rs0 [direct: primary] rabin> quit()
*/

-- Step 143 -->> On Node 2 (Verify the Primary and Secondary Replication)
mongodb@mongodbtest-sec:~$ mongo --host 192.168.120.71  --port 27017 -u rabin -p rabin123 --authenticationDatabase rabin
/*
Current Mongosh Log ID: 667988110e0de5cffb597192
Connecting to:          mongodb://<credentials>@192.168.120.71:27017/?directConnection=true&authSource=rabin&appName=mongosh+2.2.9
Using MongoDB:          7.0.11
Using Mongosh:          2.2.9

For mongosh info see: https://docs.mongodb.com/mongodb-shell/


rs0 [direct: secondary] test> show dbs
rabin  8.00 KiB

rs0 [direct: secondary] test> use rabin
switched to db rabin

rs0 [direct: secondary] rabin> db
rabin

rs0 [direct: secondary] rabin> show collections
tbl_cib

rs0 [direct: secondary] rabin> db.getCollectionNames()
[ 'tbl_cib' ]

rs0 [direct: secondary] rabin> quit()
*/


-- Failed Over Test
-- Step 144 -->> On Node 1 (Stop the MongoDB Serivice at Primary Node i.e. Node 1)
mongodb@mongodbtest-pri:~$ sudo systemctl stop mongod.service

-- Step 145 -->> On Node 1 (Verify the MongoDB Serivice at Primary Node i.e. Node 1)
mongodb@mongodbtest-pri:~$ sudo systemctl status mongod.service
/*
○ mongod.service - MongoDB Database Server
     Loaded: loaded (/lib/systemd/system/mongod.service; enabled; vendor preset: enabled)
     Active: inactive (dead) since Mon 2024-06-24 21:42:39 +0545; 1min 2s ago
       Docs: https://docs.mongodb.org/manual
    Process: 1430 ExecStart=/usr/bin/mongod --config /etc/mongod.conf (code=exited, status=0/SUCCESS)
   Main PID: 1430 (code=exited, status=0/SUCCESS)
        CPU: 1min 6.468s

Jun 24 19:40:51 mongodbtest-pri.com.np systemd[1]: Started MongoDB Database Server.
Jun 24 19:40:52 mongodbtest-pri.com.np mongod[1430]: {"t":{"$date":"2024-06-24T13:55:52.347Z"},"s":"I",  "c":"CONTROL",  "id":7484500, "ctx":"main","msg>
Jun 24 21:42:24 mongodbtest-pri.com.np systemd[1]: Stopping MongoDB Database Server...
Jun 24 21:42:39 mongodbtest-pri.com.np systemd[1]: mongod.service: Deactivated successfully.
Jun 24 21:42:39 mongodbtest-pri.com.np systemd[1]: Stopped MongoDB Database Server.
Jun 24 21:42:39 mongodbtest-pri.com.np systemd[1]: mongod.service: Consumed 1min 6.468s CPU time.

*/
.
-- Step 146 -->> On Node 2 (Verify the MongoDB Serivice at Secondary Node i.e. Node 2)
mongodb@mongodbtest-sec:~$ sudo systemctl status mongod.service
/*
● mongod.service - MongoDB Database Server
     Loaded: loaded (/lib/systemd/system/mongod.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2024-06-24 19:42:22 +0545; 2h 2min ago
       Docs: https://docs.mongodb.org/manual
   Main PID: 1429 (mongod)
     Memory: 288.8M
        CPU: 1min 11.558s
     CGroup: /system.slice/mongod.service
             └─1429 /usr/bin/mongod --config /etc/mongod.conf

Jun 24 19:42:22 mongodbtest-sec.com.np systemd[1]: Started MongoDB Database Server.
Jun 24 19:42:23 mongodbtest-sec.com.np mongod[1429]: {"t":{"$date":"2024-06-24T13:57:23.011Z"},"s":"I",  "c":"CONTROL",  "id":7484500, "ctx":"main","msg>
*/

-- Step 147 -->> On Node 2 (Verify the MongoDB Serivice at Secondary Node i.e. Node 2)
mongodb@mongodbtest-sec:~$ mongosh --host 192.168.120.71 --port 27017 -u admin -p P#ssw0rd --authenticationDatabase admin
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
  hosts: [ 'mongodbtest-pri:27017', 'mongodbtest-sec:27017' ],
  arbiters: [ 'mongotest-arb:27017' ],
  setName: 'rs0',
  setVersion: 5,
  ismaster: true,
  secondary: false,
  primary: 'mongodbtest-sec:27017',
  me: 'mongodbtest-sec:27017',
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
      name: 'mongodbtest-pri:27017',
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
      lastHeartbeatMessage: 'Error connecting to mongodbtest-pri:27017 (192.168.120.70:27017) :: caused by :: onInvoke :: caused by :: Connection refused',
      syncSourceHost: '',
      syncSourceId: -1,
      infoMessage: '',
      configVersion: 5,
      configTerm: 4
    },
    {
      _id: 1,
      name: 'mongodbtest-sec:27017',
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
      name: 'mongotest-arb:27017',
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
      host: 'mongodbtest-pri:27017',
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
      host: 'mongodbtest-sec:27017',
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
      host: 'mongotest-arb:27017',
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

-- Step 148 -->> On Node 2 (Stop the MongoDB Serivice at Secondary Node i.e. Node 2)
mongodb@mongodbtest-sec:~$ sudo systemctl stop mongod.service

-- Step 149 -->> On Node 2 (Verify the MongoDB Serivice at Secondary Node i.e. Node 2)
mongodb@mongodbtest-sec:~$ sudo systemctl status mongod.service
/*
○ mongod.service - MongoDB Database Server
     Loaded: loaded (/lib/systemd/system/mongod.service; enabled; vendor preset: enabled)
     Active: inactive (dead) since Mon 2024-06-24 21:54:48 +0545; 15s ago
       Docs: https://docs.mongodb.org/manual
    Process: 1429 ExecStart=/usr/bin/mongod --config /etc/mongod.conf (code=exited, status=0/SUCCESS)
   Main PID: 1429 (code=exited, status=0/SUCCESS)
        CPU: 1min 22.288s

Jun 24 19:42:22 mongodbtest-sec.com.np systemd[1]: Started MongoDB Database Server.
Jun 24 19:42:23 mongodbtest-sec.com.np mongod[1429]: {"t":{"$date":"2024-06-24T13:57:23.011Z"},"s":"I",  "c":"CONTROL",  "id":7484500, "ctx":"main","msg>
Jun 24 21:54:32 mongodbtest-sec.com.np systemd[1]: Stopping MongoDB Database Server...
Jun 24 21:54:48 mongodbtest-sec.com.np systemd[1]: mongod.service: Deactivated successfully.
Jun 24 21:54:48 mongodbtest-sec.com.np systemd[1]: Stopped MongoDB Database Server.
Jun 24 21:54:48 mongodbtest-sec.com.np systemd[1]: mongod.service: Consumed 1min 22.288s CPU time.

*/

-- Step 150 -->> On Node 3 (Verify the MongoDB Serivice at Arbiter Node i.e. Node 3)
mongodb@mongotest-arb:~$ mongo --host 192.168.120.72 --port 27017 -u admin -p P#ssw0rd --authenticationDatabase admin
/*
Current Mongosh Log ID: 66799a8e655d5702b6597192
Connecting to:          mongodb://<credentials>@192.168.120.72:27017/?directConnection=true&authSource=admin&appName=mongosh+2.2.9
Using MongoDB:          7.0.11
Using Mongosh:          2.2.9

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
    processId: ObjectId('66797ae135733213af6f79c7'),
    counter: Long('4')
  },
  hosts: [ 'mongodbtest-pri:27017', 'mongodbtest-sec:27017' ],
  arbiters: [ 'mongotest-arb:27017' ],
  setName: 'rs0',
  setVersion: 5,
  ismaster: false,
  secondary: false,
  arbiterOnly: true,
  me: 'mongotest-arb:27017',
  lastWrite: {
    opTime: { ts: Timestamp({ t: 1719244654, i: 2 }), t: Long('4') },
    lastWriteDate: ISODate('2024-06-24T15:57:34.000Z'),
    majorityOpTime: { ts: Timestamp({ t: 1719244654, i: 2 }), t: Long('4') },
    majorityWriteDate: ISODate('2024-06-24T15:57:34.000Z')
  },
  maxBsonObjectSize: 16777216,
  maxMessageSizeBytes: 48000000,
  maxWriteBatchSize: 100000,
  localTime: ISODate('2024-06-24T16:11:44.371Z'),
  logicalSessionTimeoutMinutes: 30,
  connectionId: 58,
  minWireVersion: 0,
  maxWireVersion: 21,
  readOnly: false,
  ok: 1,
  isWritablePrimary: false
}

rs0 [direct: arbiter] admin> quit()
*/

-- Step 151 -->> On Node 1 (Start the MongoDB Serivice at Primary Node i.e. Node 1)
mongodb@mongodbtest-pri:~$ sudo systemctl start mongod.service

-- Step 152 -->> On Node 1 (Verify the MongoDB Serivice at Primary Node i.e. Node 1)
mongodb@mongodbtest-pri:~$ sudo systemctl status mongod.service
/*
● mongod.service - MongoDB Database Server
     Loaded: loaded (/lib/systemd/system/mongod.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2024-06-24 21:58:40 +0545; 42s ago
       Docs: https://docs.mongodb.org/manual
   Main PID: 2738 (mongod)
     Memory: 187.1M
        CPU: 1.385s
     CGroup: /system.slice/mongod.service
             └─2738 /usr/bin/mongod --config /etc/mongod.conf

Jun 24 21:58:40 mongodbtest-pri.com.np systemd[1]: Started MongoDB Database Server.
Jun 24 21:58:40 mongodbtest-pri.com.np mongod[2738]: {"t":{"$date":"2024-06-24T16:13:40.489Z"},"s":"I",  "c":"CONTROL",  "id":7484500, "ctx":"main","msg>
*/

-- Step 153 -->> On Node 1 (Verify the MongoDB Serivice at Primary Node i.e. Node 1)
mongodb@mongodbtest-pri:~$ mongosh --host 192.168.120.70  --port 27017 -u admin -p P#ssw0rd --authenticationDatabase admin
/*
Current Mongosh Log ID: 66799b8659063f2051597192
Connecting to:          mongodb://<credentials>@192.168.120.70:27017/?directConnection=true&authSource=admin&appName=mongosh+2.2.9
Using MongoDB:          7.0.11
Using Mongosh:          2.2.9

For mongosh info see: https://docs.mongodb.com/mongodb-shell/


rs0 [direct: primary] test> show dbs
admin   220.00 KiB
config  252.00 KiB
local   468.00 KiB
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
    clusterTime: Timestamp({ t: 1719245742, i: 1 }),
    signature: {
      hash: Binary.createFromBase64('5FQ+v7gkSd5DO63elwdJGD9nDsg=', 0),
      keyId: Long('7384069845874114566')
    }
  },
  operationTime: Timestamp({ t: 1719245742, i: 1 })
}


rs0 [direct: primary] admin> rs.isMaster()
{
  topologyVersion: {
    processId: ObjectId('66799b34e2d7c22909481648'),
    counter: Long('6')
  },
  hosts: [ 'mongodbtest-pri:27017', 'mongodbtest-sec:27017' ],
  arbiters: [ 'mongotest-arb:27017' ],
  setName: 'rs0',
  setVersion: 5,
  ismaster: true,
  secondary: false,
  primary: 'mongodbtest-pri:27017',
  me: 'mongodbtest-pri:27017',
  electionId: ObjectId('7fffffff0000000000000005'),
  lastWrite: {
    opTime: { ts: Timestamp({ t: 1719245772, i: 1 }), t: Long('5') },
    lastWriteDate: ISODate('2024-06-24T16:16:12.000Z'),
    majorityOpTime: { ts: Timestamp({ t: 1719244654, i: 2 }), t: Long('4') },
    majorityWriteDate: ISODate('2024-06-24T15:57:34.000Z')
  },
  maxBsonObjectSize: 16777216,
  maxMessageSizeBytes: 48000000,
  maxWriteBatchSize: 100000,
  localTime: ISODate('2024-06-24T16:16:17.865Z'),
  logicalSessionTimeoutMinutes: 30,
  connectionId: 11,
  minWireVersion: 0,
  maxWireVersion: 21,
  readOnly: false,
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1719245772, i: 1 }),
    signature: {
      hash: Binary.createFromBase64('2rz4CNKV0jbBezJWWLmKYhxXLaQ=', 0),
      keyId: Long('7384069845874114566')
    }
  },
  operationTime: Timestamp({ t: 1719245772, i: 1 }),
  isWritablePrimary: true
}

rs0 [direct: primary] admin> rs.conf()
{
  topologyVersion: {
    processId: ObjectId('66799b34e2d7c22909481648'),
    counter: Long('6')
  },
  hosts: [ 'mongodbtest-pri:27017', 'mongodbtest-sec:27017' ],
  arbiters: [ 'mongotest-arb:27017' ],
  setName: 'rs0',
  setVersion: 5,
  ismaster: true,
  secondary: false,
  primary: 'mongodbtest-pri:27017',
  me: 'mongodbtest-pri:27017',
  electionId: ObjectId('7fffffff0000000000000005'),
  lastWrite: {
    opTime: { ts: Timestamp({ t: 1719245772, i: 1 }), t: Long('5') },
    lastWriteDate: ISODate('2024-06-24T16:16:12.000Z'),
    majorityOpTime: { ts: Timestamp({ t: 1719244654, i: 2 }), t: Long('4') },
    majorityWriteDate: ISODate('2024-06-24T15:57:34.000Z')
  },
  maxBsonObjectSize: 16777216,
  maxMessageSizeBytes: 48000000,
  maxWriteBatchSize: 100000,
  localTime: ISODate('2024-06-24T16:16:17.865Z'),
  logicalSessionTimeoutMinutes: 30,
  connectionId: 11,
  minWireVersion: 0,
  maxWireVersion: 21,
  readOnly: false,
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1719245772, i: 1 }),
    signature: {
      hash: Binary.createFromBase64('2rz4CNKV0jbBezJWWLmKYhxXLaQ=', 0),
      keyId: Long('7384069845874114566')
    }
  },
  operationTime: Timestamp({ t: 1719245772, i: 1 }),
  isWritablePrimary: true
}
rs0 [direct: primary] admin> rs.conf()
{
  _id: 'rs0',
  version: 5,
  term: 5,
  members: [
    {
      _id: 0,
      host: 'mongodbtest-pri:27017',
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
      host: 'mongodbtest-sec:27017',
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
      host: 'mongotest-arb:27017',
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

rs0 [direct: primary] admin> rs.status()
{
  set: 'rs0',
  date: ISODate('2024-06-24T16:17:35.871Z'),
  myState: 1,
  term: Long('5'),
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
    appliedOpTime: { ts: Timestamp({ t: 1719245852, i: 1 }), t: Long('5') },
    durableOpTime: { ts: Timestamp({ t: 1719245852, i: 1 }), t: Long('5') },
    lastAppliedWallTime: ISODate('2024-06-24T16:17:32.434Z'),
    lastDurableWallTime: ISODate('2024-06-24T16:17:32.434Z')
  },
  lastStableRecoveryTimestamp: Timestamp({ t: 1719244654, i: 2 }),
  electionCandidateMetrics: {
    lastElectionReason: 'electionTimeout',
    lastElectionDate: ISODate('2024-06-24T16:13:52.408Z'),
    electionTerm: Long('5'),
    lastCommittedOpTimeAtElection: { ts: Timestamp({ t: 1719244654, i: 2 }), t: Long('4') },
    lastSeenOpTimeAtElection: { ts: Timestamp({ t: 1719244654, i: 2 }), t: Long('4') },
    numVotesNeeded: 2,
    priorityAtElection: 10,
    electionTimeoutMillis: Long('10000'),
    numCatchUpOps: Long('0'),
    newTermStartDate: ISODate('2024-06-24T16:13:52.420Z')
  },
  members: [
    {
      _id: 0,
      name: 'mongodbtest-pri:27017',
      health: 1,
      state: 1,
      stateStr: 'PRIMARY',
      uptime: 235,
      optime: { ts: Timestamp({ t: 1719245852, i: 1 }), t: Long('5') },
      optimeDate: ISODate('2024-06-24T16:17:32.000Z'),
      lastAppliedWallTime: ISODate('2024-06-24T16:17:32.434Z'),
      lastDurableWallTime: ISODate('2024-06-24T16:17:32.434Z'),
      syncSourceHost: '',
      syncSourceId: -1,
      infoMessage: '',
      electionTime: Timestamp({ t: 1719245632, i: 1 }),
      electionDate: ISODate('2024-06-24T16:13:52.000Z'),
      configVersion: 5,
      configTerm: 5,
      self: true,
      lastHeartbeatMessage: ''
    },
    {
      _id: 1,
      name: 'mongodbtest-sec:27017',
      health: 0,
      state: 8,
      stateStr: '(not reachable/healthy)',
      uptime: 0,
      optime: { ts: Timestamp({ t: 0, i: 0 }), t: Long('-1') },
      optimeDurable: { ts: Timestamp({ t: 0, i: 0 }), t: Long('-1') },
      optimeDate: ISODate('1970-01-01T00:00:00.000Z'),
      optimeDurableDate: ISODate('1970-01-01T00:00:00.000Z'),
      lastAppliedWallTime: ISODate('1970-01-01T00:00:00.000Z'),
      lastDurableWallTime: ISODate('1970-01-01T00:00:00.000Z'),
      lastHeartbeat: ISODate('2024-06-24T16:17:34.915Z'),
      lastHeartbeatRecv: ISODate('1970-01-01T00:00:00.000Z'),
      pingMs: Long('0'),
      lastHeartbeatMessage: 'Error connecting to mongodbtest-sec:27017 (192.168.120.71:27017) :: caused by :: onInvoke :: caused by :: Connection refused',
      syncSourceHost: '',
      syncSourceId: -1,
      infoMessage: '',
      configVersion: -1,
      configTerm: -1
    },
    {
      _id: 2,
      name: 'mongotest-arb:27017',
      health: 1,
      state: 7,
      stateStr: 'ARBITER',
      uptime: 234,
      lastHeartbeat: ISODate('2024-06-24T16:17:34.626Z'),
      lastHeartbeatRecv: ISODate('2024-06-24T16:17:34.625Z'),
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
    clusterTime: Timestamp({ t: 1719245852, i: 1 }),
    signature: {
      hash: Binary.createFromBase64('ntOLJMAKpdnlwzEbXTRFUtGCMYs=', 0),
      keyId: Long('7384069845874114566')
    }
  },
  operationTime: Timestamp({ t: 1719245852, i: 1 })
}


rs0 [direct: primary] admin> quit()

*/

-- Step 154 -->> On Node 2 (Start the MongoDB Serivice at Secondary Node i.e. Node 2)
mongodb@mongodbtest-sec:~$ sudo systemctl start mongod.service

-- Step 155 -->> On Node 2 (Verify the MongoDB Serivice at Secondary Node i.e. Node 2)
mongodb@mongodbtest-sec:~$ sudo systemctl status mongod.service
/*
● mongod.service - MongoDB Database Server
     Loaded: loaded (/lib/systemd/system/mongod.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2024-06-24 22:04:18 +0545; 43s ago
       Docs: https://docs.mongodb.org/manual
   Main PID: 2564 (mongod)
     Memory: 188.1M
        CPU: 1.252s
     CGroup: /system.slice/mongod.service
             └─2564 /usr/bin/mongod --config /etc/mongod.conf

Jun 24 22:04:18 mongodbtest-sec.com.np systemd[1]: Started MongoDB Database Server.
Jun 24 22:04:18 mongodbtest-sec.com.np mongod[2564]: {"t":{"$date":"2024-06-24T16:19:18.041Z"},"s":"I",  "c":"CONTROL",  "id":7484500, "ctx":"main","msg>
*/

-- Step 156 -->> On Node 2 (Verify the MongoDB Serivice at Secondary Node i.e. Node 2)
mongodb@mongodbtest-sec:~$ mongosh --host 192.168.120.71 --port 27017 -u admin -p P#ssw0rd --authenticationDatabase admin
/*
Current Mongosh Log ID: 66799cd8309bd81ee1597192
Connecting to:          mongodb://<credentials>@192.168.120.71:27017/?directConnection=true&authSource=admin&appName=mongosh+2.2.9
Using MongoDB:          7.0.11
Using Mongosh:          2.2.9

For mongosh info see: https://docs.mongodb.com/mongodb-shell/


rs0 [direct: secondary] test> show dbs
admin   224.00 KiB
config  340.00 KiB
local   528.00 KiB
rabin     8.00 KiB


rs0 [direct: secondary] test> use admin
switched to db admin

rs0 [direct: secondary] admin> db.getUsers()
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
    clusterTime: Timestamp({ t: 1719246112, i: 1 }),
    signature: {
      hash: Binary.createFromBase64('E8HeAgnCSuk85X88+lNYhorN5/0=', 0),
      keyId: Long('7384069845874114566')
    }
  },
  operationTime: Timestamp({ t: 1719246112, i: 1 })
}


rs0 [direct: secondary] admin> rs.conf()
{
  _id: 'rs0',
  version: 5,
  term: 5,
  members: [
    {
      _id: 0,
      host: 'mongodbtest-pri:27017',
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
      host: 'mongodbtest-sec:27017',
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
      host: 'mongotest-arb:27017',
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


rs0 [direct: secondary] admin> rs.status()
{
  set: 'rs0',
  date: ISODate('2024-06-24T16:27:30.006Z'),
  myState: 2,
  term: Long('5'),
  syncSourceHost: 'mongodbtest-pri:27017',
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
      name: 'mongodbtest-pri:27017',
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
      name: 'mongodbtest-sec:27017',
      health: 1,
      state: 2,
      stateStr: 'SECONDARY',
      uptime: 492,
      optime: { ts: Timestamp({ t: 1719246442, i: 1 }), t: Long('5') },
      optimeDate: ISODate('2024-06-24T16:27:22.000Z'),
      lastAppliedWallTime: ISODate('2024-06-24T16:27:22.467Z'),
      lastDurableWallTime: ISODate('2024-06-24T16:27:22.467Z'),
      syncSourceHost: 'mongodbtest-pri:27017',
      syncSourceId: 0,
      infoMessage: '',
      configVersion: 5,
      configTerm: 5,
      self: true,
      lastHeartbeatMessage: ''
    },
    {
      _id: 2,
      name: 'mongotest-arb:27017',
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
  hosts: [ 'mongodbtest-pri:27017', 'mongodbtest-sec:27017' ],
  arbiters: [ 'mongotest-arb:27017' ],
  setName: 'rs0',
  setVersion: 5,
  ismaster: false,
  secondary: true,
  primary: 'mongodbtest-pri:27017',
  me: 'mongodbtest-sec:27017',
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

-- Step 157 -->> On Node 3 (Verify the MongoDB Serivice at Arbiter Node i.e. Node 3)
mongodb@mongotest-arb:~$ mongo --host 192.168.120.72 --port 27017 -u admin -p P#ssw0rd --authenticationDatabase admin
/*
Current Mongosh Log ID: 66799f2583b3bc875c597192
Connecting to:          mongodb://<credentials>@192.168.120.72:27017/?directConnection=true&authSource=admin&appName=mongosh+2.2.9
Using MongoDB:          7.0.11
Using Mongosh:          2.2.9

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
    processId: ObjectId('66797ae135733213af6f79c7'),
    counter: Long('5')
  },
  hosts: [ 'mongodbtest-pri:27017', 'mongodbtest-sec:27017' ],
  arbiters: [ 'mongotest-arb:27017' ],
  setName: 'rs0',
  setVersion: 5,
  ismaster: false,
  secondary: false,
  primary: 'mongodbtest-pri:27017',
  arbiterOnly: true,
  me: 'mongotest-arb:27017',
  lastWrite: {
    opTime: { ts: Timestamp({ t: 1719246652, i: 1 }), t: Long('5') },
    lastWriteDate: ISODate('2024-06-24T16:30:52.000Z'),
    majorityOpTime: { ts: Timestamp({ t: 1719246652, i: 1 }), t: Long('5') },
    majorityWriteDate: ISODate('2024-06-24T16:30:52.000Z')
  },
  maxBsonObjectSize: 16777216,
  maxMessageSizeBytes: 48000000,
  maxWriteBatchSize: 100000,
  localTime: ISODate('2024-06-24T16:31:00.141Z'),
  logicalSessionTimeoutMinutes: 30,
  connectionId: 75,
  minWireVersion: 0,
  maxWireVersion: 21,
  readOnly: false,
  ok: 1,
  isWritablePrimary: false
}


rs0 [direct: arbiter] admin> quit()
*/

-- Data verification
-- Step 158 -->> On Node 1 (Verify the DB SIze of MongoDB at Primary Node)
mongodb@mongodbtest-pri:~$ du -sh /datastore/mongodb/
/*
306M    /datastore/mongodb/
*/

-- Step 159 -->> On Node 1 (Verify the Files Count (Of DbPath) of MongoDB at Primary Node)
mongodb@mongodbtest-pri:~$ ls /datastore/mongodb/ -1 | wc -l
/*
69
*/

-- Step 160 -->> On Node 2 (Verify the DB SIze of MongoDB at Secondary Node)
mongodb@mongodbtest-sec:~$ du -sh /datastore/mongodb/
/*
305M    /datastore/mongodb/
*/

-- Step 161 -->> On Node 2 (Verify the Files Count (Of DbPath) of MongoDB at Secondary Node)
mongodb@mongodbtest-sec:~$ ls /datastore/mongodb/ -1 | wc -l
/*
69
*/

-- Step 162 -->> On Node 3 (Verify the DB SIze of MongoDB at Arbiter Node)
mongodb@mongotest-arb:~$ du -sh /datastore/mongodb/
/*
305M    /datastore/mongodb/
*/

-- Step 163 -->> On Node 3 (Verify the Files Count (Of DbPath) of MongoDB at Arbiter Node)
mongodb@mongotest-arb:~$ ls /datastore/mongodb/ -1 | wc -l
/*
31
*/

-- Step 164 -->> On Node 1 (Verify the Files List (Of DbPath) of MongoDB at Primary Node)
mongodb@mongodbtest-pri:~$ ll /datastore/mongodb/
/*
drwxrwxrwx. 4 mongodb mongodb   4096 Jun 24 22:20 ./
drwxrwxrwx. 4 mongodb mongodb     32 Jun 23 07:01 ../
-rw-------. 1 mongodb mongodb  36864 Jun 24 21:58 collection-0--1213528133744675262.wt
-rw-------. 1 mongodb mongodb  36864 Jun 24 22:20 collection-0--1840931887661656212.wt
-rw-------. 1 mongodb mongodb  61440 Jun 24 22:20 collection-0--3055468222181016051.wt
-rw-------. 1 mongodb mongodb  36864 Jun 24 22:00 collection-0-6731314958581996372.wt
-rw-------. 1 mongodb mongodb   4096 Jun 24 21:42 collection-10--3055468222181016051.wt
-rw-------. 1 mongodb mongodb   4096 Jun 24 21:59 collection-12--3055468222181016051.wt
-rw-------. 1 mongodb mongodb  36864 Jun 24 21:59 collection-1--3055468222181016051.wt
-rw-------. 1 mongodb mongodb  20480 Jun 24 21:58 collection-13--3055468222181016051.wt
-rw-------. 1 mongodb mongodb   4096 Jun 24 21:42 collection-14--3055468222181016051.wt
-rw-------. 1 mongodb mongodb   4096 Jun 24 21:58 collection-16--3055468222181016051.wt
-rw-------. 1 mongodb mongodb   4096 Jun 24 21:58 collection-17--3055468222181016051.wt
-rw-------. 1 mongodb mongodb  36864 Jun 24 21:59 collection-2--1213528133744675262.wt
-rw-------. 1 mongodb mongodb  20480 Jun 24 21:58 collection-2--1840931887661656212.wt
-rw-------. 1 mongodb mongodb   4096 Jun 24 21:42 collection-22--3055468222181016051.wt
-rw-------. 1 mongodb mongodb   4096 Jun 24 21:58 collection-26--3055468222181016051.wt
-rw-------. 1 mongodb mongodb   4096 Jun 24 21:42 collection-29--3055468222181016051.wt
-rw-------. 1 mongodb mongodb  20480 Jun 24 21:58 collection-3--3055468222181016051.wt
-rw-------. 1 mongodb mongodb  20480 Jun 24 21:58 collection-33--3055468222181016051.wt
-rw-------. 1 mongodb mongodb   4096 Jun 24 21:42 collection-35--3055468222181016051.wt
-rw-------. 1 mongodb mongodb  36864 Jun 24 22:19 collection-4--1213528133744675262.wt
-rw-------. 1 mongodb mongodb  36864 Jun 24 21:59 collection-4--1840931887661656212.wt
-rw-------. 1 mongodb mongodb   4096 Jun 24 21:58 collection-5--3055468222181016051.wt
-rw-------. 1 mongodb mongodb  36864 Jun 24 21:58 collection-6--1840931887661656212.wt
-rw-------. 1 mongodb mongodb  20480 Jun 24 21:58 collection-8--1840931887661656212.wt
-rw-------. 1 mongodb mongodb   4096 Jun 24 21:42 collection-8--3055468222181016051.wt
drwx------. 2 mongodb mongodb   4096 Jun 24 22:21 diagnostic.data/
-rw-------. 1 mongodb mongodb  36864 Jun 24 21:58 index-1--1213528133744675262.wt
-rw-------. 1 mongodb mongodb   4096 Jun 24 21:42 index-11--3055468222181016051.wt
-rw-------. 1 mongodb mongodb  20480 Jun 24 21:58 index-1--1840931887661656212.wt
-rw-------. 1 mongodb mongodb  20480 Jun 24 21:42 index-15--3055468222181016051.wt
-rw-------. 1 mongodb mongodb  36864 Jun 24 21:42 index-1-6731314958581996372.wt
-rw-------. 1 mongodb mongodb   4096 Jun 24 21:42 index-18--3055468222181016051.wt
-rw-------. 1 mongodb mongodb   4096 Jun 24 21:42 index-19--3055468222181016051.wt
-rw-------. 1 mongodb mongodb   4096 Jun 24 21:42 index-20--3055468222181016051.wt
-rw-------. 1 mongodb mongodb   4096 Jun 24 21:59 index-21--3055468222181016051.wt
-rw-------. 1 mongodb mongodb  20480 Jun 24 21:42 index-2--3055468222181016051.wt
-rw-------. 1 mongodb mongodb   4096 Jun 24 21:59 index-23--3055468222181016051.wt
-rw-------. 1 mongodb mongodb   4096 Jun 24 21:59 index-24--3055468222181016051.wt
-rw-------. 1 mongodb mongodb   4096 Jun 24 21:42 index-25--3055468222181016051.wt
-rw-------. 1 mongodb mongodb  36864 Jun 24 22:00 index-2-6731314958581996372.wt
-rw-------. 1 mongodb mongodb   4096 Jun 24 21:59 index-27--3055468222181016051.wt
-rw-------. 1 mongodb mongodb   4096 Jun 24 21:42 index-28--3055468222181016051.wt
-rw-------. 1 mongodb mongodb   4096 Jun 24 21:59 index-30--3055468222181016051.wt
-rw-------. 1 mongodb mongodb  36864 Jun 24 21:59 index-3--1213528133744675262.wt
-rw-------. 1 mongodb mongodb   4096 Jun 24 21:42 index-31--3055468222181016051.wt
-rw-------. 1 mongodb mongodb  20480 Jun 24 08:12 index-3--1840931887661656212.wt
-rw-------. 1 mongodb mongodb   4096 Jun 24 21:59 index-32--3055468222181016051.wt
-rw-------. 1 mongodb mongodb  20480 Jun 24 21:58 index-34--3055468222181016051.wt
-rw-------. 1 mongodb mongodb   4096 Jun 24 21:42 index-36--3055468222181016051.wt
-rw-------. 1 mongodb mongodb  20480 Jun 24 21:42 index-4--3055468222181016051.wt
-rw-------. 1 mongodb mongodb  36864 Jun 24 22:19 index-5--1213528133744675262.wt
-rw-------. 1 mongodb mongodb  20480 Jun 24 08:12 index-5--1840931887661656212.wt
-rw-------. 1 mongodb mongodb  36864 Jun 24 22:19 index-6--1213528133744675262.wt
-rw-------. 1 mongodb mongodb   4096 Jun 24 22:03 index-6--3055468222181016051.wt
-rw-------. 1 mongodb mongodb  20480 Jun 24 21:58 index-7--1840931887661656212.wt
-rw-------. 1 mongodb mongodb   4096 Jun 24 21:42 index-7--3055468222181016051.wt
-rw-------. 1 mongodb mongodb  20480 Jun 24 08:12 index-9--1840931887661656212.wt
-rw-------. 1 mongodb mongodb   4096 Jun 24 21:42 index-9--3055468222181016051.wt
drwx------. 2 mongodb mongodb    110 Jun 24 21:58 journal/
-r--------. 1 mongodb mongodb   1024 Jun 24 08:01 keyfile
-rw-------. 1 mongodb mongodb  36864 Jun 24 21:58 _mdb_catalog.wt
-rw-------. 1 mongodb mongodb      5 Jun 24 21:58 mongod.lock
-rw-------. 1 mongodb mongodb  36864 Jun 24 22:20 sizeStorer.wt
-rw-------. 1 mongodb mongodb    114 Jun 23 07:44 storage.bson
-rw-------. 1 mongodb mongodb     50 Jun 23 07:44 WiredTiger
-rw-------. 1 mongodb mongodb  32768 Jun 24 21:58 WiredTigerHS.wt
-rw-------. 1 mongodb mongodb     21 Jun 23 07:44 WiredTiger.lock
-rw-------. 1 mongodb mongodb   1481 Jun 24 22:20 WiredTiger.turtle
-rw-------. 1 mongodb mongodb 212992 Jun 24 22:20 WiredTiger.wt

*/

-- Step 165 -->> On Node 2 (Verify the Files List (Of DbPath) of MongoDB at Secondary Node)
mongodb@mongodbtest-sec:~$ ll /datastore/mongodb/
/*
drwxrwxrwx. 4 mongodb mongodb   4096 Jun 24 22:21 ./
drwxrwxrwx. 4 mongodb mongodb     32 Jun 23 07:02 ../
-rw-------. 1 mongodb mongodb  36864 Jun 24 22:21 collection-0--5425107588182834318.wt
-rw-------. 1 mongodb mongodb  36864 Jun 24 22:04 collection-0--911281890866462865.wt
-rw-------. 1 mongodb mongodb  36864 Jun 24 22:19 collection-12--911281890866462865.wt
-rw-------. 1 mongodb mongodb   4096 Jun 24 22:04 collection-15--911281890866462865.wt
-rw-------. 1 mongodb mongodb   4096 Jun 24 22:04 collection-18--911281890866462865.wt
-rw-------. 1 mongodb mongodb   4096 Jun 24 22:04 collection-21--911281890866462865.wt
-rw-------. 1 mongodb mongodb   4096 Jun 24 22:04 collection-23--911281890866462865.wt
-rw-------. 1 mongodb mongodb   4096 Jun 24 22:04 collection-24--911281890866462865.wt
-rw-------. 1 mongodb mongodb  32768 Jun 24 22:04 collection-2--5425107588182834318.wt
-rw-------. 1 mongodb mongodb   4096 Jun 24 22:04 collection-27--911281890866462865.wt
-rw-------. 1 mongodb mongodb  36864 Jun 24 22:04 collection-2-8278632379925315181.wt
-rw-------. 1 mongodb mongodb   4096 Jun 24 22:04 collection-30--911281890866462865.wt
-rw-------. 1 mongodb mongodb   4096 Jun 24 22:04 collection-33--911281890866462865.wt
-rw-------. 1 mongodb mongodb   4096 Jun 24 22:04 collection-35--911281890866462865.wt
-rw-------. 1 mongodb mongodb   4096 Jun 24 22:04 collection-38--911281890866462865.wt
-rw-------. 1 mongodb mongodb  32768 Jun 24 22:04 collection-41--911281890866462865.wt
-rw-------. 1 mongodb mongodb  32768 Jun 24 22:04 collection-43--911281890866462865.wt
-rw-------. 1 mongodb mongodb  36864 Jun 24 22:04 collection-4--5425107588182834318.wt
-rw-------. 1 mongodb mongodb   4096 Jun 24 22:04 collection-45--911281890866462865.wt
-rw-------. 1 mongodb mongodb  61440 Jun 24 22:21 collection-4--911281890866462865.wt
-rw-------. 1 mongodb mongodb  32768 Jun 24 22:04 collection-5--911281890866462865.wt
-rw-------. 1 mongodb mongodb  36864 Jun 24 22:04 collection-6--5425107588182834318.wt
-rw-------. 1 mongodb mongodb  32768 Jun 24 22:04 collection-7--911281890866462865.wt
-rw-------. 1 mongodb mongodb  32768 Jun 24 22:04 collection-8--5425107588182834318.wt
-rw-------. 1 mongodb mongodb  36864 Jun 24 22:04 collection-9--911281890866462865.wt
drwx------. 2 mongodb mongodb   4096 Jun 24 22:21 diagnostic.data/
-rw-------. 1 mongodb mongodb  36864 Jun 24 22:05 index-10--911281890866462865.wt
-rw-------. 1 mongodb mongodb  36864 Jun 24 21:54 index-11--911281890866462865.wt
-rw-------. 1 mongodb mongodb  36864 Jun 24 22:19 index-13--911281890866462865.wt
-rw-------. 1 mongodb mongodb  36864 Jun 24 22:19 index-14--911281890866462865.wt
-rw-------. 1 mongodb mongodb  32768 Jun 24 22:04 index-1--5425107588182834318.wt
-rw-------. 1 mongodb mongodb   8192 Jun 24 21:54 index-16--911281890866462865.wt
-rw-------. 1 mongodb mongodb   8192 Jun 24 19:47 index-17--911281890866462865.wt
-rw-------. 1 mongodb mongodb  20480 Jun 24 21:54 index-1--911281890866462865.wt
-rw-------. 1 mongodb mongodb   8192 Jun 24 21:54 index-19--911281890866462865.wt
-rw-------. 1 mongodb mongodb   8192 Jun 24 19:47 index-20--911281890866462865.wt
-rw-------. 1 mongodb mongodb   8192 Jun 24 19:47 index-22--911281890866462865.wt
-rw-------. 1 mongodb mongodb   8192 Jun 24 21:54 index-25--911281890866462865.wt
-rw-------. 1 mongodb mongodb   8192 Jun 24 19:47 index-26--911281890866462865.wt
-rw-------. 1 mongodb mongodb   8192 Jun 24 19:47 index-28--911281890866462865.wt
-rw-------. 1 mongodb mongodb   8192 Jun 24 21:54 index-29--911281890866462865.wt
-rw-------. 1 mongodb mongodb   8192 Jun 24 21:54 index-31--911281890866462865.wt
-rw-------. 1 mongodb mongodb   8192 Jun 24 19:47 index-32--911281890866462865.wt
-rw-------. 1 mongodb mongodb   8192 Jun 24 19:47 index-34--911281890866462865.wt
-rw-------. 1 mongodb mongodb  20480 Jun 24 08:12 index-3--5425107588182834318.wt
-rw-------. 1 mongodb mongodb   8192 Jun 24 21:54 index-36--911281890866462865.wt
-rw-------. 1 mongodb mongodb   8192 Jun 24 19:47 index-37--911281890866462865.wt
-rw-------. 1 mongodb mongodb  36864 Jun 24 22:04 index-3-8278632379925315181.wt
-rw-------. 1 mongodb mongodb   8192 Jun 24 21:54 index-39--911281890866462865.wt
-rw-------. 1 mongodb mongodb   8192 Jun 24 19:47 index-40--911281890866462865.wt
-rw-------. 1 mongodb mongodb  20480 Jun 24 21:54 index-42--911281890866462865.wt
-rw-------. 1 mongodb mongodb  32768 Jun 24 22:04 index-44--911281890866462865.wt
-rw-------. 1 mongodb mongodb   4096 Jun 24 21:54 index-46--911281890866462865.wt
-rw-------. 1 mongodb mongodb  20480 Jun 24 08:12 index-5--5425107588182834318.wt
-rw-------. 1 mongodb mongodb  20480 Jun 24 19:47 index-6--911281890866462865.wt
-rw-------. 1 mongodb mongodb  32768 Jun 24 22:04 index-7--5425107588182834318.wt
-rw-------. 1 mongodb mongodb  32768 Jun 24 22:04 index-8--911281890866462865.wt
-rw-------. 1 mongodb mongodb  20480 Jun 24 08:12 index-9--5425107588182834318.wt
drwx------. 2 mongodb mongodb    110 Jun 24 22:04 journal/
-r--------. 1 mongodb mongodb   1024 Jun 24 08:04 keyfile
-rw-------. 1 mongodb mongodb  36864 Jun 24 22:04 _mdb_catalog.wt
-rw-------. 1 mongodb mongodb      5 Jun 24 22:04 mongod.lock
-rw-------. 1 mongodb mongodb  36864 Jun 24 22:21 sizeStorer.wt
-rw-------. 1 mongodb mongodb    114 Jun 23 07:44 storage.bson
-rw-------. 1 mongodb mongodb     50 Jun 23 07:44 WiredTiger
-rw-------. 1 mongodb mongodb  28672 Jun 24 22:05 WiredTigerHS.wt
-rw-------. 1 mongodb mongodb     21 Jun 23 07:44 WiredTiger.lock
-rw-------. 1 mongodb mongodb   1482 Jun 24 22:21 WiredTiger.turtle
-rw-------. 1 mongodb mongodb 266240 Jun 24 22:21 WiredTiger.wt
*/

-- Step 166 -->> On Node 3 (Verify the Files List (Of DbPath) of MongoDB at Arbiter Node)
mongodb@mongotest-arb:~$ ll /datastore/mongodb/
/*
drwxrwxrwx. 4 mongodb mongodb   4096 Jun 24 22:21 ./
drwxrwxrwx. 4 mongodb mongodb     32 Jun 23 07:03 ../
-rw-------. 1 mongodb mongodb   4096 Jun 24 19:40 collection-0-3263784471935427837.wt
-rw-------. 1 mongodb mongodb  36864 Jun 24 21:59 collection-0--6485879775583778478.wt
-rw-------. 1 mongodb mongodb  20480 Jun 24 19:40 collection-0--6738075785414951509.wt
-rw-------. 1 mongodb mongodb  20480 Jun 24 19:40 collection-2-3263784471935427837.wt
-rw-------. 1 mongodb mongodb  36864 Jun 24 19:41 collection-2--6738075785414951509.wt
-rw-------. 1 mongodb mongodb  36864 Jun 24 21:59 collection-4-3263784471935427837.wt
-rw-------. 1 mongodb mongodb  24576 Jun 24 07:41 collection-4--6738075785414951509.wt
-rw-------. 1 mongodb mongodb  36864 Jun 24 19:41 collection-6-3263784471935427837.wt
-rw-------. 1 mongodb mongodb  20480 Jun 24 19:40 collection-8-3263784471935427837.wt
drwx------. 2 mongodb mongodb   4096 Jun 24 22:22 diagnostic.data/
-rw-------. 1 mongodb mongodb   4096 Jun 24 08:11 index-1-3263784471935427837.wt
-rw-------. 1 mongodb mongodb  20480 Jun 24 20:08 index-1--6485879775583778478.wt
-rw-------. 1 mongodb mongodb  20480 Jun 24 19:40 index-1--6738075785414951509.wt
-rw-------. 1 mongodb mongodb  20480 Jun 24 08:12 index-3-3263784471935427837.wt
-rw-------. 1 mongodb mongodb  36864 Jun 24 19:41 index-3--6738075785414951509.wt
-rw-------. 1 mongodb mongodb  20480 Jun 24 08:12 index-5-3263784471935427837.wt
-rw-------. 1 mongodb mongodb  24576 Jun 24 07:41 index-5--6738075785414951509.wt
-rw-------. 1 mongodb mongodb  24576 Jun 24 08:11 index-6--6738075785414951509.wt
-rw-------. 1 mongodb mongodb  20480 Jun 24 19:40 index-7-3263784471935427837.wt
-rw-------. 1 mongodb mongodb  20480 Jun 24 08:12 index-9-3263784471935427837.wt
drwx------. 2 mongodb mongodb    110 Jun 24 19:41 journal/
-r--------. 1 mongodb mongodb   1024 Jun 24 08:05 keyfile
-rw-------. 1 mongodb mongodb  36864 Jun 24 20:08 _mdb_catalog.wt
-rw-------. 1 mongodb mongodb      5 Jun 24 19:40 mongod.lock
-rw-------. 1 mongodb mongodb  36864 Jun 24 20:09 sizeStorer.wt
-rw-------. 1 mongodb mongodb    114 Jun 23 07:44 storage.bson
-rw-------. 1 mongodb mongodb     50 Jun 23 07:44 WiredTiger
-rw-------. 1 mongodb mongodb   4096 Jun 24 19:40 WiredTigerHS.wt
-rw-------. 1 mongodb mongodb     21 Jun 23 07:44 WiredTiger.lock
-rw-------. 1 mongodb mongodb   1478 Jun 24 22:21 WiredTiger.turtle
-rw-------. 1 mongodb mongodb 114688 Jun 24 22:21 WiredTiger.wt
*/
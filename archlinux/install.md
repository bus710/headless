# Archlinux installation

<br/><br/>

## Reference

- https://wiki.archlinux.org/index.php/Main_page
- https://wiki.archlinux.org/index.php/Installation_guide
- https://whjeon.com/arch-install
- https://www.codentalks.com/t/topic/4446

<br/><br/>

----

## 1. Flash media

Download ISO from a mirrorsite:
- https://www.archlinux.org/download/

Run these to find, format, and flash a thumbdrive:
```sh
$ lsblk
$ wipefs --all /dev/sdb
$ dd bs=4M \
    if=~/Downloads/archlinux-2020.06.01-x86_64.iso \
    of=/dev/$TARGET_DISK \
    status=progress && sync
```

<br/><br/>

## 2. In BIOS

Disable secure boot, fast boot, and CSM mode.

Then, boot with the live disk

<br/><br/>

## 3. In live disk

### 3.1 Network config

In case of wifi

```sh
$ systemctl enable iwd.service
$ systemctl start iwd.service
$ systemctl start dhcpcd.service

$ iwctl
[iwd] device list
[iwd] station wlan0 scan
[iwd] station wlan0 get-networks
[iwd] station wlan0 connect SSID
[iwd] exit

$ ping 8.8.8.8
```

In case of ethernet + dhcp
```sh
# make sure the system is connected to cable

$ ip link
$ lspci | grep Ethernet
$ ip link set ens192 up
$ dhcpcd
```

In case of ethernet + static 
```sh
# make sure the system is connected to cable

$ ip link
$ lspci | grep Ethernet
$ ip link set ens192 down
$ ip addr add address 192.168.1.2/24 dev ens192
$ ip route add default via 192.168.1.1
$ ip link set ens192 up
```

### 3.2 Partition



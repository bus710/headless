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

### 3.1 For HiDPI

```sh
$ setfont -h24 /usr/share/kbd/consolefonts/iso01-12x22.psfu.gz
```

<br/><br/>

### 3.2 Network config

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

<details>
<summary> In case of ethernet </summary>

In case of ethernet + dhcp
```sh
# make sure the system is connected to cable

$ ip link
$ lspci | grep Ethernet
$ ip link set $DEVICE up
$ dhcpcd
```

In case of ethernet + static 
```sh
# make sure the system is connected to cable

$ ip link
$ lspci | grep Ethernet
$ ip link set $DEVICE down
$ ip addr add address 192.168.1.2/24 dev $DEVICE
$ ip route add default via 192.168.1.1
$ ip link set $DEVICE up
```

</details>

<br/><br/>

### 3.3 Partition

Find out if EFI is available:
```sh
$ ls /sys/firmware/efi | grep efivars
```

Run these to set partition:
```sh
$ lsblk
$ cfdisk /dev/nvme0n1 # gdisk can be used as well

# Delete all existing and create 2 partitions as primary:
# - /boot, 512M, EFI
# - /, 32G~, Linux Root x86-64 to be mounted automatically)
# - /swap, 8G, Linux swap
# - Write and quit
```

Format disks:
```sh
$ mkfs.vfat -F32 /dev/nvme0n1p1
$ mkfs.ext4 -j /dev/nvme0n1p2
$ mkswap /dev/nvme0n1p3
$ swapon /dev/nvme0n1p3
```

Mount disks:
```sh
# mount target / 
$ mount /dev/nvme0n1p2 /mnt

# create and mount target /boot
$ mkdir /mnt/boot
$ mount /dev/nvme0n1p1 /mnt/boot
```

<br/><br/>

### 3.4 Config mirror and pacstrap

```sh
# uncomment mirror sites to be used
$ vi /etc/pacman.d/mirrorlist

# run pacstrap with packages required
# pick dhcpcd or networkmanager for future usage
pacstrap /mnt \
    linux linux-firmware \
    base \
    base-devel \
    vim \
    man-db \
    man-pages \
    texinfo \
    dosfstools \
    e2fsprogs \
    mdadm \
    lvm2 \
    git \
    dhcpcd \
    networkmanager
```



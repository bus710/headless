# Archlinux installation

<br/><br/>

## Reference

- https://wiki.archlinux.org/index.php/Main_page
- https://wiki.archlinux.org/index.php/Installation_guide
- https://whjeon.com/arch-install :kr:
- https://www.codentalks.com/t/topic/4446 :kr:

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

## 2. In the BIOS

Disable secure boot, fast boot, and CSM mode.

Then, boot with the live disk

<br/><br/>

## 3. In the live disk

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
$ pacstrap /mnt \
    linux linux-firmware \
    base \
    base-devel \
    vim \
    git \
    ntp
    man-db \
    man-pages \
    dosfstools \
    e2fsprogs \
    mdadm \
    lvm2 \
    grub \
    efibootmgr \
    dhcpcd \
    networkmanager \
    iw \
    iwd \
    wpa_supplicant
```

<br/><br/>

### 3.5 config fstab and chroot

```sh
$ genfstab -U /mnt >> /mnt/etc/fstab
$ arch-chroot /mnt
```

<br/><br/>

## 4. In the chroot

### 4.1 Config time

```sh
#$ ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime
$ ln -sf /usr/share/zoneinfo/US/Pacific-New /etc/localtime
$ ntpdate 0.north-america.pool.ntp.org
$ hwclock -w
$ timedatectl status
```

<br/><br/>

### 4.2 Locale and language

```sh
# uncomment "en_US.UTF-8 UTF-8"
$ vim /etc/locale.gen
$ locale-gen

$ export LANG=en_US.UTF-8
$ echo LANG=en_US.UTF-8 > /etc/locale.conf
```

<br/><br/>

### 4.3 Hostname

```sh
$ vim /etc/hostname
```

<br/><br/>

### 4.4 Change root password

```sh
$ passwd
```

<br/><br/>

### 4.5 Add user

```sh
$ useradd -m -g users -G wheel -s /bin/bash $USER_NAME
$ passwd $USER_NAME

# allow wheel group to access sudo 
# uncomment "%wheel ALL=(ALL) ALL"
$ visudo /etc/sudoers
```

<br/><br/>

### 4.6 Config GRUB

```sh
$ pacman -Syu
$ pacman -S grub efibootmgr

$ grub-install \
        --target=x86_64-efi \
        --efi-directory=/boot \
        --bootloader-id=arch \
        --recheck

$ vim /etc/default/grub # if needed
$ grub-mkconfig -o /boot/grub/grub.cfg 
```

Then, exit and reboot

<br/><br/>

## 5. In the fresh system

First of all, config network with iwctl.

### 5.1 Install Gnome

```sh
$ sudo pacman -S xorg-server gdm gnome gnome-tweaks gnome-extra
$ sudo systemctl enable gdm
$ reboot
```

<br/><br/>

### 5.2 Config network with NetworkManager

```sh
$ sudo systemctl stop dhcpcd.service
$ sudo systemctl disable dhcpcd.service
$ sudo systemctl stop iwd.service
$ sudo systemctl disable iwd.service

$ sudo systemctl enable NetworkManager.service
$ sudo systemctl start NetworkManager.service
```

Then, use GUI

<br/><br/>

### 5.3 Yay for AUR 

Yay is an AUR helper.

```sh
$ git clone https://aur.archlinux.org/yay.git
$ cd yay
$ makepkg -si # this installs system level golang
$ yay # to update index
```

To install some pacakges from AUR:
``` sh
# Manually
# - visit https://aur.archlinux.org/
# - search for google-chrome (https://aur.archlinux.org/packages/google-chrome/)
# - download 
# - run 

# with yay
$ yay google-chrome # and pick the version wated
$ yay gnome-shell-extension-dash-to-dock # this requires re-login
```

<br/><br/>

### 5.4 GUI input method

TBD - ibus/fcitx and fonts

<br/><br/>

## Touble shooting

To install Intel micro code (ucode):
```sh
# in case of GRUB
$ sudo pacman -S intel-ucode
$ sudo grub-mkconfig -o /boot/grub/grub.cfg
```

To check hidden issues:
```sh
# find errors on boot
$ sudo journalctl -p 3 -xb

# find errors on systemd
$ sudo systemctl --failed
```

<br/><br/>

## Etc.

```sh
# disable root
$ sudo passwd -l root
```



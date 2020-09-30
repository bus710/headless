#!/bin/bash

set -e

pacman -Sy \
    linux linux-firmware \
    base \
    base-devel \
    zsh \
    vim \
    neovim \
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

#!/bin/bash

pacstrap \
    /mnt \
    linux \
    linux-firmware \
    base \
    base-devel \
    man-db \
    man-pages \
    dosfstools \
    e2fsprogs \
    mdadm \
    lvm2 \
    ntp \
    grub \
    git \
    vim \
    neovim \
    efibootmgr \
    networkmanager

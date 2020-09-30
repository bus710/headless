#!/bin/bash

set -e

pacman -Syu
yes | pacman -S grub efibootmgr

grub-install \
        --target=x86_64-efi \
        --efi-directory=/boot \
        --bootloader-id=arch \
        --recheck

grub-mkconfig -o /boot/grub/grub.cfg

#!/bin/bash

set -e

genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

echo
echo "Please clone headless repo again"
echo 

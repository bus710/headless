#!/bin/bash

set -e

genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt



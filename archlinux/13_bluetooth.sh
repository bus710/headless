#!/bin/bash

set -e

sudo pacman -S fluez bluez-utils blueman

sudo systemctl enable bluetooth
sudo systemctl start bluetooth

# bluetoothctl
# > list
# > discoverable on
# > pairable on
# > scan on 
# > scan off
# > devices
# > pair MAC-ADDR


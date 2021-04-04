#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)"
  exit
fi

echo
echo "Install XFCE4"
echo

sudo apt install -y \
    task-xfce-desktop \
    xfce4-goodies \
    lightdm-gtk-greeter-settings \
    xserver-xorg-input-synaptics

sudo apt install -y \
    pulseaudio-module-bluetooth \
    blueman \
    firmware-sof-signed

sudo systemctl enable lightdm
sudo systemctl enable bluetooth

echo
echo "Done"
echo

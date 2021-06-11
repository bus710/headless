#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)"
  exit
fi

echo
echo "Install XFCE4"
echo

DISTRO=lsb_release -a | grep ID | awk -F " " '{print $3}';

if [[ $DISTRO =~ "Debian" ]]; then
    sudo apt install -y \
        task-xfce-desktop \
        xfce4-goodies \
        xserver-xorg-input-synaptics


    sudo apt install -y \
        pulseaudio-module-bluetooth \
        blueman \
        firmware-sof-signed
fi

sudo apt install -y \
    lightdm-settings \
    lightdm-gtk-greeter \
    lightdm-gtk-greeter-settings

sudo systemctl enable lightdm
sudo systemctl enable bluetooth

echo
echo "Done"
echo

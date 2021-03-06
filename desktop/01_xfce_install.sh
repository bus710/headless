#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)"
  exit
fi

echo
echo "Install XFCE4"
echo

DISTRO=$(lsb_release -a | grep ID | awk -F " " '{print $3}');
CPU_VENDOR=$(lscpu | grep Vendor | awk -F " " '{print $2}');

if [[ $DISTRO =~ "Debian" ]]; then
    sudo apt install -y \
        task-xfce-desktop \
        xserver-xorg-input-synaptics
elif [[ $DISTRO =~ "Ubuntu" ]]; then
    sudo apt install -y \
        xubuntu-core \
        lightdm
fi

if  [[ $CPU_VENDOR =~ "GenuineIntel" ]]; then
    sudo apt install -y \
        firmware-sof-signed
fi

sudo apt install -y \
    blueman \
    xfce4-goodies \
    gtk-3-examples \
    lightdm-settings \
    lightdm-gtk-greeter \
    lightdm-gtk-greeter-settings \
    pulseaudio-module-bluetooth

sudo systemctl enable lightdm
sudo systemctl enable bluetooth

echo
echo "Done"
echo

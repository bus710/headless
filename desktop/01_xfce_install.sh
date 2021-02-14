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

sudo systemctl enable lightdm

echo
echo "Home directory cleanup."
echo

rm -rf ~/Documents
rm -rf ~/Music
rm -rf ~/Videos
rm -rf ~/Templates
rm -rf ~/Public

echo
echo "Remove some packages"
echo

sudo apt remove -y libreoffice-common
sudo apt remove -y parole

echo
echo "Done"
echo

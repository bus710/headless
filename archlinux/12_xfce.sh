#!/bin/bash

set -e

sudo pacman -S xorg-server xfce4 lightdm lightdm-gtk-greeter
sudo systemctl enable lightdm
sudo systemctl start lightdm

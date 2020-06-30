#!/bin/bash

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)"
  exit
fi

# GNOME terminal dracula theme
# https://github.com/dracula/gnome-terminal

sudo apt install -y \
    dconf-cli

git clone https://github.com/GalaticStryder/gnome-terminal-colors-dracula
cd gnome-terminal-colors-dracula
./install.sh
cd ..
rm -rf gnome-terminal-colors-dracula*

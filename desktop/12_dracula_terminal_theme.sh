#!/bin/bash

# GNOME terminal dracula theme
# https://github.com/dracula/gnome-terminal

sudo apt install dconf-cli
git clone https://github.com/GalaticStryder/gnome-terminal-colors-dracula
cd gnome-terminal-colors-dracula
./install.sh
cd ..
rm -rf gnome-terminal-colors-dracula*



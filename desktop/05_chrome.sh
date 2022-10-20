#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]; then 
    echo "Please run as normal user (w/o sudo)"
    exit
fi

if [[ $XDG_CURRENT_DESKTOP =~ "ubuntu:GNOME" ]]; then
    sudo apt install -y \
        chrome-gnome-shell
fi

echo 
echo "Install Chrome Browser"
echo 

cd ~/Downloads
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb

echo
echo "Done"
echo 

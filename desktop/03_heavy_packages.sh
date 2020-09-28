#!/bin/bash

# Preferred font size for Chrome - zoom 125%, font size 15

set -e

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)"
  exit
fi

# Installing GUI applications required.

echo
echo "Install"
echo "- Vim-gnome"
echo "- Gnome Tweak Tools"
echo "- Simple Screen Recorder"
echo "- Pinta"
echo

sudo apt install -y \
    solaar \
    pinta \
    vim-gtk3 \
    chrome-gnome-shell \
    simplescreenrecorder 

if [[ $XDG_CURRENT_DESKTOP =~ "ubuntu:GNOME" ]]; then
    sudo apt install -y \
        gnome-tweak-tool \
        gnome-shell-extensions
fi

echo 
echo "Install Chrome Browser"
echo 

wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
sudo apt update 
sudo apt install -y google-chrome-stable
sudo rm -rf /etc/apt/sources.list.d/google-chrome.list

echo
echo "Gnome Extensions:"
echo "- https://chrome.google.com/webstore/detail/gnome-shell-integration/gphhapmejobijbbhgpjhcjognlahblep?hl=en"
echo "- https://extensions.gnome.org/extension/307/dash-to-dock/"
echo "- https://extensions.gnome.org/extension/1765/transparent-topbar/"
echo "- https://extensions.gnome.org/extension/2588/fully-transparent-top-bar/"
echo 

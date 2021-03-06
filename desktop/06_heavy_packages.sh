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
echo

sudo apt install -y \
    solaar \
    vim-gtk3 \
    simplescreenrecorder 
    #pinta \

if [[ $XDG_CURRENT_DESKTOP =~ "ubuntu:GNOME" ]]; then
    sudo apt install -y \
        gnome-tweak-tool \
        gnome-shell-extensions \
        chrome-gnome-shell
fi

echo 
echo "Install Chrome Browser"
echo 

#wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
#sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
#sudo apt update 
#sudo apt install -y google-chrome-stable
#sudo rm -rf /etc/apt/sources.list.d/google-chrome.list

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb

echo
echo "Done"
echo 

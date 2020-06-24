#!/bin/bash

# Installing GUI applications required.

echo
echo "Install"
echo "- Vim-gnome"
echo "- Gnome Tweak Tools"
echo "- Simple Screen Recorder"
echo "- Pinta"
echo

sudo apt install -y \
    vim-gtk3 \
    gnome-tweak-tool \
    simplescreenrecorder \
    pinta

echo 
echo "Install Chrome Browser"
echo 

wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
sudo apt update 
sudo apt install -y google-chrome-stable

echo
echo "And more:"
echo "- https://slack.com/downloads/linux"
echo "- https://www.microsoft.com/en-us/microsoft-365/microsoft-teams/download-app#desktopAppDownloadregion"
echo "- https://members.symless.com/synergy/downloads/list/s1"
echo 

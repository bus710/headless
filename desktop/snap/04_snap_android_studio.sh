#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)"
  exit
fi

echo
echo "Install snapd and android-studio"
echo

sudo apt install -y snapd

# Classic
#sudo snap install --classic goland
sudo snap install --classic snapcraft
sudo snap install --classic android-studio 

echo
echo "Config ideavim for no sound"
echo

cat ideavimrc >> ~/.ideavimrc

echo
echo "For Android Studio:"
echo "   Install Ideavim, Dracula, File Watcher, Flutter"
echo "   dartfmt: File > Settings > Languages > Flutter"
echo "   SDK update: File > Settings > Appearance > System Settings > Android SDK"
echo "   webdev issue: flutter pub pub cache repair"
echo


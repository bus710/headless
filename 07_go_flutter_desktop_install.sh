#!/bin/bash

if [ "$EUID" != 0 ]
then echo "Please run as the super user (w/ sudo)"
  exit
fi

echo
echo "Please check the website as a reference"
echo "https://github.com/go-flutter-desktop/hover"
echo 
echo "These will be installed"
echo "- hover"
echo "- libgl1-mesa-dev"
echo "- xorg-dev"
echo 
echo "Do you want to install? (y/n)"
echo

read -n 1 ans
echo

if [ $ans == "y" ]
then
    # Get logname first (this is not $USER)
    LOGNAME="$(logname)"
    sudo -u $LOGNAME go get -u github.com/go-flutter-desktop/hover

    apt install -y libgl1-mesa-dev xorg-dev
fi

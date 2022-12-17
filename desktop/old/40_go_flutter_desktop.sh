#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]; then 
    echo "Please run as normal user (w/o sudo)"
    exit
fi

echo
echo -e "\e[91m"
echo "Please check the website as a reference"
echo "https://github.com/go-flutter-desktop/hover"
echo 
echo "These will be installed"
echo "- hover"
echo "- libgl1-mesa-dev"
echo "- xorg-dev"
echo -e "\e[39m"
echo 
echo "Do you want to install? (y/n)"
echo

echo
read -n 1 ans
echo

if [[ $ans == "y" ]]; then
    echo
    echo "wait for hover installation"
    echo

    sudo -u $LOGNAME /usr/local/go/bin/go get -u github.com/go-flutter-desktop/hover

    echo 

    sudo apt install -y \
        libgl1-mesa-dev \
        xorg-dev

    echo
    echo "Done"
    echo
fi

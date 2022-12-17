#!/bin/bash

# Preferred font size - 17

set -e

if [[ "$EUID" == 0 ]]; then 
    echo "Please run as normal user (w/o sudo)"
    exit
fi

VERSION="7.9"
FILENAME="nomachine_${VERSION}.2_1_amd64.deb"

echo
echo "Install"
echo "- NoMachine"
echo

echo
echo -e "\e[91m"
echo "Please check the website if there is a newer version"
echo "- https://www.nomachine.com/download/download&id=4"
echo 
echo "Do you want to install? (y/n)"
echo -e "\e[39m"
echo

echo
read -n 1 ans
echo

if [[ $ans == "y" ]]
then
    echo 
    echo "Download NoMachine"
    echo 

    wget https://download.nomachine.com/download/${VERSION}/Linux/$FILENAME

    echo
    echo "Install NoMachine"
    echo

    sudo dpkg -i $FILENAME

    rm -rf *.deb
fi

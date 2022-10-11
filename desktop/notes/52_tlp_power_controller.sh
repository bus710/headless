#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)"
  exit
fi

echo
echo "MS' Surfece can have issue with this"
echo "Do you want to install? (y/n)"
echo

read -n 1 ans
echo

if [[ $ans == "y" ]]
then
    sudo add-apt-repository ppa:linrunner/tlp
    sudo apt update
    sudo apt install -y tlp tlp-rdw
fi

echo 
echo 
echo "Do this manually if this is a THINKPAD:"
echo "- sudo apt install -y tp-smapi-dkms acpi-call-dkms"
echo

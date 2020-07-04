#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)"
  exit
fi

# Removing some heavy applications.
sudo apt remove -y \
    firefox 

sudo apt remove -y \
    thunderbird

# sudo apt install -y libgnome-keyring0 #for gitkraken

sudo apt install -y \
    inxi \
    gufw \
    glmark2

echo
echo "Done"
echo

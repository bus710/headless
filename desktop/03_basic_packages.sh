#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)"
  exit
fi

# Remove some packages.
sudo apt remove -y \
    firefox 

sudo apt remove -y \
    thunderbird

# Install some packages

sudo apt install -y \
    scrcpy \
    sshfs \
    inxi \
    gufw \
    mpv
    #glmark2

# For flutter 
sudo apt install -y \
    libgtk-3-dev \
    mtp-tools \
    jmtpfs

echo
echo "Done"
echo

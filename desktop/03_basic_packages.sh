#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]; then 
    echo "Please run as normal user (w/o sudo)"
    exit
fi

# Remove some packages.
sudo apt remove -y \
    firefox \
    firefox-esr

sudo apt remove -y \
    thunderbird

# Install some packages
sudo apt install -y \
    xserver-xorg-input-mouse \
    gnome-calculator \
    dconf-editor \
    cheese \
    sshfs \
    xclip \
    inxi \
    gufw \
    peek \
    mpv
    #glmark2

# Install scrcpy
# To access Android wirelessly:
# - connect a target and enable USB debugging
# - run "adb tcpip 5555"
# - run "adb connect $DEVICE_IP:5555
# - disconnect the target
# - run "scrcpy -b2M -m800"
sudo apt install -y \
    scrcpy

# For flutter 
sudo apt install -y \
    libgtk-3-dev \
    mtp-tools \
    jmtpfs

# For rdp
sudo apt install -y \
    remmina \
    ristretto \
    evince

# For Gnome Control Center (Settings)
sudo apt install -y \
    gnome-control-center

echo
echo "Done"
echo

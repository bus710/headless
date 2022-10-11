#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]; then 
    echo "Please run as normal user (w/o sudo)"
    exit
fi

CPU_TYPE=$(uname -p)

if [[ $CPU_TYPE != "x86_64" ]]; then
    echo
    echo "Only x86_64 can be used."
    echo
    exit
fi

echo
echo -e "\e[91m"
echo "Please check these web sites:"
echo "- https://docs.espressif.com/projects/arduino-esp32/en/latest/installing.html#debian-ubuntu"
echo 
echo "Do you want to install? (y/n)"
echo -e "\e[39m"
echo

echo
read -n 1 ans
echo

if [[ $ans == "y" ]]; then
    sudo apt install python-is-python3

    echo 
    echo "Existing Arduino directory will be deleted"
    echo 

    rm -rf $HOME/Arduino
    mkdir -p $HOME/Arduino
    cd $HOME/Arduino

    echo 
    echo "Install prerequisites of Arduino core for ESP32"
    echo 

    sudo usermod -a -G dialout $USER

    wget https://bootstrap.pypa.io/get-pip.py
    sudo python3 get-pip.py
    sudo pip3 install pyserial

    mkdir -p $HOME/Arduino/hardware/espressif
    cd $HOME/Arduino/hardware/espressif
    git clone https://github.com/espressif/arduino-esp32.git esp32

    cd esp32
    git submodule update --init --recursive

    cd tools
    python3 get.py

    echo 
    echo "Done."
fi

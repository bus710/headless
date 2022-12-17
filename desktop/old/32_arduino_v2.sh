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
echo "- https://github.com/arduino/arduino-ide/releases/latest"
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

    rm -rf $HOME/Arduino/arduino-ide*
    cd $HOME/Arduino

    echo
    echo "Download and install Arduino IDE"
    echo 

    cd $HOME/Arduino
    TARGET_VERSION=$(curl --silent https://github.com/arduino/arduino-ide/releases/latest | grep -oP '(?<=/tag\/)[^">]+')

    echo
    echo "TARGET_VERSION: ${TARGET_VERSION}"
    echo

    wget https://github.com/arduino/arduino-ide/releases/download/${TARGET_VERSION}/arduino-ide_${TARGET_VERSION}_Linux_64bit.zip
    unzip arduino-ide_${TARGET_VERSION}_Linux_64bit.zip
    mv arduino-ide_${TARGET_VERSION}_Linux_64bit arduino-ide
    rm -rf *.zip

    echo
    echo "Add path"
    echo 

    echo "" >> $HOME/.shrc
    echo "# For Arduino SDK" >> $HOME/.shrc
    echo "PATH=\$PATH:\$HOME/Arduino/arduino-ide" >> $HOME/.shrc

    echo 
    echo "Done."
    echo "1. Please source .shrc"
    echo "2. File > Preferences > Additional boards manager URLs"
    echo "  Add the line below to the board manager"
    echo "  https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_dev_index.json, https://dl.espressif.com/dl/package_esp32_index.json"
    echo "3. Tools > Board > Boards manager > Search for ESP32 and install"
    echo
fi

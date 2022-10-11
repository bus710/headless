#!/bin/bash

set -e

ARDUINO_VERSION="arduino-1.8.15-linux64.tar.xz"

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
echo "- https://github.com/arduino/Arduino/releases"
echo 
echo "Do you want to install ${ARDUINO_VERSION}? (y/n)"
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

    rm -rf $HOME/arduino-ide
    mkdir $HOME/arduino-ide

    echo
    echo "Download and install Arduino v1"
    echo "TARGET_VERSION: ${ARDUINO_VERSION}"
    echo

    cd $HOME
    wget https://downloads.arduino.cc/${ARDUINO_VERSION}
    tar xf ${ARDUINO_VERSION} -C ~/arduino-ide --strip-components 1
    rm -rf ${ARDUINO_VERSION}

    cd $HOME/arduino-ide
    sudo ./install.sh

    echo 
    echo "Done."
    echo "1. File > Preferences > Additional boards manager URLs"
    echo "  Add the line below to the board manager"
    echo "  https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_dev_index.json, https://dl.espressif.com/dl/package_esp32_index.json"
    echo "2. Tools > Board > Boards manager > Search for ESP32 and install"
    echo "3. Please congigure VSCODE's arduino extension"
    echo
fi

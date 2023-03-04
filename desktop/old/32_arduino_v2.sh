#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]; then
    echo "Please run as normal user (w/o sudo)"
    exit
fi

term_color_red () {
    echo -e "\e[91m"
}

term_color_white () {
    echo -e "\e[39m"
}

confirmation () {
    CPU_TYPE=$(uname -m)
    if [[ $CPU_TYPE != "x86_64" ]]; then
        echo "Only x86_64 can be used."
        exit
    fi

    term_color_red
    echo "Please check these web sites:"
    echo "- https://github.com/arduino/arduino-ide/releases/latest"
    echo
    echo "Do you want to install? (y/n)"
    term_color_white

    echo
    read -n 1 ans
    echo

    if [[ ! $ans == "y" ]]; then
        exit
    fi
}

install_packages () {
    term_color_red
    echo "Install packages"
    term_color_white

    sudo apt install -y python-is-python3

    term_color_red
    echo "Existing Arduino directory will be deleted"
    term_color_white

    rm -rf /home/$LOGNAME/Arduino/ide_v2
    mkdir -p /home/$LOGNAME/Arduino/ide_v2
    cd /home/$LOGNAME/Arduino/ide_v2

    term_color_red
    echo "Download and install Arduino IDE"
    term_color_white

    cd /home/$LOGNAME/Arduino/ide_v2
    TARGET_VERSION=$(curl -o- -s https://api.github.com/repos/arduino/arduino-ide/releases/latest | jq -r '.tag_name')

    term_color_red
    echo "TARGET_VERSION: ${TARGET_VERSION}"
    term_color_white

    wget https://github.com/arduino/arduino-ide/releases/download/${TARGET_VERSION}/arduino-ide_${TARGET_VERSION}_Linux_64bit.zip
    unzip arduino-ide_${TARGET_VERSION}_Linux_64bit.zip
    mv arduino-ide_${TARGET_VERSION}_Linux_64bit arduino-ide
    rm -rf *.zip

    term_color_red
    echo "Add to path"
    term_color_white

    sed -i '/#ARDUINO_V2_0/c\export PATH=$PATH:$HOME/Arduino/ide_v2' /home/$LOGNAME/.shrc
}

post () {
    term_color_red
    echo "Done."
    echo "1. Please source .shrc"
    echo "2. File > Preferences > Additional boards manager URLs"
    echo "  Add the lines below to the board manager (comma should be add between lines)"
    echo "  https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_dev_index.json"
    echo "  https://dl.espressif.com/dl/package_esp32_index.json"
    echo "3. Tools > Board > Boards manager > Search for ESP32 and install"
    term_color_white
}

trap term_color_white EXIT
confirmation
install_packages
post

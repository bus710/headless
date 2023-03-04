#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]; then
    echo "Please run as normal user (w/o sudo)"
    exit
fi

ARCH=""

term_color_red () {
    echo -e "\e[91m"
}

term_color_white () {
    echo -e "\e[39m"
}

confirmation () {
    CPU_TYPE=$(uname -m)
    if [[ $CPU_TYPE != "x86_64" && $CPU_TYPE != "aarch64" ]]; then
        echo "x86_64 or aarch64 can be used."
        exit
    fi

    if [[ $CPU_TYPE == "x86_64" ]]; then
        ARCH="64bit"
    fi
    if [[ $CPU_TYPE == "aarch64" ]]; then
        ARCH="ARM64"
    fi

    term_color_red
    echo "Please check these web sites:"
    echo "- https://github.com/arduino/arduino-cli/releases/latest"
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

    term_color_red
    echo "Existing Arduino directory will be deleted"
    term_color_white

    rm -rf /home/$LOGNAME/Arduino/cli
    mkdir -p /home/$LOGNAME/Arduino/cli
    cd /home/$LOGNAME/Arduino/cli

    term_color_red
    echo "Download and install Arduino IDE"
    term_color_white

    cd /home/$LOGNAME/Arduino/cli
    TARGET_VERSION=$(curl -o- -s https://api.github.com/repos/arduino/arduino-cli/releases/latest | jq -r '.tag_name')

    term_color_red
    echo "TARGET_VERSION: ${TARGET_VERSION}"
    term_color_white

    wget https://github.com/arduino/arduino-cli/releases/download/${TARGET_VERSION}/arduino-cli_${TARGET_VERSION}_Linux_${ARCH}.tar.gz
    tar xf arduino-cli_${TARGET_VERSION}_Linux_${ARCH}.tar.gz
    rm -rf *.gz

    term_color_red
    echo "Add to path"
    term_color_white

    sed -i '/#ARDUINO_CLI_0/c\export PATH=$PATH:$HOME/Arduino/cli' /home/$LOGNAME/.shrc
}

post () {
    term_color_red
    echo "Done"
    term_color_white
}

trap term_color_white EXIT
confirmation
install_packages
post

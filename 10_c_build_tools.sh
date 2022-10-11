#!/bin/bash

set -e

CPU_TYPE=$(uname -m)
OS_TYPE=$(lsb_release -i)

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)"
  exit
fi

term_color_red () {
    echo -e "\e[91m"
}

term_color_white () {
    echo -e "\e[39m"
}

confirmation(){
    term_color_red
    echo
    echo "Start installing some basic packages for c"
    echo "Do you want to install? (y/n)"
    echo
    term_color_white

    echo
    read -n 1 ans
    echo

    if [[ ! $ans == "y" ]]; then 
        echo "" 
        exit -1
    fi
}

install_packages (){
    term_color_red
    echo
    echo "Install basics"
    echo
    term_color_white

    sudo apt update

    sudo apt install -y \
        make \
        cmake \
        meson \
        global \
        sqlite3 \
        minicom \
        ninja-build \
        build-essential \
        exuberant-ctags 

    # Depends on the architecture 
    if [[ $CPU_TYPE == "x86_64" ]]; then
        term_color_red
        echo
        echo "Install for Flutter SDK"
        echo
        term_color_white

        sudo apt install -y lib32stdc++6

    elif [[ $CPU_TYPE == "aarch64" ]]; then
        echo
    fi
}

cleanup(){
    term_color_red
    echo
    echo "Cleanup"
    echo 
    term_color_white

    sudo apt autoremove -y
}

post(){
    term_color_red
    echo
    echo "Done"
    echo
    term_color_white
}

trap term_color_white EXIT
confirmation
install_packages
cleanup
post

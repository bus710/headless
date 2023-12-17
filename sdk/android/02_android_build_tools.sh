#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]; then 
    echo "Please run as a normal user (w/o sudo)"
    exit
fi

term_color_red () {
    echo -e "\e[91m"
}

term_color_white () {
    echo -e "\e[39m"
}

confirmation() {
    term_color_red
    echo
    echo "Android platform-tools and build-tools will be installed"
    echo "Do you want to install? (y/n)"
    echo
    term_color_white

    echo
    read -n 1 ans
    echo

    if [[ ! $ans == "y" ]]; then 
        echo
        exit 1
    fi
}

install_build_tools(){
    term_color_red
    echo
    echo "Install build tools"
    echo 
    term_color_white

    sdkmanager --version
    sdkmanager --list

    echo

    sdkmanager "platform-tools" "platforms;android-29"
    sdkmanager "platform-tools" "platforms;android-30"
    sdkmanager "platform-tools" "platforms;android-31"

    echo

    sdkmanager "build-tools;29.0.3"
    sdkmanager "build-tools;30.0.0"
    sdkmanager "build-tools;31.0.0"

    term_color_red
    echo
    echo "License confirmation"
    echo
    term_color_white

    sdkmanager --licenses
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
install_build_tools
post

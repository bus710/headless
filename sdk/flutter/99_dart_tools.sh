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

confirmation(){
    term_color_red
    echo "Some dart tools will be installed."
    echo "Do you want to install? (y/n)"
    term_color_white

    read -n 1 ans

    if [[ ! $ans == "y" ]]; then 
        echo
        exit 1
    fi
}

install_packages(){
    term_color_red
    echo "Install global packages"
    term_color_white

    dart pub global activate ffigen
    dart pub global activate protoc_plugin
}

post(){
    term_color_red
    echo "Done"
    term_color_white
}

trap term_color_white EXIT
confirmation
install_packages
post

#!/bin/bash

set -e

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
    echo "Install Pulumi"
    echo "Do you want to install? (y/n)"
    term_color_white

    echo
    read -n 1 ans
    echo

    if [[ ! $ans == "y" ]]; then 
        exit -1
    fi

    sudo echo
}

cleanup(){
    term_color_red
    echo "Remove .pulumi under \$HOME"
    term_color_white

    rm -rf $HOME/.pulumi
}

install_pulumi(){
    term_color_red
    echo "Install Pulumi"
    term_color_white

    curl -fsSL https://get.pulumi.com | sh
}

post(){
    term_color_red
    echo "Done"
    term_color_white
}

trap term_color_white EXIT
confirmation
cleanup
install_pulumi
post

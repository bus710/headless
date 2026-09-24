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

install_flyctl(){
    term_color_red
    echo "Get the flyctl"
    term_color_white

    rm -rf /home/$LOGNAME/.fly
    curl -L https://fly.io/install.sh | sh

}

post(){
    term_color_red
    echo "Done"
    echo "- the PATHs exist in shrc"
    echo "- login with \'flyctl auth login\' with +flyio account"
    term_color_white
}

trap term_color_white EXIT
install_flyctl
post

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


check_architecture(){
    CPU_TYPE=$(uname -m)
    if [[ $CPU_TYPE != "x86_64" ]]; then
        term_color_red
        echo
        echo "Not x86_64"
        echo
        term_color_white

        exit -1
    fi
}

install_sdk(){
    term_color_red
    echo
    echo "Firebase install"
    echo
    term_color_white

    curl -sL firebase.tools | bash

    term_color_red
    echo
    echo "Firebase login"
    echo
    term_color_white

    firebase login
}

post(){
    term_color_red
    echo
    echo "Check the detail:"
    echo "- https://github.com/firebase/firebase-tools"
    echo
    echo "Done"
    echo
    term_color_white
}

trap term_color_white EXIT
check_architecture
install_sdk
post

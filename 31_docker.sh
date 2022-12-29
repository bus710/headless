#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]; then 
    echo "Please run as super user (w/o sudo)"
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
    echo "Docker and docker-compose will be installed"
    echo "Do you want to install? (y/n)"
    echo
    term_color_white

    echo
    read -n 1 ans
    echo

    if [[ ! $ans == "y" ]]; then 
        exit
    fi
}

install_docker_base(){
    term_color_red
    echo
    echo "Install docker base packages"
    echo
    term_color_white

    # For Docker
    sudo apt install -y \
        gnupg-agent \
        apt-transport-https \
        ca-certificates \
        software-properties-common
}

install_docker(){
    term_color_red
    echo
    echo "Install docker & docker-compose"
    echo
    term_color_white

    sudo apt update
    sudo apt install -y docker.io
    sudo apt install -y docker-compose

    sudo systemctl enable docker
    sudo systemctl start docker
}

configure_permission(){
    term_color_red
    echo
    echo "Add permission of docker for the current user - ${LOGNAME}"
    echo
    term_color_white

    sudo usermod -aG docker ${LOGNAME}
}

post(){
    term_color_red
    echo
    echo "Docker daemon is enabled/started"
    echo "(reboot to take effect)"
    echo
    echo "Done"
    echo
    term_color_white
}

trap term_color_white EXIT
confirmation
install_docker_base
install_docker
configure_permission
post
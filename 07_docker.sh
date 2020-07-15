#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]
then 
    echo "Please run as super user (w/o sudo)"
    exit
fi

echo
echo -e "\e[91m"
echo "Docker and docker-compose will be installed"
echo "Do you want to install? (y/n)"
echo -e "\e[39m"
echo

echo
read -n 1 ans
echo

if [[ $ans == "y" ]]
then 
    LOGNAME=$(logname)

    echo
    echo "Install docker & docker-compose"
    echo

    sudo apt update
    sudo apt install -y docker.io
    sudo apt install -y docker-compose

    sudo systemctl enable docker
    sudo systemctl start docker

    echo
    echo "Add permission of docker for the current user - ${LOGNAME}"
    echo

    sudo usermod -aG docker ${LOGNAME}

    echo
    echo "Docker daemon is enabled/started"
    echo "(reboot to take effect)"
    echo
fi

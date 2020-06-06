#!/bin/bash

if [ "$EUID" != 0 ]
then 
    echo "Please run as the super user (w/ sudo)"
    exit
fi

echo
echo -e "\e[91m"
echo "Docker and docker-compose will be installed"
echo "Do you want to install? (y/n)"
echo -e "\e[39m"
echo

read -n 1 ans
echo

if [ $ans == "y" ]
then 
    apt update
    apt install -y docker.io
    apt install -y docker-compose

    systemctl enable docker
    systemctl start docker

    echo
    echo "!! Docker daemon is enabled/started !!"
    echo 
    echo "!! Add the user to the docker group !!"
    echo "!! sudo usermod -aG docker '${LOGNAME}' !!"
    echo
fi

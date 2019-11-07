#!/bin/bash

DOCKER_COMPOSE_VERSION="1.24.0"

if [ "$EUID" != 0 ]
then 
    echo "Please run as the super user (w/ sudo)"
    exit
fi

OSNAME="$(lsb_release -ds)"

if [[ "$OSNAME" == *"Debian"* ]]
then
    echo "Sorry, Debian is not supported by this script"
    exit
fi

echo
echo -e "\e[91m"
echo "Please check the website if there is a newer version of docker-compose"
echo "https://github.com/docker/compose/releases"
echo
echo "$DOCKER_COMPOSE_VERSION will be installed"
echo -e "\e[39m"
echo
echo "Do you want to install? (y/n)"
echo

read -n 1 ans
echo

if [ $ans == "y" ]
then 
    apt update
    apt install -y docker-ce docker-ce-cli containerd.io

    systemctl enable docker
    systemctl start docker

    # For Docker-compose
    rm -rf /usr/local/bin/docker-compose
    curl -L "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose

    echo
    echo "!! Docker daemon is enabled/started !!"
    echo "!! Check Docker-Compose version (Currently $DOCKER_COMPOSE_VERSION) !!"
    echo "!! Add the user to the docker group !!"
    echo
fi

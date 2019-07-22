#!/bin/bash

DOCKER_COMPOSE_VERSION="1.24.0"

if [ "$EUID" != 0 ]
then echo "Please run as the super user (w/ sudo)"
  exit
fi

echo
echo "Please check the website if there is a newer version of docker-compose"
echo "https://github.com/docker/compose/releases"
echo
echo "$DOCKER_COMPOSE_VERSION will be installed"
echo
echo "Do you want to install? (y/n)"
echo

read -n 1 ans
echo

if [ $ans == "y" ]
then 
    OSNAME="$(lsb_release -ds)"

    if [ "$OSNAME" == *"Debian"* ]
    then
        echo "debian"
        curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add - 
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
    else
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" 
    fi

    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io

    sudo systemctl enable docker
    sudo systemctl start docker

    # For Docker-compose
    sudo curl -L "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose

    echo
    echo "!! Docker daemon is enabled/started !!"
    echo "!! Check Docker-Compose version (Currently $DOCKER_COMPOSE_VERSION) !!"
    echo "!! Add the user to the docker group !!"
    echo
fi

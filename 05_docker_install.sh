#!/bin/bash

DOCKER_COMPOSE_VERSION="1.24.0"

file="/etc/debian_version"

if [ -f "$file" ]
then
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add - 
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs)  stable"
else
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add –
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
echo "!! Check Docker-Compose version (Currently 1.24) !!"
echo "!! Add the user to the docker group !!"
echo

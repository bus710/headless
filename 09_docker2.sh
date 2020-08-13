#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]
then 
    echo "Please run as super user (w/o sudo)"
    exit
fi

CPU_TYPE=$(uname -p)
CPU_TARGET=""
 
if [[ $CPU_TYPE == "x86_64" ]]; then
    CPU_TARGET="amd64" 
elif [[ $CPU_TYPE == "aarch64" ]]; then
    CPU_TARGET="arm64"
else
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
    echo "Remove old docker & docker-compose"
    echo

    sudo apt-get remove -y \
        docker \
        docker.io \
        containerd \
        runc

    sudo rm -rf /usr/local/bin/docker-compose

    echo
    echo "Install prerequisites"
    echo

    sudo apt update
    sudo apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        software-properties-common

    echo
    echo "Get key"
    echo

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

    echo 
    echo "Add repo"
    echo 

    sudo add-apt-repository -y \
        "deb [arch=${CPU_TARGET}] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable"

    echo
    echo "Install docker & docker-compose"
    echo

    sudo apt update
    sudo apt-get install -y \
        docker-ce \
        docker-ce-cli \
        containerd.io

    sudo systemctl enable docker
    sudo systemctl start docker

    sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

    sudo chmod +x /usr/local/bin/docker-compose

    echo
    echo "Add permission of docker for the current user - ${LOGNAME}"
    echo

    sudo usermod -aG docker ${LOGNAME}

    echo
    echo "Docker daemon is enabled/started"
    echo "(reboot to take effect)"
    echo
fi

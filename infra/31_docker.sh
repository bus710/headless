#!/bin/bash

set -e

LSB_RELEASE_CODENAME=$(lsb_release -cs)

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
    echo "Docker and docker-compose will be installed"
    echo "Do you want to install? (y/n)"
    term_color_white

    echo
    read -n 1 ans
    echo

    if [[ ! $ans == "y" ]]; then 
        exit
    fi
}

cleanup(){
    term_color_red
    echo "Clean up"
    term_color_white

    for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; \
    do sudo apt-get remove $pkg; done
}

install_docker_base(){
    term_color_red
    echo "Install docker base packages"
    term_color_white

    # For Docker
    sudo apt install -y \
        gnupg-agent \
        apt-transport-https \
        ca-certificates \
        curl

    sudo install -m 0755 -d /etc/apt/keyrings

    sudo rm -rf /etc/apt/keyrings/docker.asc
    sudo curl -fsSL \
        https://download.docker.com/linux/debian/gpg \
        -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
}

install_docker(){
    term_color_red
    echo "Install docker & docker-compose"
    term_color_white

    sudo apt update
    sudo apt-get install -y \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin

    # If the docker-buildx-plugin doesn't work:
    # mkdir -p ~/.docker/cli-plugin
    # cd ~/.docker/cli-plugin
    # wget -O docker-buildx https://github.com/docker/buildx/releases/download/v0.30.1/buildx-v0.30.1.linux-amd64
    # chmod 764 docker-buildx
}

install_docker_forky(){
    term_color_red
    echo "Install docker & docker-compose for debian forky"
    term_color_white

    sudo apt update
    sudo apt install -y \
        docker.io \
        docker-compose \
        docker-cli 

    sudo systemctl enable docker
    sudo systemctl start docker
}

configure_permission(){
    term_color_red
    echo "Add permission of docker for the current user - ${LOGNAME}"
    term_color_white

    sudo usermod -aG docker ${LOGNAME}
}

post(){
    term_color_red
    echo "Docker daemon is enabled/started"
    echo "Rebooting is recommended"
    echo "Docker compose is now a subset of docker command (not docker-compose)"
    echo "Try - sudo docker run hello-world"
    echo
    echo "Done"
    term_color_white
}

trap term_color_white EXIT
confirmation
cleanup

if [[ ! $LSB_RELEASE_CODENAME == "forky" ]]; then 
    install_docker_base
    install_docker
else 
    install_docker_forky
fi
configure_permission
post

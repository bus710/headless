#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]; then 
    echo "Please run as normal user (w/o sudo)"
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
        echo "Not x86_64"
        term_color_white

        exit -1
    fi
}

install_sdk(){
    term_color_red
    echo "Add the repo"
    term_color_white

    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

    term_color_red
    echo "Install addtional packages"
    term_color_white

    sudo apt install -y \
        apt-transport-https \
        ca-certificates \
        gnupg

    term_color_red
    echo "Get the public key"
    term_color_white

    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
        sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

    term_color_red
    echo "Install GCP SDK, App engine, Kubectl"
    term_color_white

    sudo apt update && sudo apt install -y \
        google-cloud-sdk \
        google-cloud-sdk-app-engine-go \
        kubectl \
        google-cloud-sdk-gke-gcloud-auth-plugin

    term_color_red
    echo "Init"
    term_color_white

    gcloud init
}

post(){
    term_color_red
    echo "Check the detail:"
    echo "- https://cloud.google.com/sdk/docs/downloads-apt-get"
    echo
    echo "Done"
    term_color_white
}

trap term_color_white EXIT
check_architecture
install_sdk
post

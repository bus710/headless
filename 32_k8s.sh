#!/bin/bash

# https://kubernetes.io/docs/tasks/tools/

set -e

CPU_TYPE=$(uname -m)
CPU_TARGET=""

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

check_architecture(){
    if [[ $CPU_TYPE == "x86_64" ]]; then
        CPU_TARGET="amd64" 
    elif [[ $CPU_TYPE == "aarch64" ]]; then
        CPU_TARGET="arm64"
    else
        exit
    fi

    cd $HOME/Downloads
}

confirmation(){
    term_color_red
    echo "Kubectl, Minikube, and Kubeadm will be installed"
    echo "Do you want to install? (y/n)"
    term_color_white

    echo
    read -n 1 ans
    echo

    if [[ ! $ans == "y" ]]; then 
        exit
    fi
}

install_kubectl(){
    # Remove if there is an old one
    if [[ -f /usr/local/bin/kubectl ]]; then
        sudo rm -rf /usr/local/bin/kubectl
    fi

    term_color_red
    echo "Check the stable version for Kubectl"
    term_color_white

    V=$(curl -L -s -w '\n' https://dl.k8s.io/release/stable.txt)
    echo $V

    term_color_red
    echo "Install Kubectl"
    term_color_white

    curl -LO "https://dl.k8s.io/release/${V}/bin/linux/${CPU_TARGET}/kubectl"

    term_color_red
    echo "Validate Kubectl"
    term_color_white

    curl -LO "https://dl.k8s.io/${V}/bin/linux/amd64/kubectl.sha256"
    RES=$(echo "$(cat kubectl.sha256) kubectl" | sha256sum --check)
    rm -rf kubectl.sha256
    
    if [[ ! $RES =~ "kubectl: OK" ]]; then
        term_color_red
        echo "Validation failed - exit"
        term_color_white
        exit
    fi

    term_color_red
    echo "Validation succeeded"
    echo "- move Kubectl under /usr/local/bin"
    term_color_white

    sudo install \
        -o $LOGNAME -g root -m 0755 \
        kubectl /usr/local/bin/kubectl
    sudo rm -rf kubectl
}

install_minikube(){
    # Remove if there is an old one
    if [[ -f /usr/local/bin/minikube ]]; then
        sudo rm -rf /usr/local/bin/minikube
    fi

    term_color_red
    echo "Install Minikube"
    term_color_white

    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-${CPU_TARGET}

    sudo install \
        -o $LOGNAME -g root -m 0755 \
        minikube-linux-${CPU_TARGET} /usr/local/bin/minikube
    sudo rm -rf minikube
}

install_kubeadm(){
    term_color_red
    echo "Install Kubeadm"
    term_color_white

    # Get the key
    sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg \
        https://packages.cloud.google.com/apt/doc/apt-key.gpg

    # Add the repo list
    A="[signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg]"
    B="https://apt.kubernetes.io/ kubernetes-xenial main"
    echo "deb $A $B" | sudo tee /etc/apt/sources.list.d/kubernetes.list

    # Install Kubeadm
    sudo apt-get update
    sudo apt-get install -y kubelet kubeadm
    sudo apt-mark hold kubelet kubeadm
}

post(){
    term_color_red
    echo "Done"
    term_color_white
}

trap term_color_white EXIT
check_architecture
confirmation
install_kubectl
install_minikube
install_kubeadm
post

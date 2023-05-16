#!/bin/bash

set -e

URL=https://go.dev/VERSION\?m\=text
CPU_TYPE=$(uname -m)
CPU_TARGET=""
FULL_VERSION=""

if [[ "$EUID" == 0 ]];
    then echo "Please run as normal user (w/o sudo)"
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
    V=$(curl -s -w '\n' ${URL})
    FULL_VERSION="${V}.linux-$CPU_TARGET.tar.gz"
}

confirmation(){
    term_color_red
    echo "1. Remove /usr/local/go and ~/go"
    echo "2. Install ${FULL_VERSION}"
    echo
    echo "Do you want to proceed? (y/n)"
    term_color_white

    echo
    read -n 1 ans
    echo

    if [[ ! $ans == "y" ]]; then
        echo ""
        exit -1
    fi
}

cleanup(){
    term_color_red
    echo "Existing Go directories will be deleted"
    term_color_white

    sudo bash -c "rm -rf /usr/local/go"
    sudo rm -rf /home/$LOGNAME/go

    sudo bash -c "mkdir -p /usr/local/go"
    mkdir /home/$LOGNAME/go
    chown $LOGNAME:$LOGNAME /home/$LOGNAME/go
}

install_go(){
    term_color_red
    echo "Download and install Go SDK"
    term_color_white

    # Remove if there is old tarballs
    echo
    rm -rf go*.tar.gz*
    echo

    wget https://dl.google.com/go/${FULL_VERSION}

    term_color_red
    echo "Wait for untar..."
    term_color_white

    sudo bash -c "tar -xf go*.tar.gz --strip-components=1 -C /usr/local/go"
    rm -rf go*.tar.gz
}

configure_runcom(){
    term_color_red
    echo "Configure runcom"
    term_color_white

    if [[ -f /usr/local/go/bin/go ]]; then
        sed -i '/#GO_0/c\export GOROOT=\/usr\/local\/go' /home/$LOGNAME/.shrc
        sed -i '/#GO_1/c\export GOPATH=\$HOME\/go' /home/$LOGNAME/.shrc
        sed -i '/#GO_2/c\export PATH=$PATH:\$GOROOT/bin:\$GOPATH/bin' /home/$LOGNAME/.shrc
        sed -i '/#GO_3/c\export DELVE_EDITOR=nvim' /home/$LOGNAME/.shrc
    fi

    source /home/$LOGNAME/.shrc
}

post(){
    term_color_red
    echo "Done"
    term_color_white
}

trap term_color_white EXIT
check_architecture
confirmation
cleanup
install_go
configure_runcom
post

#!/bin/bash

set -e

ELM_RELEASE_URL=https://api.github.com/repos/elm/compiler/releases/latest
ELM_RELEASE=""

CPU_TYPE=$(uname -m)
FILE_NAME=""
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
        FILE_NAME="binary-for-linux-64-bit.gz"
    elif [[ $CPU_TYPE == "aarch64" ]]; then
        # FILE_NAME="binary-for-linux-64-bit-ARM.gz"
        echo "ARM64 is not supported yet."
        # https://dev.to/csaltos/elm-for-linux-arm64-32bc
        exit 1
    else
        exit 1
    fi

    ELM_RELEASE=$(curl -o- -s $ELM_RELEASE_URL | jq -r '.tag_name')
    FULL_VERSION="$ELM_RELEASE/$FILE_NAME"
}

confirmation(){
    term_color_red
    echo "1. Remove /usr/local/bin/elm"
    echo "2. Install ${FULL_VERSION}"
    echo
    echo "Do you want to proceed? (y/n)"
    term_color_white

    echo
    read -n 1 ans
    echo

    if [[ ! $ans == "y" ]]; then
        echo ""
        exit 1
    fi
}

cleanup(){
    term_color_red
    echo "Existing ELM directories will be deleted"
    term_color_white

    sudo bash -c "rm -rf /usr/local/bin/elm"
    sudo rm -rf /home/$LOGNAME/.elm
    rm -rf /home/$LOGNAME/.config/elm
    rm -rf /home/$LOGNAME/.cache/elm
}

install_elm(){
    term_color_red
    echo "Download and install ELM SDK"
    term_color_white

    # Remove if there is old tarballs
    echo
    rm -rf elm.gz
    echo

    cd /home/bus710/Downloads

    curl -L -o elm.gz https://github.com/elm/compiler/releases/download/${FULL_VERSION}

    term_color_red
    echo "Wait for unzip..."
    term_color_white

    gunzip elm.gz
    chmod +x elm
    sudo mv elm /usr/local/bin/

    rm -rf elm*
    cd -
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
install_elm
post

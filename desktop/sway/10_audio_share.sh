#!/bin/bash

set -e

RELEASE_URL=https://api.github.com/repos/mkckr0/audio-share/releases/latest
RELEASE_VER=""
RELEASE=""

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

check_architecture_and_version(){
    CPU_TARGET=$(uname -m)
    if [[ $CPU_TARGET != "x86_64" && $CPU_TARGET != "aarch64" ]]; then
        exit
    fi

    RELEASE_VER=$(curl -o- -s $RELEASE_URL | jq -r '.tag_name')
    RELEASE=https://github.com/mkckr0/audio-share/releases/download/${RELEASE_VER}/audio-share-server-cmd-linux.tar.gz
}

confirmation(){
    term_color_red
    echo "What will happen:"
    echo "- Remove /usr/local/bin/as-cmd"
    echo "- Install audio-share server ${RELEASE_VER}"
    echo
    echo "Do you want to proceed? (y/n)"
    term_color_white

    read -n 1 ans
    echo

    if [[ ! $ans == "y" ]]; then
        exit 1
    fi
}

cleanup(){
    term_color_red
    echo "Clean-up"
    term_color_white

    # Remove if there are an old binary and tarballs
    sudo rm -rf /usr/local/bin/as-cmd
    rm -rf /home/$LOGNAME/Downloads/audio-share-server*
}

install(){
    term_color_red
    echo "Install"
    term_color_white

    cd /home/$LOGNAME/Downloads
    wget $RELEASE

    tar xf audio-share-server-cmd-linux.tar.gz
    sudo cp audio-share-server-cmd/bin/as-cmd /usr/local/bin
    rm -rf /home/$LOGNAME/Downloads/audio-share-server*

    cd -
}


post(){
    term_color_red
    echo "Links"
    echo "- https://github.com/mkckr0/audio-share"
    echo "- https://f-droid.org/en/packages/io.github.mkckr0.audio_share_app/"
    echo
    echo "Usage:"
    echo "- $ as-cmd -b"
    term_color_white
}

trap term_color_white EXIT
check_architecture_and_version
confirmation
cleanup
install
post

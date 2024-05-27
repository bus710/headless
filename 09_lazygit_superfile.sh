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

confirmation(){
    term_color_red
    echo "Do you want to install LazyGit and SuperFile? (y/n)"
    echo "- https://github.com/jesseduffield/lazygit"
    echo "- https://github.com/yorukot/superfile"
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
    echo "Existing executables will be removed"
    term_color_white

    sudo bash -c "rm -rf /usr/local/lazygit"
    sudo bash -c "rm -rf /usr/local/superfile"
}

install_lazygit(){
    term_color_red
    echo "Download and install LazyGit"
    term_color_white

    cd /home/$LOGNAME/Downloads
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
    rm -rf lazygit*
    cd -
}

install_superfile(){
    term_color_red
    echo "Download and install SuperFile"
    term_color_white

    bash -c "$(wget -qO- https://raw.githubusercontent.com/yorukot/superfile/main/install.sh)"
}

post(){
    term_color_red
    echo "Done"
    term_color_white
}

trap term_color_white EXIT
confirmation
cleanup
install_lazygit
install_superfile
post

#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)"
  exit
fi

ERLANG_VERSION=""

term_color_red () {
    echo -e "\e[91m"
}

term_color_white () {
    echo -e "\e[39m"
}

register_repo(){
    term_color_red
    echo "Register repo"
    term_color_white

    FIND_ERLANG=$(asdf plugin list)
    if [[ ! $FIND_ERLANG =~ 'erlang' ]]; then
        asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git
    fi

    ERLANG_VERSION=$(asdf latest erlang)
    # github API equivalent
    # curl -o- -s https://api.github.com/repos/erlang/otp/releases/latest | jq -r '.tag_name'
}

confirmation(){
    term_color_red
    echo "Install Erlang via ASDF"
    echo "Do you want to install? (y/n)"
    echo "- Erlang: $ERLANG_VERSION"
    term_color_white

    echo
    read -n 1 ANSWER
    echo

    if [[ ! $ANSWER == "y" ]]; then
        exit -1
    fi
    echo ""
    sudo echo ""
}

install_packages(){
    term_color_red
    echo "Install packages"
    term_color_white

    sudo apt install -y \
        automake \
        autoconf \
        libncurses5-dev \
        xsltproc \
        fop \
        libxml2-utils \
        erlang-jinterface \
        openjdk-11-jdk-headless \
        libodbc2 \
        unixodbc-dev \
        inotify-tools \
        libssl-dev
}

install_latest_versions(){
    term_color_red
    echo "Get the latest versions"
    term_color_white

    asdf install erlang $ERLANG_VERSION
    asdf global erlang $ERLANG_VERSION 
}

check_installed_versions(){
    term_color_red
    echo "Check installed versions"
    term_color_white
    
    asdf current
}

trap term_color_white EXIT
register_repo
confirmation
install_packages
install_latest_versions
check_installed_versions 

echo
echo "Done"
echo

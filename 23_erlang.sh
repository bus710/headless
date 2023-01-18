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
        build-essential \
        automake \
        autoconf \
        m4 \
        libncurses5-dev \
        libncurses-dev \
        erlang-jinterface \
        libodbc2 \
        inotify-tools \
        libpng-dev \
        libssh-dev \
        unixodbc-dev \
        xsltproc \
        fop \
        libxml2-utils \
        openjdk-11-jdk-headless
}

install_packages_for_wx_debugger(){
    term_color_red
    echo "Install packages for wx debugger"
    term_color_white

    sudo apt-get -y install \
        libwxgtk-webview3.2-dev \
        libwxgtk-webview3.0-gtk3-dev \
        libwxgtk3.0-gtk3-dev \
        libgl1-mesa-dev \
        libglu1-mesa-dev

    # For Gnome4 or something newer
    # libwebkit2gtk-4.0-dev
}


install_erlang(){
    term_color_red
    echo "install erlang"
    term_color_white

    asdf install erlang $ERLANG_VERSION
    asdf global erlang $ERLANG_VERSION 
}

install_rebar3(){
    term_color_red
    echo "Install rebar3 (pre-built)"
    term_color_white

    wget -P /home/$LOGNAME/Downloads https://s3.amazonaws.com/rebar3/rebar3
    chmod +x /home/$LOGNAME/Downloads/rebar3

    sudo mkdir -p /usr/local/bin
    sudo rm -rf /usr/local/bin/rebar3
    sudo mv /home/$LOGNAME/Downloads/rebar3 /usr/local/bin
    # /usr/local/bin/rebar3 local install
}

check_installed_versions(){
    term_color_red
    echo "Check installed versions"
    term_color_white
    
    asdf current
    rebar3 --version
}

trap term_color_white EXIT
register_repo
confirmation
install_packages
install_packages_for_wx_debugger
install_erlang
install_rebar3
check_installed_versions 

echo
echo "Done"
echo

#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)"
  exit
fi

ERLANG_VERSION="25.0.4"
ELIXIR_VERSION="1.14.0-rc.1-otp-25"

term_color_red () {
    echo -e "\e[91m"
}

term_color_white () {
    echo -e "\e[39m"
}

confirmation(){
    term_color_red
    echo "Install Erlang & Elixir via ASDF"
    echo "- Check the compatible versions between Erlang and Elixir"
    echo "- https://hexdocs.pm/elixir/main/compatibility-and-deprecations.html#compatibility-between-elixir-and-erlang-otp "
    echo
    echo "Do you want to install? (y/n)"
    echo "- Erlang: $ERLANG_VERSION"
    echo "- Elixir: $ELIXIR_VERSION"
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

register_repos(){
    term_color_red
    echo "Register repos"
    term_color_white

    asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git
    asdf plugin add elixir https://github.com/asdf-vm/asdf-elixir.git
}

install_latest_versions(){
    term_color_red
    echo "Get the latest versions"
    term_color_white

    asdf install erlang $ERLANG_VERSION
    asdf install elixir $ELIXIR_VERSION 

    asdf global erlang $ERLANG_VERSION 
    asdf global elixir $ELIXIR_VERSION
}

check_installed_versions(){
    term_color_red
    echo "Check installed versions"
    term_color_white
    
    asdf current
}

install_hex(){
    term_color_red
    echo "Install Hex"
    term_color_white
    
    mix local.hex
}

install_phoenix(){
    term_color_red
    echo "Install Phoenix"
    term_color_white

    mix archive.install hex phx_new

    echo ""
    echo "Install Phoenix"
    echo "- mix archive.install hex phx_new"
    echo ""
    echo "Create & run a Phoenix app"
    echo "- mix phx.new hello"
    echo "- cd hello"
    echo "- mix ecto.create"
    echo "- mix deps.get"
    echo "- mix phx.server"
    echo ""
    echo "Don't forget to edit the config/dev.exs for:"
    echo "- PSQL credential"
    echo "- http for IP (0.0.0.0) for remote access"
    echo ""
}

trap term_color_white EXIT
confirmation
install_packages
register_repos
install_latest_versions
check_installed_versions 
install_hex 
install_phoenix

echo
echo "Done"
echo

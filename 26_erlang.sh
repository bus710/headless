#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]
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
    echo "Install Erlang and Elixir"
    term_color_white

    sudo apt-cache policy erlang
    #sudo apt-cache policy elixir

    term_color_red
    echo "Do you want to install? (y/n)"
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

install_erlang(){
    term_color_red
    echo "Install Erlang"
    term_color_white

    sudo apt install -y \
        erlang-wx

    sudo apt install -y \
        erlang"*" \
        rebar3

    #sudo apt install -y \
    #    elixir

    # To put some arguments for the erl shell.
    sed -i '/#ERL_0/c\export ERL_AFLAGS=\"+pc unicode -kernel shell_history enabled\"' /home/$LOGNAME/.shrc
}

config_rebar3(){
    term_color_red
    echo "Config rebar3"
    term_color_white

    rebar3 local install

    rm -rf /home/$LOGNAME/.config/rebar3/rebar.config
    mkdir -p /home/$LOGNAME/.config/rebar3
    echo "{plugins, [rebar3_hex]}." >> ~/.config/rebar3/rebar.config
}

install_hex(){
    term_color_red
    echo "Install hex"
    term_color_white

    mix local.hex --force

    # Install mix packages globaly
    mix archive.install hex --force credo
    mix archive.install hex --force bunt
    mix archive.install hex --force jason
    mix archive.install hex --force phx_new
}

check_installed_versions(){
    term_color_red
    echo "Check installed versions"
    term_color_white

    cat /usr/lib/erlang/releases/RELEASES
    echo
    rebar3 --version
    echo
    elixir --version
    echo
}

post () {
    term_color_red
    echo "Done"
    echo "- Make sure ~/.config/rebar3/rebar.config exists."
    term_color_white
}

trap term_color_white EXIT
confirmation
install_erlang
config_rebar3
#install_hex
#check_installed_versions
post


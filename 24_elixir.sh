#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)"
    exit
fi

ELIXIR_VERSION=""

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

    if [[ ! -d /home/$LOGNAME/.asdf/plugins/elixir ]]; then
        asdf plugin add elixir https://github.com/asdf-vm/asdf-elixir.git
    fi

    ELIXIR_VERSION=$(asdf latest elixir)
    # github API equivalent
    # curl -o- -s https://api.github.com/repos/elixir-lang/elixir/releases/latest | jq -r '.tag_name'
}

confirmation(){
    term_color_red
    echo "Install Elixir via ASDF"
    echo "Do you want to install? (y/n)"
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

install_elixir(){
    term_color_red
    echo "install elixir"
    term_color_white

    asdf install elixir $ELIXIR_VERSION
    asdf global elixir $ELIXIR_VERSION

    # To help Elixir_LS vscode extension.
    sudo rm -rf /usr/local/bin/elixir
    sudo ln -s /home/$LOGNAME/.asdf/shims/elixir /usr/local/bin/elixir
    sudo rm -rf /usr/local/bin/erl
    sudo ln -s /home/$LOGNAME/.asdf/shims/erl /usr/local/bin/erl

    # The inotify-tools package is installed
    # by the erlang installation script.
    # sudo apt install -y inotify-tools
}

install_hex(){
    term_color_red
    echo "install hex"
    term_color_white

    mix local.hex --version
}

check_installed_versions(){
    term_color_red
    echo "Check installed versions"
    term_color_white

    asdf current
}

post () {
    term_color_red
    echo "Done"
    term_color_white
}

trap term_color_white EXIT
register_repo
confirmation
install_elixir
install_hex
check_installed_versions
post

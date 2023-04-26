#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]; then
    echo "Please run as normal user (w/o sudo)"
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
    echo "Please check the website if there is a newer version"
    echo "- https://github.com/rust-lang/rust/releases"
    echo "- https://www.rust-lang.org/tools/install"
    echo
    echo "Do you want to install? (y/n)"
    term_color_white

    echo
    read -n 1 ans
    echo

    if [[ ! $ans == "y" ]]; then
        echo ""
        exit -1
    fi
}

install_rustup_cargo(){
    term_color_red
    echo "Install rustup"
    term_color_white

    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    source $HOME/.cargo/env

    term_color_red
    echo "See the version below"
    term_color_white

    rustc --version
    cargo --version

    term_color_red
    echo "Update Rust"
    term_color_white

    rustup update
    rustup upgrade

    term_color_red
    echo "Update Rust components"
    term_color_white

    rustup component add rustfmt clippy rls rust-analysis rust-src
}

configure_runcom(){
    term_color_red
    echo "Configure runcom"
    term_color_white

    if [[ -f /home/$LOGNAME/.cargo/bin/cargo ]]; then
        sed -i '/#RUST_0/c\export PATH=$HOME/.cargo/bin:$PATH' /home/$LOGNAME/.shrc
    fi
}

post(){
    term_color_red
    echo "Done - reload terminal"
    term_color_white

    #. /home/$LOGNAME/.shrc
}

trap term_color_white EXIT
confirmation
install_rustup_cargo
configure_runcom
post

# rustup default nightly
# rustup default nightly
# rustup update


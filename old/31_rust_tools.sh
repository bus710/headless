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

install_packages(){
    term_color_red
    echo "Some package for cargo tools"
    term_color_white

    sudo apt install -y pkg-config libssl-dev

    term_color_red
    echo "Some packages for LLVM and OpenCV"
    term_color_white

    sudo apt install -y \
        cmake \
        clang \
        ninja-build \
        libclang-dev

    term_color_red
    echo "Some packages for BlueZ"
    term_color_white

    sudo apt install -y \
        libdbus-1-dev

    term_color_red
    echo "Some packages for permissions"
    term_color_white

    sudo apt install -y \
        libudev-dev
}

build_cargo_tools(){
    term_color_red
    echo
    echo "Build some cargo tools"
    echo
    term_color_white

    # https://github.com/rust-lang/cargo/wiki/Third-party-cargo-subcommands
    cargo install cargo-watch
    cargo install cargo-deb
    cargo install cargo-edit
    cargo install cargo-outdated
    cargo install cargo-make
    #cargo install cbindgen
    #cargo install flutter_rust_bridge_codegen
    #cargo install bluer-tools
}

post(){
    term_color_red
    echo
    echo "Done"
    echo
    term_color_white
}

trap term_color_white EXIT
install_packages
build_cargo_tools
post

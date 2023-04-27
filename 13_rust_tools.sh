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
    echo "Build some cargo tools"
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

build_cargo_tools_2(){

    term_color_red
    echo "Build some cargo tools for desktop"
    echo "Do you want to install? (y/n)"
    term_color_white

    echo
    read -n 1 ans
    echo

    if [[ ! $ans == "y" ]]; then
        return
    fi


    # Tauri
    # - https://tauri.app/v1/guides/getting-started/setup/
    # - https://tauri.app/v1/guides/getting-started/prerequisites#setting-up-linux
    cargo install create-tauri-app
    cargo install tauri-cli
    sudo apt install -y \
        libwebkit2gtk-4.0-dev \
        build-essential \
        curl \
        wget \
        libssl-dev \
        libgtk-3-dev \
        libayatana-appindicator3-dev \
        librsvg2-dev

    # Rustlings
    # To start:
    # $ cd ~/repo/rustlings
    # $ rustlings watch
    #curl -L https://raw.githubusercontent.com/rust-lang/rustlings/main/install.sh | bash -s ~/repo/rustlings
}

post(){
    term_color_red
    echo "Done"
    term_color_white
}

trap term_color_white EXIT
install_packages
build_cargo_tools
build_cargo_tools_2
post

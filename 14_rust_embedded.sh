#!/bin/bash

# https://esp-rs.github.io/book/installation/index.html

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
    echo "Install ESP32 related packages"
    echo "Do you want to install? (y/n)"
    term_color_white

    echo
    read -n 1 ans
    echo

    if [[ ! $ans == "y" ]]; then
        echo ""
        exit -1
    fi

    sudo echo
}

install_nightly_toolchain(){
    term_color_red
    echo "Nightly toolchain"
    term_color_white

    rustup toolchain install nightly --component rust-src
}

configure_target(){
    term_color_red
    echo "Configure target"
    term_color_white

    # For no_std
    rustup target add riscv32imc-unknown-none-elf # For ESP32-C2 and ESP32-C3
    rustup target add riscv32imac-unknown-none-elf # For ESP32-C6 and ESP32-H2

    # For std, but no need to install
    #rustup target add riscv32imc-esp-espidf
}

install_packages(){
    term_color_red
    echo "Some packages for LLVM"
    term_color_white

    sudo apt install -y \
        llvm-dev libclang-dev clang
}

build_cargo_tools(){
    term_color_red
    echo "Build some cargo tools"
    term_color_white

    cargo install cargo-espflash
    cargo install espflash
    cargo install cargo-espmonitor
    cargo install espmonitor
    cargo install ldproxy
    cargo install cargo-generate
    #cargo install espup

    cargo install --list
}

post(){
    term_color_red
    echo "Done"
    term_color_white
}

trap term_color_white EXIT
confirmation
install_nightly_toolchain
configure_target
install_packages
build_cargo_tools
post

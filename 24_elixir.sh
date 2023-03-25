#!/bin/bash

set -e

CPU_TYPE=$(uname -m)
CPU_TARGET=""

if [[ $CPU_TYPE == "x86_64" ]]; then
    CPU_TARGET="amd64"
    elif [[ $CPU_TYPE == "aarch64" ]]; then
    CPU_TARGET="arm64"
else
    exit
fi

VERSION=$(curl --silent https://github.com/elixir-lang/elixir/releases/latest \
| grep -oP '(?<=/v)[^">]+')

echo $VERSION

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)"
    exit
fi

echo
echo -e "\e[91m"
echo "Please check the website if there is a newer version"
echo "- https://github.com/elixir-lang/elixir/releases/latest"
echo
echo "1. /usr/local/elixir will be deleted"
echo "2. Elixir v${VERSION} will be installed"
echo
echo "Do you want to install? (y/n)"
echo -e "\e[39m"
echo

echo
read -n 1 ans
echo

if [[ $ans == "y" ]]
then
    echo
    echo "Install Erlang"
    echo

    sudo apt install -y erlang

    echo
    echo "Existing Elixir directory will be deleted"
    echo

    sudo bash -c "rm -rf /usr/local/elixir"

    echo
    echo "Download and install Elixir source"
    echo

    # Remove if there is any tarballs
    echo
    rm -rf v${VERSION}.tar.gz*
    echo

    wget https://github.com/elixir-lang/elixir/archive/refs/tags/v${VERSION}.tar.gz

    echo
    echo "Wait for untar..."
    echo

    tar -xf v${VERSION}.tar.gz
    rm -rf v${VERSION}.tar.gz

    echo
    echo "Build..."
    echo

    mv elixir-${VERSION} elixir
    cd elixir
    make
    cd ..

    echo
    echo "Move the elixir directory to /usr/local"
    echo

    sudo bash -c "mv elixir /usr/local/"

    echo
    echo "Done"
    echo
fi

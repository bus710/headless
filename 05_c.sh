#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)"
  exit
fi

echo
echo -e "\e[91m"
echo "This is for C programming with LLVM and Cmake."
echo "For more information, please check https://apt.llvm.org/"
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
    echo "Install packages"
    echo 

    sudo apt install -y \
        clang \
        clangd \
        clang-tools \
        clang-format \
        lldb \
        lld 

    sudo apt install -y \
        cmake \
        ninja-build

    sudo apt install -y \
        kore

    echo 
    echo "Done"
    echo
fi

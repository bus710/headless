#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)"
  exit
fi

echo
echo -e "\e[91m"
echo "This is for C programming with GCC and Cmake."
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
        make \
        cmake \
        ninja-build \
        build-essential

    sudo apt install -y \
        kore

    echo 
    echo "Done"
    echo
fi

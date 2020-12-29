#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)"
  exit
fi

echo
echo -e "\e[91m"
echo "This is for C programming with LLVM and Cmake."
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
    echo "Existing Go directories will be deleted"
    echo 

    sudo apt install -y \
        clang \
        cmake \
        ninja-build 

    echo 
    echo "Done"
    echo
fi

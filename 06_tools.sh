#!/bin/bash

set -e

# This is splitted from Golang installation because 

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)" 
  exit
fi

CPU_TYPE=$(uname -p)

if [[ "$CPU_TYPE" == "x86_64" ]]; then
    echo 
    echo "Install ripgrep"
    echo

    sudo add-apt-repository ppa:x4121/ripgrep
    sudo apt-get update
fi

echo 
echo "Install range-fm"
echo

pip3 install --user -U ranger-fm

echo 
echo "Install dlv"
echo 

go get -u github.com/go-delve/delve/cmd/dlv

echo
echo "Install goexec"
echo

go get -u github.com/shurcooL/goexec

echo
echo "Install vim-go plugins"
nvim -c :GoInstallBinaries
echo

echo
echo "Done"
echo

#!/bin/bash

set -e

# This is splitted from Golang installation because 

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)" 
  exit
fi

CPU_TYPE=$(uname -p)

if [[ "$CPU_TYPE" == "x86_64" ]]; then
    echo "" # for future
fi

echo 
echo "Install dlv"
echo 

go get -u github.com/go-delve/delve/cmd/dlv

echo
echo "Install goexec"
echo

go get -u github.com/shurcooL/goexec

echo
echo "Install wasmserve"
echo

go get -u github.com/hajimehoshi/wasmserve

echo
echo "Install vim-go plugins"
echo

nvim -c :GoInstallBinaries

echo
echo "Done"
echo

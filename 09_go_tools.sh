#!/bin/bash

set -e

# This is splitted from Golang installation because 

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)" 
  exit
fi

CPU_TYPE=$(uname -m)

if [[ "$CPU_TYPE" == "x86_64" ]]; then
    echo "" # for future
fi

echo 
echo "Install basic tools, dlv, goexec, wasmserve, swaggo"
echo 

go get -u golang.org/x/tools/...
go get -u github.com/go-delve/delve/cmd/dlv
go get -u github.com/shurcooL/goexec
go get -u github.com/hajimehoshi/wasmserve
go get -u github.com/swaggo/swag/cmd/swag
go get -u github.com/google/gops

echo
echo "Install vim-go plugins"
echo

nvim -c :GoInstallBinaries

echo
echo "Done"
echo

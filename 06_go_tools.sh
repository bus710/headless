#!/bin/bash

# This is splitted from Golang installation because 

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)" 
  exit
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
echo "Install vim-go plugins"
nvim -c :GoInstallBinaries
echo

echo
echo "Done"
echo

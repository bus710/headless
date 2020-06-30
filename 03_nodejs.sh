#!/bin/bash

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)"
  exit
fi

curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt install -y nodejs

echo
echo "What is done?"
echo "- curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -"
echo "- sudo apt install -y nodejs"
echo


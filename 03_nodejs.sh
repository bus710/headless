#!/bin/bash

if [ "$EUID" != 0 ]
then echo "Please run as the super user (w/ sudo)"
  exit
fi

curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
apt install -y nodejs

echo
echo "What is done?"
echo "- sudo curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -"
echo "- sudo apt install -y nodejs"
echo


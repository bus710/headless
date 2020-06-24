#!/bin/bash

if [ "$EUID" != 0 ]
then echo "Please run as the super user (w/ sudo)"
  exit
fi

add-apt-repository ppa:peek-developers/stable
apt update
apt install -y peek

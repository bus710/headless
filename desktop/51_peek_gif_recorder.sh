#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]; then 
    echo "Please run as normal user (w/o sudo)"
    exit
fi


sudo add-apt-repository ppa:peek-developers/stable
sudo apt update
sudo apt install -y \
    peek

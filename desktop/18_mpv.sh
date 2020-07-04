#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)"
  exit
fi

sudo add-apt-repository ppa:mc3man/mpv-tests

sudo apt-get install -y \
    mpv

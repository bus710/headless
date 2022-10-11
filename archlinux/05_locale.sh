#!/bin/bash

set -e

sed -i '/#en_US.UTF-8 UTF-8/c\en_US.UTF-8 UTF-8' /etc/locale.gen
locale-gen

export LANG=en_US.UTF-8
echo "LANG-en_US.UTF-8" > /etc/locale.conf


echo 
echo "Please change hostname"
echo

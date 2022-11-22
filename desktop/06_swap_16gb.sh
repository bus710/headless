#!/bin/bash

# https://bogdancornianu.com/change-swap-size-in-ubuntu/

if [[ "$EUID" == 0 ]]; then 
    echo "Please run as normal user (w/o sudo)" 
    exit
fi

CPU_TYPE=$(uname -a)

if [[ "$CPU_TYPE" =~ "x86_64" ]]; then
    echo
    echo "Swap off"
    echo

    sudo swapoff -a

    echo
    echo "Create a 16GB swapfile (/swapfile)"
    echo "This takes ~30 seconds"
    echo

    sudo dd if=/dev/zero of=/tmp/swapfile bs=1G count=16 
    sudo mkswap /tmp/swapfile
    sudo chmod 600 /tmp/swapfile

    echo
    echo "Swap on"
    echo

    sudo swapon /tmp/swapfile

    echo
    echo "Swap status"
    echo

    grep SwapTotal /proc/meminfo

    echo
    echo "Done - add the line below to /etc/fatab"
    echo "/tmp/swapfile    none    swap    sw    0    0"
    echo
else
    echo "CPU type is ${CPU_TYPE}"
fi

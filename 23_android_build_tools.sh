#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]
then echo "Please run as a normal user (w/o sudo)"
  exit
fi

echo
echo -e "\e[91m"
echo "Android platform-tools and build-tools will be installed"
echo
echo "Do you want to install? (y/n)"
echo -e "\e[39m"
echo

echo
read -n 1 ans
echo

if [[ $ans == "y" ]]
then 
    echo
    echo "Install build tools"
    echo 

    sdkmanager --version
    sdkmanager --list

    echo

    sdkmanager "platform-tools" "platforms;android-29"

    echo

    sdkmanager "build-tools;29.0.3"

    echo
    echo License confirmation
    echo

    sdkmanager --licenses

    echo
fi

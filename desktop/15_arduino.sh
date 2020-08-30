#!/bin/bash

set -e


VERSION_IDE="arduino-pro-ide_0.1.1_Linux_64bit"



if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)"
  exit
fi

echo
echo -e "\e[91m"
echo "Please check these web sites:"
echo "- https://github.com/arduino/arduino-cli/releases/latest"
echo "- https://github.com/arduino/arduino-pro-ide/releases/latest"
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
    echo "Existing Arduino directory will be deleted"
    echo 

    rm -rf $HOME/Arduino
    mkdir -p $HOME/Arduino/tools/arduino-cli

    echo
    echo "Download and install Arduino CLI"
    echo 

    cd $HOME/Arduino/tools/arduino-cli
    curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | sh

    echo
    echo "Download and install Arduino IDE"
    echo 

    cd $HOME/Arduino/tools
    wget https://downloads.arduino.cc/arduino-pro-ide/${VERSION_IDE}.zip
    unzip -q ${VERSION_IDE}.zip 
    mv ${VERSION_IDE} arduino-pro-ide
    rm -rf *.zip

    echo
    echo "Add path"
    echo 

    echo "" >> $HOME/.shrc
    echo "# For Arduino SDK" >> $HOME/.shrc
    echo "PATH=\$PATH:\$HOME/Arduino/tools/arduino-cli/bin" >> $HOME/.shrc
    echo "PATH=\$PATH:\$HOME/Arduino/tools/arduino-pro-ide" >> $HOME/.shrc

    echo 
    echo "Done."
    echo "Please source .shrc"
    echo
fi

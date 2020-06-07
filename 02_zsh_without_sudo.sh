#!/bin/bash

# - https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH
# - https://ohmyz.sh/


if [ "$EUID" == 0 ]
then echo "Please run without sudo" 
  exit
fi

echo
echo -e "\e[91m"
echo "Zsh will be installed"
echo "Existing zshrc will be deleted and installed again"
echo 
echo "Do you want to install? (y/n)"
echo -e "\e[39m"
echo

read -n 1 ans
echo

if [ $ans == "y" ]
then
    # Get logname first (this is not $USER)
    LOGNAME="$(logname)"

    echo -e "\e[91m"
    echo "Delete ~/.zshrc"
    echo "Delete ~/.oh-my-zsh"
    echo -e "\e[39m"

    rm /home/$LOGNAME/.zshrc
    rm /home/$LOGNAME/.oh-my-zsh -rf

    echo -e "\e[91m"
    echo "OMZ install"
    echo -e "\e[39m"

    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    echo -e "\e[91m"
    echo "Apply zsh"
    echo -e "\e[39m"

    chsh -s $(which zsh)

    echo "source /home/$LOGNAME/.shrc" >> /home/$LOGNAME/.zshrc
    source /home/$LOGNAME/.zshrc
fi

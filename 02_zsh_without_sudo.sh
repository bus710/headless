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
    echo "OMZ install (w/ RUNZSH=no)"
    echo -e "\e[39m"

    export RUNZSH=no

    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    echo -e "\e[91m"
    echo "chsh -s $(which zsh) (need password)"
    echo -e "\e[39m"

    chsh -s $(which zsh)

    echo -e "\e[91m"
    echo "Make zshrc to source shrc"
    echo -e "\e[39m"

    echo "" >> /home/$LOGNAME/.zshrc # for space 
    echo "source /home/$LOGNAME/.shrc" >> /home/$LOGNAME/.zshrc

    echo -e "\e[91m"
    echo "Powerlevel10k install"
    echo "  - to enable: ZSH_THEME=\"powerlevel10k/powerlevel10k\""
    echo "  - to config: p10k configure"
    echo -e "\e[39m"

    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k

    echo -e "\e[91m"
    echo "Zsh-autosuggestions install"
    echo -e "\e[39m"

    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

    echo -e "\e[91m"
    echo "1. Add plugins for:"
    echo "     git golang flutter zsh-autosuggestions"
    echo "2. Enable theme"
    echo "3. Reload terminal"
    echo "4. Config p10k prompt"
    echo -e "\e[39m"
fi


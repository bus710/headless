#!/bin/bash

set -e

# - https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH
# - https://ohmyz.sh/


if [[ "$EUID" == 0 ]]; then 
    echo "Please run without sudo" 
    exit
fi

term_color_red () {
    echo -e "\e[91m"
}

term_color_white () {
    echo -e "\e[39m"
}

confirmation(){
    term_color_red
    echo "Zsh will be installed"
    echo "Existing zshrc will be deleted and installed again"
    echo 
    echo "Do you want to install? (y/n)"
    term_color_white
    echo
    read -n 1 ans
    echo

    if [[ ! $ans == "y" ]]; then
        exit -1
    fi
}

cleanup(){
    term_color_red
    echo
    echo "Delete /home/$LOGNAME/.zshrc"
    echo "Delete /home/$LOGNAME/.oh-my-zsh"
    echo
    term_color_white

    rm -rf /home/$LOGNAME/.zshrc
    rm -rf /home/$LOGNAME/.oh-my-zsh
}

install_omz (){
    term_color_red
    echo "OMZ install (w/ RUNZSH=no)"
    term_color_white

    export RUNZSH=no

    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    cp /home/$LOGNAME/.oh-my-zsh/templates/zshrc.zsh-template /home/$LOGNAME/.zshrc

    term_color_red
    echo "chsh -s $(which zsh) (<= need password)"
    term_color_white

    chsh -s $(which zsh)

    term_color_red
    echo "Make zshrc to source shrc"
    term_color_white

    SHRC=$(cat /home/$LOGNAME/.zshrc | grep "\\.shrc" | wc -l)
    if [[ ! $SHRC == "1" ]]; then
        echo "" >> /home/$LOGNAME/.zshrc # for space 
        echo "source /home/$LOGNAME/.shrc" >> /home/$LOGNAME/.zshrc
    fi
}

install_plugins(){
    term_color_red
    echo "Powerlevel10k install"
    echo "  - to enable: ZSH_THEME=\"powerlevel10k/powerlevel10k\""
    echo "  - to config: p10k configure"
    term_color_white

    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k

    term_color_red
    echo "Zsh-autosuggestions install"
    term_color_white

    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

    term_color_red
    echo "Update zshrc"
    echo "  - Add plugins to .zshrc (git golang flutter zsh-autosuggestions)"
    echo "  - Enable theme (powerlevel10k)"
    term_color_white

    sed -i 's/plugins=(git)/plugins=(git golang flutter zsh-autosuggestions)/g' /home/$LOGNAME/.zshrc
    sed -i 's/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"powerlevel10k\/powerlevel10k\"/g' /home/$LOGNAME/.zshrc
}

post(){
    term_color_red
    echo "Please reboot and run 'p10k prompt'"
    echo "(For cloud platforms, edit /etc/pam.d/chsh - required to sufficient)"
    echo
    echo "Done"
    echo
    term_color_white
}

trap term_color_white EXIT
confirmation
cleanup
install_omz
install_plugins
post

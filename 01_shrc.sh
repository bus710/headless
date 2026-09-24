#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]; then
    echo "Please run as normal user (w/o sudo)"
    exit
fi

term_color_red () {
    echo -e "\e[91m"
}

term_color_white () {
    echo -e "\e[39m"
}

confirmation (){
    term_color_red
    echo ""
    echo "Update .shrc"
    echo "Do you want to update? (y/n)"
    echo ""
    term_color_white
    
    echo
    read -n 1 ans
    echo
    
    if [[ ! $ans == "y" ]]; then
        echo
        exit 1
    fi
}

update (){
    term_color_red
    echo ""
    echo "Update"
    echo ""
    term_color_white

    if [[ -f /home/$LOGNAME/.shrc ]]; then
        if diff -q /home/$LOGNAME/.shrc dotfiles/01_shrc > /dev/null; then
            echo "~/.shrc is already up to date"
        else
            term_color_red
            echo "Changes to ~/.shrc (- current, + repo):"
            term_color_white
            diff -u --color=auto /home/$LOGNAME/.shrc dotfiles/01_shrc || true

            term_color_red
            echo ""
            echo "Lines only in ~/.shrc (-) will be lost. Overwrite? (y/n)"
            term_color_white
            read -n 1 ans
            echo
            if [[ ! $ans == "y" ]]; then
                exit 1
            fi
        fi
    fi

    cp dotfiles/01_shrc /home/$LOGNAME/.shrc

    SHRC=$(cat /home/$LOGNAME/.bashrc | grep "\\.shrc" | wc -l)
    if [[ ! $SHRC == "1" ]]; then
        echo "" >> /home/$LOGNAME/.bashrc
        echo "source /home/$LOGNAME/.shrc" >> /home/$LOGNAME/.bashrc
        source /home/$LOGNAME/.bashrc
    fi
}

post (){
    term_color_red
    echo
    echo "Done"
    echo "- Restart terminal"
    echo "- If SwayWM, run the gnome keyring script again"
    echo "- If SwayWM, uncomment the keychain part of the .shrc and the personal dotenv repo"
    echo "- Check at the end of the shrc and the .env file"
    echo
    term_color_white
}

trap term_color_white EXIT
confirmation
update
post

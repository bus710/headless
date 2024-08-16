#!/bin/bash

set -e

CPU_TYPE=$(uname -m)
OS_TYPE=$(lsb_release -i)

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
    
    rm -rf /home/$LOGNAME/.shrc
    cat shrc >> /home/$LOGNAME/.shrc
    chown $LOGNAME:$LOGNAME /home/$LOGNAME/.shrc
    
    SHRC=$(cat /home/$LOGNAME/.bashrc | grep "\\.shrc" | wc -l)
    if [[ ! $SHRC == "1" ]]; then
        echo "" >> /home/$LOGNAME/.bashrc
        echo "source /home/$LOGNAME/.shrc" >> /home/$LOGNAME/.bashrc
        source /home/$LOGNAME/.bashrc
    fi
}

configure_runcom(){
    term_color_red
    echo ""
    echo "Activate extra runcoms"
    echo ""
    term_color_white
    
    # Neovim
    if [[ -f /usr/bin/nvim ]]; then
        echo "Activate Neovim"
        sed -i '/#NVIM_0/c\export PATH=\$PATH:$HOME/.tools' /home/$LOGNAME/.shrc
    fi

    # Go  
    if [[ -f /usr/local/go/bin/go ]]; then
        echo "Activate Go"
        sed -i '/#GO_0/c\export GOROOT=\/usr\/local\/go' /home/$LOGNAME/.shrc
        sed -i '/#GO_1/c\export GOPATH=\$HOME\/go' /home/$LOGNAME/.shrc
        sed -i '/#GO_2/c\export PATH=$PATH:\$GOROOT/bin:\$GOPATH/bin' /home/$LOGNAME/.shrc
        sed -i '/#GO_3/c\export DELVE_EDITOR=nvim' /home/$LOGNAME/.shrc
    fi

    # Flutter
    if [[ -f /home/$LOGNAME/flutter/bin/flutter ]]; then
        echo "Activate Flutter"
        sed -i '/#FLUTTER_0/c\export PATH=\$PATH:\$HOME\/flutter\/bin' /home/$LOGNAME/.shrc
        sed -i '/#FLUTTER_1/c\export PATH=\$PATH:\$HOME\/flutter\/bin\/cache\/dart-sdk\/bin' /home/$LOGNAME/.shrc
        sed -i '/#FLUTTER_2/c\export PATH=\$PATH:\$HOME\/flutter\/.pub-cache\/bin' /home/$LOGNAME/.shrc
        sed -i '/#FLUTTER_3/c\export PATH=\$PATH:\$HOME\/repo\/flutter\/bin' /home/$LOGNAME/.shrc # embedded 
    fi

    # Rust
    if [[ -f /home/$LOGNAME/.cargo/bin/cargo ]]; then
        echo "Activate Rust"
        sed -i '/#RUST_0/c\export PATH=\$PATH:$HOME/.cargo/bin' /home/$LOGNAME/.shrc
    fi

    # AWS cli
    if [[ -f /usr/local/bin/aws ]]; then
        echo "Activate AWS CLI"
        sed -i '/#AWS_0/c\\texport PATH=\$PATH:\/usr\/local\/bin\/aws_completer' /home/$LOGNAME/.shrc
        sed -i '/#AWS_1/c\\tautoload bashcompinit && bashcompinit' /home/$LOGNAME/.shrc
        sed -i '/#AWS_2/c\\tautoload -Uz compinit && compinit' /home/$LOGNAME/.shrc
        sed -i '/#AWS_3/c\\tcomplete -C \"\/usr\/local\/bin\/aws_completer\" aws' /home/$LOGNAME/.shrc
    fi
    
    # Android if exists
    if [[ -d /home/$LOGNAME/Android ]]; then
        echo "Activate Android SDK"
        sed -i "/#ANDROID_0/c\export JAVA_HOME=\$HOME\/Android\/android-studio\/jre" "/home/$LOGNAME/.shrc"
        sed -i '/#ANDROID_1/c\export PATH=\$JAVA_HOME\/bin:\$PATH' /home/$LOGNAME/.shrc
        sed -i '/#ANDROID_2/c\export PATH=\$HOME\/Android\/android-studio\/bin:\$PATH' /home/$LOGNAME/.shrc
        sed -i '/#ANDROID_3/c\export ANDROID_SDK_ROOT=\$HOME\/Android' /home/$LOGNAME/.shrc
        sed -i '/#ANDROID_4/c\export PATH=\$HOME\/Android\/cmdline-tools\/latest\/bin:\$PATH' /home/$LOGNAME/.shrc
        sed -i '/#ANDROID_5/c\export PATH=\$HOME\/Android\/platform-tools:\$PATH' /home/$LOGNAME/.shrc
    fi
    
    # ASDF if exists
    if [[ -d /home/$LOGNAME/.asdf ]]; then
        echo "Activate ASDF"
        sed -i '/#ASDF_0/c\. $HOME\/.asdf\/asdf.sh' /home/$LOGNAME/.shrc
        sed -i '/#ASDF_1/c\fpath=($HOME\/.asdf\/completions $fpath)' /home/$LOGNAME/.shrc
        sed -i '/#ASDF_2/c\autoload -Uz compinit && compinit' /home/$LOGNAME/.shrc
    fi

    # ERL/erl args if exists
    if [[ -d /home/$LOGNAME/.asdf/shims/erl ]]; then
        echo "Activate ERL args"
        sed -i '/#ERL_0/c\export ERL_AFLAGS=\"+pc unicode -kernel shell_history enabled\"' /home/$LOGNAME/.shrc
    fi

    # Flyctl if exists
    if [[ -f /home/$LOGNAME/.fly/bin/flyctl ]]; then
        echo "Activate flyctl"
        sed -i '/#FLYCTL_0/c\export FLYCTL_INSTALL="\/home\/$LOGNAME\/.fly"' /home/$LOGNAME/.shrc
        sed -i '/#FLYCTL_1/c\export PATH="$FLYCTL_INSTALL\/bin:$PATH"' /home/$LOGNAME/.shrc
    fi

    # Zig if exists
    if [[ -f /home/$LOGNAME/zig/zig ]]; then 
        echo "Activate Zig"
        sed -i '/\#ZIG_0/c\export PATH=$PATH:\/home\/$LOGNAME\/zig' /home/$LOGNAME/.shrc
    fi

    # Terraform if exists
    if [[ -f /usr/local/bin/terraform ]]; then
        echo "Activate Terraform auto-completion"
        sed -i '/#TERRAFORM_0/c\autoload -U +X bashcompinit && bashcompinit' /home/$LOGNAME/.shrc
        sed -i '/#TERRAFORM_1/c\complete -o nospace -C \/usr\/local\/bin\/terraform terraform' /home/$LOGNAME/.shrc
    fi
}

post (){
    term_color_red
    echo
    echo "Done"
    echo "- Restart terminal"
    echo "- If SwayWM, run the gnome keyring script again"
    echo
    term_color_white
}

trap term_color_white EXIT
confirmation
update
configure_runcom
post

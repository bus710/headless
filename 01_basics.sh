#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)"
  exit
fi

echo -e "\e[91m"
echo "Start installing some basic packages"
echo
echo "Do you want to install? (y/n)"
echo -e "\e[39m"

echo
read -n 1 ans
echo

if [[ $ans == "y" ]]
then 
    echo
    echo "Install basics"
    echo

    sudo apt update

    sudo apt install -y \
    	zsh \
        vim \
        git \
        htop \
        tmux \
        curl \
        tree \
        make \
        cmake \
        iotop \
        unzip \
        sqlite3 \
        minicom \
        keychain \
        neofetch \
        powerline \
        build-essential \
        exuberant-ctags \
        bash-completion \
        command-not-found

    sudo apt install -y \
        jq \
        fzf \
        ranger \
        ripgrep

    echo
    echo "Install network packages"
    echo

    sudo apt install -y \
        ufw \
        bmon \
        nmap \
        sshfs \
        fail2ban \
        net-tools \
        wireless-tools \

    echo
    echo "Install for nvim"
    echo

    sudo apt install -y \
        python3-dev

    echo
    echo "Install some daemons"
    echo

    # For daemons required
    sudo apt install -y \
        openssh-server \
        avahi-daemon \
        avahi-utils

    echo
    echo "Install for docker"
    echo

    # For Docker
    sudo apt install -y \
        gnupg-agent \
        apt-transport-https \
        ca-certificates \
        software-properties-common

    # RPi related
    CPU_TYPE=$(uname -p)

    if [[ $CPU_TYPE == "x86_64" ]]; then
        echo
        echo "Install for Flutter SDK"
        echo

        sudo apt install -y lib32stdc++6
    elif [[ $CPU_TYPE == "aarch64" ]]; then
        echo
        echo "Install basics for RPi"
        echo

        sudo apt install -y \
            bluez \
            bluetooth \
            bluez-tools \
            pi-bluetooth
        sudo systemctl enable bluetooth.service
        sudo systemctl start bluetooth.service
        sudo usermod -aG bluetooth ubuntu
                    
        echo
        echo "Disable networkd wait"
        echo
        # to check boot delay                  
        # systemd-analyze blame                
        # to eliminate boot delay              
        sudo systemctl disable systemd-networkd-wait-online.service
        sudo systemctl mask systemd-networkd-wait-online.service
    fi

    echo
    echo "Config bash/zsh"
    echo

    # To apply Go/Flutter SDK path to the PATH variable
    rm -rf /home/$LOGNAME/.shrc
    cat shrc >> /home/$LOGNAME/.shrc
    chown $LOGNAME:$LOGNAME /home/$LOGNAME/.shrc

    echo "" >> /home/$LOGNAME/.bashrc
    echo "source /home/$LOGNAME/.shrc" >> /home/$LOGNAME/.bashrc
    source /home/$LOGNAME/.bashrc

    echo
    echo "Config tmux"
    echo

    # To apply ^a shortcut to the tmux config
    cat tmux.conf >> /home/$LOGNAME/.tmux.conf
    chown $LOGNAME:$LOGNAME /home/$LOGNAME/.tmux.conf

    echo
    echo "Cleanup"
    echo 

    sudo apt autoremove -y

    echo
    echo "Change sshd port"
    echo
    # sudo sed -i 's/Port 22/Port 2222/g' /etc/ssh/sshd_config
    sudo bash -c "sed -i '/#Port 22/c\Port 2222' /etc/ssh/sshd_config"
    # Also, "UseDNS no" should be uncommented if sshd is too slow

    echo -e "\e[91m"
    echo "1. SSH port number is changed"
    echo "2. Source your .bashrc (source ~/.bashrc)"
    echo "3. Check your .tmux.conf"
    echo "4. Try neofetch --ascii_distro Kubuntu|Xubuntu|Lubuntu"
    echo -e "\e[39m"
fi

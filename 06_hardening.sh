#!/bin/bash

SSH_PORT="2222"

if [ "$EUID" != 0 ]
then echo "Please run as the super user (w/ sudo)"
  exit
fi

echo 
echo "This will enable/start these services:"
echo "  1. sshd (port $SSH_PORT)"
echo "  2. avahi"
echo "  3. ufw (and it adds the poicies to deny almost everything)"
echo 
echo "Do you want to run it? (y/n)"
echo

read -n 1 ans
echo

if [ $ans == "y" ]
then
    systemctl enable ssh.service 
    systemctl start ssh.service 

    systemctl enable avahi-daemon.service 
    systemctl start avahi-daemon.service 

    apt install -y ufw

    ufw allow $SSH_PORT/tcp
    ufw allow 80
    ufw allow 443
    ufw default deny incoming
    ufw default allow outgoing
    ufw enable
    ufw status verbose

    echo 
    echo "!! UFW is enabled !!"
fi

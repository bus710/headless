#!/bin/bash

SSH_PORT="2222"

if [ "$EUID" != 0 ]
then echo "Please run as the super user (w/ sudo)"
  exit
fi

echo 
echo -e "\e[91m"
echo "This will enable/start these services:"
echo "  1. sshd (port $SSH_PORT)"
echo "  2. avahi"
echo "  3. ufw (and it adds the policies to deny almost everything)"
echo -e "\e[39m"
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

    ufw allow $SSH_PORT/tcp
    ufw allow 123
    ufw allow 53
    ufw allow git

    ufw allow in http
    ufw allow out http
    ufw allow in https
    ufw allow out https

    ufw default deny incoming
    ufw default allow outgoing
    ufw status verbose
    ufw enable

    echo 
    echo "!! UFW is enabled !!"
fi

#!/bin/bash

set -e

SSH_PORT="2222"

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)"
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

echo
read -n 1 ans
echo

if [[ $ans == "y" ]]
then
    sudo systemctl enable ssh.service 
    sudo systemctl start ssh.service 

    sudo systemctl enable avahi-daemon.service 
    sudo systemctl start avahi-daemon.service 

    sudo systemctl enable fail2ban
    sudo systemctl start fail2ban

    sudo ufw allow $SSH_PORT/tcp
    sudo ufw allow 123
    sudo ufw allow 53
    sudo ufw allow git

    sudo ufw allow in http
    sudo ufw allow out http
    sudo ufw allow in https
    sudo ufw allow out https

    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    sudo ufw status verbose
    sudo ufw enable

    echo 
    echo "Consider PSAD"
    echo 
    echo "UFW is enabled"
    echo "- iptables -L"
    echo "- ufw status verbose"
    echo 
    echo "Fail2ban is enabled"
    echo "- https://help.ubuntu.com/community/Fail2ban"
    echo "- cp /etc/fail2ban/jail.conf jail.local"
    echo "- tail -f /var/log/fail2ban.log"
    echo 
fi

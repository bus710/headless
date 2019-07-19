#!/bin/bash

echo
echo "DID YOU CHANGE THE SSH PORT NUMBER??"
echo

echo
echo "Press ^c to cancel in 5 seconds."
echo

for i in {5..0}
do 
	sleep 1
	echo "$i"
done

echo

# Disable the installed services for now
#sudo systemctl disable ssh.service 
#sudo systemctl stop ssh.service 
echo 
echo "!! PLEASE CHANGE OPENSSH PORT and RELOGIN !!"

sudo systemctl disable avahi-daemon.service 
sudo systemctl stop avahi-daemon.service 

sudo apt install -y ufw

sudo ufw allow 2222/tcp
sudo ufw allow 80
sudo ufw allow 443
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable
sudo ufw status verbose

echo 
echo "!! UFW is enabled !!"

#!/bin/bash

echo
echo "Add bus710"
echo

useradd -m -g users -G wheel -s /bin/zsh bus710

echo
echo "Enter password"
echo

passwd bus710

# allow wheel group to access sudo 
# uncomment "%wheel ALL=(ALL) ALL"
sed -i '/# %wheel ALL=(ALL) ALL/c\\%wheel ALL=(ALL) ALL' /etc/sudoers


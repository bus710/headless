#!/bin/bash

useradd -m -g users -G wheel -s /bin/bash bus710
passwd bus710

# allow wheel group to access sudo 
# uncomment "%wheel ALL=(ALL) ALL"
sed -i '/# %wheel ALL=(ALL) ALL/c\\%wheel ALL=(ALL) ALL' /etc/sudoers

#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)"
  exit
fi

if [[ $XDG_CURRENT_DESKTOP =~ "ubuntu:GNOME" ]]; then
    # WM theme
    git clone https://github.com/Jannomag/Yaru-Colors
    cd Yaru-Colors
    ./install.sh
    cd ..
    rm -rf Yaru-Colors

    # Terminal theme
    sudo apt install -y \
        dconf-cli
    git clone https://github.com/GalaticStryder/gnome-terminal-colors-dracula
    cd gnome-terminal-colors-dracula
    ./install.sh
    cd ..
    rm -rf gnome-terminal-colors-dracula*

elif [[ $XDG_CURRENT_DESKTOP =~ "XFCE" ]]; then
    # WM theme
    rm -rf ~/.local/share/themes
    mkdir ~/.local/share/themes
    git clone https://github.com/tdloi/nanodesu-xfwm4
    cp -r nanodesu-xfwm4/nanodesu* ~/.local/share/themes/
    rm -rf nanodesu-xfwm4
    # Change WM theme in settings => Window Manager

    # Theme
    rm -rf ~/.themes/Ant-Dracula-Blue
    git clone https://github.com/Michedev/Ant-Dracula-Blue.git
    mv Ant-Dracula-Blue ~/.themes/
    gsettings set org.gnome.desktop.interface gtk-theme "Ant-Dracula-Blue"

    # Terminal
    rm -rf ~/.local/share/xfce4/terminal/colorschemes
    mkdir -p ~/.local/share/xfce4/terminal/colorschemes
    git clone https://github.com/kuangyujing/dracula-xfce4-terminal
    cd dracula-xfce4-terminal
    cp Dracula.theme ~/.local/share/xfce4/terminal/colorschemes/
    cd ..
    rm -rf dracula-xfce4-terminal

    # Icons
    git clone https://github.com/vinceliuice/Qogir-icon-theme
    cd Qogir-icon-theme 
    ./install.sh
    cd ..
    rm -rf Qogir-icon-theme 

    # Dock
    sudo apt install -y plank
    PLANK_DESKTOP="/home/$LOGNAME/.config/autostart/plank.desktop"
    if [[ ! -d ~/.config/autostart ]]; then
        mkdir ~/.config/autostart -p                  
    fi                                                
    rm -rf $PLANK_DESKTOP
    echo "[Desktop Entry]" >> $PLANK_DESKTOP
    echo "Type=Application" >> $PLANK_DESKTOP
    echo "Exec=plank" >> $PLANK_DESKTOP
    echo "Hidden=false" >> $PLANK_DESKTOP
    echo "NoDisplay=false" >> $PLANK_DESKTOP
    echo "X-GNOME-Autostart-enabled=true" >> $PLANK_DESKTOP
    echo "Name=Plank" >> $PLANK_DESKTOP

    # Disable Caps lock
    sudo bash -c "echo 'XKBOPTIONS=ctrl:nocaps' >> /etc/default/keyboard"

    echo 
    echo "1. Change wm theme, color theme, icon, font size"
    echo "2. Change language and power config"
    echo "3. Change terminal preference"
    echo "4. Add icons to dock"
    echo

    # TODO:
    # - terminal font size? and hide menu?
    # - no suspend?
    # - how to use xfconf-query
fi

echo
echo "Done"
echo

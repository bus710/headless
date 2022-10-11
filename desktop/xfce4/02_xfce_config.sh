#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)"
  exit
fi

if [[ ! $XDG_CURRENT_DESKTOP =~ "XFCE" ]]; then
    echo
    echo "Not XFCE."
    echo
    exit

elif [[ $XDG_CURRENT_DESKTOP =~ "XFCE" ]]; then
    echo
    echo "Home directory cleanup."
    echo

    rm -rf ~/Documents
    rm -rf ~/Music
    rm -rf ~/Videos
    rm -rf ~/Templates
    rm -rf ~/Public

    echo
    echo "Remove some packages"
    echo

    sudo apt remove -y libreoffice-common
    sudo apt remove -y parole

    # Theme
    rm -rf ~/.themes
    mkdir ~/.themes
    git clone https://github.com/daniruiz/skeuos-gtk
    mv ./skeuos-gtk/themes/* ~/.themes/
    rm -rf skeuos-gtk
    gsettings set org.gnome.desktop.interface gtk-theme "Skeuos-Blue-Dark"
    gsettings set org.gnome.desktop.wm.preferences theme "Skeuos-Blue-Dark"

    # Icons
    git clone https://github.com/vinceliuice/Qogir-icon-theme
    cd Qogir-icon-theme 
    ./install.sh
    cd ..
    rm -rf Qogir-icon-theme 
    gsettings set org.gnome.desktop.interface icon-theme "Qogir-dark"

    # Terminal
    rm -rf ~/.local/share/xfce4/terminal/colorschemes
    mkdir -p ~/.local/share/xfce4/terminal/colorschemes
    cp ./Dracula.theme ~/.local/share/xfce4/terminal/colorschemes/

    echo
    echo "Install Plank"
    echo

    # Dock (^+RMB for preference)
    #sudo apt install -y plank
    #PLANK_DESKTOP="/home/$LOGNAME/.config/autostart/plank.desktop"
    #if [[ ! -d ~/.config/autostart ]]; then
    #    mkdir ~/.config/autostart -p                  
    #fi                                                
    #rm -rf $PLANK_DESKTOP
    #echo "[Desktop Entry]" >> $PLANK_DESKTOP
    #echo "Type=Application" >> $PLANK_DESKTOP
    #echo "Exec=plank" >> $PLANK_DESKTOP
    #echo "Hidden=false" >> $PLANK_DESKTOP
    #echo "NoDisplay=false" >> $PLANK_DESKTOP
    #echo "X-GNOME-Autostart-enabled=true" >> $PLANK_DESKTOP
    #echo "Name=Plank" >> $PLANK_DESKTOP

    # Enable Natural Scroll for Touchpad
    SYNCLIENT_DESKTOP="/home/$LOGNAME/.config/autostart/synclient.desktop" 
    if [[ ! -d ~/.config/autostart ]]; then
      mkdir ~/.config/autostart -p
    fi
    rm -rf $SYNCLIENT_DESKTOP
    echo "[Desktop Entry]" >> $SYNCLIENT_DESKTOP
    echo "Type=Application" >> $SYNCLIENT_DESKTOP
    echo "Name=synclient" >> $SYNCLIENT_DESKTOP
    echo "Exec=/usr/bin/synclient VertScrollDelta=-56" >> $SYNCLIENT_DESKTOP
    
    # Disable Caps lock
    sudo bash -c "echo 'XKBOPTIONS=ctrl:nocaps' >> /etc/default/keyboard"

    echo 
    echo "1. Enable Gnome services for Keyring: Settings => Session and Startup => Advanced"
    echo "2. Change wm theme, color theme, icon, font size"
    echo "3. Change language and power config"
    echo "4. Change terminal preference (size, theme, menu bar)"
    echo "5. Window size change: Alt+RMB+Drag"
    echo
fi

echo 
echo "Change the time to stop services (90s => 5s)"
echo
sudo bash -c "sed -i '/#DefaultTimeoutStopSec=90s/c\DefaultTimeoutStopSec=5s' /etc/systemd/system.conf"

echo
echo "Done"
echo

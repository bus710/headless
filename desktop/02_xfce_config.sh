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

    # WM theme
    rm -rf ~/.local/share/themes
    mkdir ~/.local/share/themes
    git clone https://github.com/tdloi/nanodesu-xfwm4
    cp -r nanodesu-xfwm4/nanodesu* ~/.local/share/themes/
    rm -rf nanodesu-xfwm4
    # Change WM theme in settings => Window Manager

    # Theme
    rm -rf ~/.themes
    mkdir ~/.themes
    git clone https://github.com/Michedev/Ant-Dracula-Blue.git
    mv ./Ant-Dracula-Blue ~/.themes/Ant-Dracula-Blue
    gsettings set org.gnome.desktop.interface gtk-theme "Ant-Dracula-Blue"

    # Terminal
    rm -rf ~/.local/share/xfce4/terminal/colorschemes
    mkdir -p ~/.local/share/xfce4/terminal/colorschemes
    cp ./Dracula.theme ~/.local/share/xfce4/terminal/colorschemes/

    # Icons
    git clone https://github.com/vinceliuice/Qogir-icon-theme
    cd Qogir-icon-theme 
    ./install.sh
    cd ..
    rm -rf Qogir-icon-theme 

    echo
    echo "Create a shortcut for xfce4 appfinder"
    echo

    # This is for shortcuts of apps 

    # Set Super + s to open settings manager
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/commands/custom/<Super>s" \
        --create --type string --set xfce4-settings-manager 

    # Set Super + q to open appfinder
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/commands/custom/<Super>q" \
        --create --type string --set xfce4-appfinder

    # Set Super + w to open terminal
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/commands/custom/<Super>w" \
        --create --type string --set xfce4-terminal

    # Set Super + c to open chrome
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/commands/custom/<Super>c" \
        --create --type string --set google-chrome

    # Set Super + v to open vscode
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/commands/custom/<Super>v" \
        --create --type string --set code

    # This is for shortcuts of window control

    # Set Super + d to to show desktop
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/xfwm4/custom/<Super>d" --reset
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/xfwm4/custom/<Super>d" \
        --create --type string --set show_desktop_key

    # Set Super + Left to tile window to left
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/xfwm4/custom/<Super>Left" --reset
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/xfwm4/custom/<Super>Left" \
        --create --type string --set tile_left_key

    # Set Super + Right to tile window to right
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/xfwm4/custom/<Super>Right" --reset
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/xfwm4/custom/<Super>Right" \
        --create --type string --set tile_right_key
    
    # To confirm
    xfconf-query --channel xfce4-keyboard-shortcuts -lv 

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
    echo "4. Change terminal preference"
    echo "5. Add icons to panel"
    echo "6. Window size change: Alt+RMB+Drag"
    echo
fi

echo 
echo "Change the time to stop services (90s => 5s)"
echo
sudo bash -c "sed -i '/#DefaultTimeoutStopSec=90s/c\DefaultTimeoutStopSec=5s' /etc/systemd/system.conf"

echo
echo "Done"
echo

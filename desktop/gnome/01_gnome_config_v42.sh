#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]; then
    echo "Please run as normal user (w/o sudo)"
    exit
fi

term_color_red () {
    echo -e "\e[91m"
}

term_color_white () {
    echo -e "\e[39m"
}

confirmation(){
    term_color_red
    echo "Configure GDE"
    term_color_white

    echo
    sudo echo ""
    echo
}

check_de(){
    if [[ ! $XDG_CURRENT_DESKTOP =~ "GNOME" ]]; then
        term_color_red
        echo "Not GNOME."
        term_color_white

        exit -1
    fi
}

install_packages(){
    term_color_red
    echo "Install some packages"
    echo "Remove some directories"
    term_color_white

    sudo apt install -y \
        gnome-tweaks \
        gnome-shell-extensions

    sudo apt install -y \
        gnome-shell-extension-prefs \
        gnome-shell-extension-ubuntu-dock \
        gnome-shell-extension-appindicator \
        gnome-shell-extension-desktop-icons-ng

    sudo apt install -y \
        xdg-desktop-portal-gnome

    rm -rf ~/Music ~/Public ~/Videos ~/Documents ~/Templates
}

appearance () {
    term_color_red
    echo "Gnome Control Center > Appearance"
    term_color_white

    # apply dark theme
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-blue-dark'
    gsettings set org.gnome.desktop.interface icon-theme 'Yaru-blue'
    # dock behavior (settings => appearance)
    gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 24
    gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
    gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
    gsettings set org.gnome.shell.extensions.dash-to-dock autohide false
    gsettings set org.gnome.shell.extensions.dash-to-dock icon-size-fixed true
    gsettings set org.gnome.shell.extensions.dash-to-dock running-indicator-style 'METRO'
    gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false # panel => dock
    # dock behavior (settings => appearance => dock behavior)
    gsettings set org.gnome.shell.extensions.dash-to-dock show-trash false
    gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts false
    gsettings set org.gnome.shell.extensions.dash-to-dock show-favorites false
    gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts-network false
}

accessibility () {
    term_color_red
    echo "Gnome Control Center > Accessibility"
    term_color_white

    # disable animation
    gsettings set org.gnome.desktop.interface enable-animations false
    # mouse cursor size
    gsettings set org.gnome.desktop.interface cursor-size 48
}

multitasking () {
    term_color_red
    echo "Gnome Control Center > Multitasking"
    term_color_white

    # General => Hot corner : false
    gsettings set org.gnome.desktop.interface enable-hot-corners false
    # General => Active Screen Edges : true
    gsettings set org.gnome.mutter workspaces-only-on-primary false
    # Workspaces => Dynamic workspaces
    gsettings set org.gnome.mutter dynamic-workspaces true
    # Multi monitor => Workspaces on all displays
    gsettings set org.gnome.shell.app-switcher current-workspace-only true
    gsettings set org.gnome.shell.window-switcher current-workspace-only true
    gsettings set org.gnome.shell.extensions.window-list display-all-workspaces false
    # App switching => Include apps from the current workspace only
    gsettings set org.gnome.shell.extensions.dash-to-dock isolate-monitors false
    # App switching => Include apps from all monitors
    gsettings set org.gnome.shell.extensions.dash-to-dock isolate-workspaces true
}

power_control () {
    term_color_red
    echo "Gnome Control Center > Power"
    term_color_white

    gsettings set org.gnome.settings-daemon.plugins.power power-button-action nothing
    gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false
    gsettings set org.gnome.settings-daemon.plugins.power idle-dim false
    gsettings set org.gnome.settings-daemon.plugins.power lid-close-ac-action nothing
    gsettings set org.gnome.settings-daemon.plugins.power lid-close-battery-action nothing
    gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 0
    gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 0
}

background () {
    term_color_red
    echo "Gnome Control Center > Background"
    term_color_white

    gsettings set org.gnome.desktop.background picture-uri ""
    gsettings set org.gnome.desktop.background picture-uri-dark ""
    gsettings set org.gnome.desktop.background picture-options zoom
    gsettings set org.gnome.desktop.background primary-color '#303040'
    gsettings set org.gnome.desktop.background secondary-color '#111111'
    gsettings set org.gnome.desktop.background show-desktop-icons false
    # lock screen color
    gsettings set org.gnome.desktop.screensaver picture-uri ""
    gsettings set org.gnome.desktop.screensaver picture-options zoom
    gsettings set org.gnome.desktop.screensaver lock-delay 0
}

nautilus_columns () {
    term_color_red
    echo "Nautilus columns"
    term_color_white

    gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'
    gsettings set org.gnome.nautilus.preferences default-sort-order 'type'
    gsettings set org.gnome.nautilus.list-view default-visible-columns "['name', 'size', 'date_modified_with_time', 'type']"
}

window_keyboard_mouse_control () {
    term_color_red
    echo "Disable Caps lock, alt key for Window control, and place a new window on center"
    term_color_white

    # change capslock to ctrl
    gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:nocaps']"
    # mouse right key to change window size
    gsettings set org.gnome.desktop.wm.preferences resize-with-right-button "true"
    gsettings set org.gnome.desktop.wm.preferences mouse-button-modifier "<Alt>"
    # place windows at center
    gsettings set org.gnome.mutter center-new-windows true
}

trackpad_control() {
    term_color_red
    echo "Disable trackpad when there is any external pointing device"
    term_color_white

    gsettings set org.gnome.desktop.peripherals.touchpad send-events 'disabled-on-external-mouse'
}


terminal_color_control () {
    term_color_red
    echo "Gnome Terminal Theme"
    echo "Gnome Terminal > Preferences > Custom on left"
    term_color_white

    dconf load /org/gnome/terminal/ < custom.theme

    # How to dump?
    # dconf dump /org/gnome/terminal/ >> custom.theme
}

shortcuts_custom () {
    term_color_red
    echo "Gnome Control Center > Keyboard > View and Customize Shortcuts > Custom Shortcuts"
    term_color_white

    # prep
    BEGINNING="gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"
    KEY_PATH="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"
    # register
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings \
        "['$KEY_PATH/custom0/', '$KEY_PATH/custom1/', '$KEY_PATH/custom2/', '$KEY_PATH/custom3/', '$KEY_PATH/custom4/', '$KEY_PATH/custom5/', '$KEY_PATH/custom6/', '$KEY_PATH/custom7/', '$KEY_PATH/custom8/', '$KEY_PATH/custom9/', '$KEY_PATH/custom10/']"

    echo "super+e => terminal"
    $BEGINNING/custom0/ name "Terminal"
    $BEGINNING/custom0/ command "gnome-terminal"
    $BEGINNING/custom0/ binding "<Super>Return"

    echo "super+g => settings"
    $BEGINNING/custom1/ name "Gnome Control Center"
    $BEGINNING/custom1/ command "gnome-control-center"
    $BEGINNING/custom1/ binding "<Super>g"

    echo "super+n => chrome"
    $BEGINNING/custom3/ name "Google Chrome"
    $BEGINNING/custom3/ command "google-chrome"
    $BEGINNING/custom3/ binding "<Super>n"

    echo "super+t => nautilus"
    $BEGINNING/custom4/ name "Nautilus"
    $BEGINNING/custom4/ command "nautilus"
    $BEGINNING/custom4/ binding "<Super>t"

    echo "super+r => remmina"
    $BEGINNING/custom5/ name "Remmina"
    $BEGINNING/custom5/ command "remmina"
    $BEGINNING/custom5/ binding "<Super>r"

    echo "super+x => code-insiders"
    $BEGINNING/custom6/ name "VS Code Insiders"
    $BEGINNING/custom6/ command "code-insiders"
    $BEGINNING/custom6/ binding "<Super>x"

    echo "super+c => code"
    $BEGINNING/custom7/ name "VS Code"
    $BEGINNING/custom7/ command "code"
    $BEGINNING/custom7/ binding "<Super>c"

    echo "super+alt+k => power off"
    $BEGINNING/custom8/ name "Power off"
    $BEGINNING/custom8/ command "gnome-session-quit --power-off"
    $BEGINNING/custom8/ binding "<Super><Alt>k"

    echo "super+alt+d => show dock"
    $BEGINNING/custom9/ name "Show dock"
    $BEGINNING/custom9/ command "gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed true"
    $BEGINNING/custom9/ binding "<Super><Alt>d"

    echo "super+alt+h => hide dock"
    $BEGINNING/custom10/ name "Show dock"
    $BEGINNING/custom10/ command "gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false"
    $BEGINNING/custom10/ binding "<Super><Alt>h"

    echo "super+alt+l => screen saver"
    gsettings set org.gnome.settings-daemon.plugins.media-keys screensaver "['<Super><Alt>l']"
}

shortcuts_workspace () {
    term_color_red
    echo "Gnome Control Center > Keyboard > View and Customize Shortcuts > Navigation"
    term_color_white

    # move to workspace on the L/R
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "['<Super>I']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "['<Super>O']"
    # move the current window to L/R workspace
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-left "['<Super><Alt>I']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-right "['<Super><Alt>O']"
}

shortcuts_volume_control () {
    term_color_red
    echo "Gnome Control Center > Keyboard > View and Customize Shortcuts > Sound and Media"
    term_color_white

    gsettings set org.gnome.settings-daemon.plugins.media-keys volume-mute "['<Ctrl><Shift>0']"
    gsettings set org.gnome.settings-daemon.plugins.media-keys volume-down "['<Ctrl><Shift>8']"
    gsettings set org.gnome.settings-daemon.plugins.media-keys volume-up "['<Ctrl><Shift>9']"
}

shortcuts_print_screen () {
    term_color_red
    echo "Gnome Control Center > Keyboard > View and Customize Shortcuts > Screenshots"
    term_color_white

    gsettings set org.gnome.shell.keybindings show-screenshot-ui "['<Super>z']"
}

post (){
    term_color_red
    echo
    echo "Done"
    echo "- Remove existing favorites from dock"
    echo "- Change font sizes from gnome-tweaks"
    echo "- Change desktop setting from extensions => DING"
    echo "- <Ctrl><Shift>v is the paste for vim/nvim"
    echo "- <Ctrl>n is the auto completion for vim/nvim"
    echo
    term_color_white
}

trap term_color_white EXIT
confirmation
check_de
install_packages
accessibility
multitasking
power_control
background
nautilus_columns
window_keyboard_mouse_control
trackpad_control
terminal_color_control
shortcuts_print_screen
shortcuts_workspace
shortcuts_volume_control
shortcuts_custom
appearance
post

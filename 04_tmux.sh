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
    echo "This will install tmux and configuration"
    echo "Do you want to install? (y/n)"
    echo
    term_color_white

    echo
    read -n 1 ans
    echo

    if [[ ! $ans == "y" ]]; then
        exit 1
    fi
}

install_tmux(){
    term_color_red
    echo "Install tmux and tmuxp"
    term_color_white

    sudo apt install -y \
        tmux
        # tmuxp

    term_color_red
    echo "Update tmux configuration"
    term_color_white

    # To apply ^a shortcut to the tmux config
    rm -rf /home/$LOGNAME/.tmux.conf
    cat tmux.conf >> /home/$LOGNAME/.tmux.conf
    chown $LOGNAME:$LOGNAME /home/$LOGNAME/.tmux.conf
}

install_tpm(){
    term_color_red
    echo "Install tpm"
    term_color_white

    rm -rf /home/$LOGNAME/.tmux/plugins/tpm

    git clone \
        https://github.com/tmux-plugins/tpm \
        /home/$LOGNAME/.tmux/plugins/tpm
}

post(){
    term_color_red
    echo "Done"
    echo "- The tmux leading key is ^a (not ^b)"
    echo "- To install tmux plugins, run tmux and ^a + I"
    term_color_white
}

trap term_color_white EXIT
confirmation
install_tmux
install_tpm
post

# ================================
# Config control
# ================================
# Reload config
# ^a + r
# Install plugins
# ^a + I

# ================================
# Pane control
# ================================
# Resize panes
# 1. ^a => hold ^ and arrow keys
# 2. drag border line with mouse

# Split panes
# ^a + - for horizontal split
# ^a + | for vertical split

# Zoom in/out(maximize/minimize) pane
# ^a + z

# Move around 
# ^a + arrow keys
# ^a + h/j/k/l key

# Swap panes
# ^a + { or }

# Terminate panes
# ^a + x
# ^a + d

# Synchronize panes
# - Send a command across all panes in current window
# - ^a + e : sync on
# - ^a + shift + e : sync off

# ================================
# Clip board control
# ================================
# Copy & paste within tmux
# 1. Mouse 
# - dragging text will copy it to tmux buffer
# - ^a + ] will paste the selection
#
# 2. Vi style
# - ^a + [ to enter into copy mode
# - Nativate to the beginning of text using arrow keys
# - Space to mark the beginning point
# - Nativate to the end of text using arrow keys
# - Enter to copy the selected text to tmux internal buffer
# - ^a + ] will paste the selection

# Copy to tmux and system clipboard too
# 1. Mouse
# - While dragging text, press y while pressing mouse left button
#
# 2. Vi style copy & paste
# - ^a + [ to enter into copy mode
# - Nativate to the beginning of text using arrow keys
# - Space to mark the beginning point
# - Nativate to the end of text using arrow keys
# - y to copy the selected text to system clipboard

# Copy only to system clipboard
# 1. Mouse
# - While pressing shift, dragging text will copy it

# Enter into copy mode
# 1. Mouse
# - Move mouse scroll wheel
#
# 2. Keyboard
# - ^a + [

# ================================
# Windows control
# ================================
# Create window
# ^a + c

# Switch windows
# 1. Mouse: click window name at bottom status line
# 2. ^a + 1~9

# Rename window title
# ^a + ,

# Terminate windows
# ^a + &

# Move windows left/right
# Shift + left/right

# ================================
# Sessions control
# ================================
# tmux ls
# tmux attach -t session_index
# tmux -s session_name
# tmux rename-session -t 0 session_name

# Detach session
# ^a + d

# Rename session
# ^a + $

# Switch session
# ^a + g

# Create a new session
# ^a => Shift + c

# Kill session
# ^a => Shift + x

# Switch to the last session
# ^a => Shift + s

# Move the current pane into a new session
# ^a => @

# Tmux-resurrect
# - Useful when pc restarts
# - Save session: ^a => ^s
# - Restore session: ^a => ^r

# ================================
# Utils control
# ================================
# Pane logging
# - Start/stop a logging for the current pane
# - ^a => Shift + p
# - File path: $HOME
# - File name format: tmux-#{session_name}-#{window_index}-#{pane_index}-%Y%m%dT%H%M%S.log

# Pane screen capture
# - Visible texts in the current pane is saved to a file
# - ^a => Alt + p
# - file path: $HOME
# - file name format: tmux-screen-capture-#{session_name}-#{window_index}-#{pane_index}-%Y%m%dT%H%M%S.log

# Save pane history
# - Saves complete history of the current pane to a file
# - Affected by history-limit
# - ^a => Alt + Shift + p
# - file path: $HOME
# - file name format: tmux-history-#{session_name}-#{window_index}-#{pane_index}-%Y%m%dT%H%M%S.log

# Clear pane history
# - ^a => Alt + c

# Directory tree
# - ^a + tab: toggle directory tree
# - ^a + backspace: toggle directory tree and move cursor to it

# ================================
# Commands
# ================================
# All commands
# - ^a + :
# - Tab key works for auto completion

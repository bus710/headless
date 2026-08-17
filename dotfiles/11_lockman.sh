#!/bin/sh

# https://code.krister.ee/lock-screen-in-sway/

# Times the screen off and puts it to background
swayidle \
    timeout 3 'swaymsg "output * power off"' \
    resume 'swaymsg "output * power on"' &

# Locks the screen immediately
swaylock -c 101010

# Kills last background task so idle timer doesn't keep running
kill %%

#!/bin/sh

# https://code.krister.ee/lock-screen-in-sway/
# Lock immediately; blank displays after a short idle while locked.

# Idle watcher: power displays off after 3s, back on when input resumes.
swayidle -w \
    timeout 3 'swaymsg "output * power off"' \
    resume   'swaymsg "output * power on"' &
swayidle_pid=$!

# Lock the screen (blocks until unlocked).
swaylock -c 101010

# Stop the idle watcher. Capture the PID explicitly -- sway runs this via
# `bash ...lockman.sh`, a non-interactive shell where job control (kill %%)
# is disabled and would leak the background swayidle.
kill "$swayidle_pid" 2>/dev/null

# Guarantee every display is powered back on after unlock (the idle watcher
# may have been killed while an output was still off).
swaymsg "output * power on"

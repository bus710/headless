#!/bin/bash

term_color_red () {
    echo -e "\e[91m"
}

term_color_white () {
    echo -e "\e[39m"
}

sudo echo

term_color_red 
echo "sudo crontab -e"
term_color_white

echo '*/5 * * * * echo 3000000 | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq 2>&1 > /dev/null'
echo '*/5 * * * * echo "low" | sudo tee /sys/class/drm/card0/device/power_dpm_force_performance_level 2>&1 > /dev/null'

echo

#!/bin/bash

term_color_red () {
    echo -e "\e[91m"
}

term_color_white () {
    echo -e "\e[39m"
}

sudo echo

sudo rm -rf /etc/udev/rules.d/31-gpu-max-freq.rules

echo 'ACTION=="add", SUBSYSTEM=="drm", DRIVERS=="amdgpu", ATTR{device/power_dpm_force_performance_level}="low" ' \
    | sudo tee /etc/udev/rules.d/31-amdgpu-low-power.rules

term_color_red 
echo "Done"
term_color_white

echo

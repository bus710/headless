#!/bin/bash

term_color_red () {
    echo -e "\e[91m"
}

term_color_white () {
    echo -e "\e[39m"
}

sudo echo

sudo rm -rf /etc/udev/rules.d/30-cpu-max-freq.rules
sudo rm -rf /usr/local/bin/cpu2g.sh
sudo rm -rf /usr/local/bin/cpu3g.sh

echo '
SUBSYSTEM=="power_supply", ATTR{status}=="Discharging", ACTION=="change", RUN+="/usr/local/bin/cpu2g.sh" \n
SUBSYSTEM=="power_supply", ATTR{status}=="Charging", ACTION=="change", RUN+="/usr/local/bin/cpu3g.sh"' \
    | sudo tee /etc/udev/rules.d/30-cpu-max-freq.rules

echo '#!/bin/sh \n
echo 2000000 > /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq' \
    | sudo tee /usr/local/bin/cpu2g.sh

echo '#!/bin/sh 
echo 3000000 > /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq' \
    | sudo tee /usr/local/bin/cpu3g.sh

sudo chmod 744 /usr/local/bin/cpu2g.sh
sudo chmod 744 /usr/local/bin/cpu3g.sh

term_color_red 
echo "Done"
term_color_white

echo

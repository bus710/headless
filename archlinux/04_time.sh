#!/bin/bash

set -e

echo
echo "This takes a min"
echo

ln -sf /usr/share/zoneinfo/US/Pacific-New /etc/localtime
ntpdate 0.north-america.pool.ntp.org
hwclock -w
timedatectl status

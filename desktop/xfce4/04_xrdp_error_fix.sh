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
    echo "Create a config file to avoid the error message"
    echo

    sudo rm -rf /etc/polkit-1/localauthority.conf.d/02-allow-colord.conf
    sudo bash -c 'echo "
        polkit.addRule(function(action, subject) {
         if ((action.id == "org.freedesktop.color-manager.create-device" ||
         action.id == "org.freedesktop.color-manager.create-profile" ||
         action.id == "org.freedesktop.color-manager.delete-device" ||
         action.id == "org.freedesktop.color-manager.delete-profile" ||
         action.id == "org.freedesktop.color-manager.modify-device" ||
         action.id == "org.freedesktop.color-manager.modify-profile") &&
         subject.isInGroup("{users}")) {
         return polkit.Result.YES;
         }
        });" >> /etc/polkit-1/localauthority.conf.d/02-aloow-colord.conf'
fi

echo
echo "Done"
echo

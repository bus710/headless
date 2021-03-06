#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)"
  exit
fi

SLACK_VER="slack-desktop-4.12.2-amd64.deb"

wget https://downloads.slack-edge.com/linux_releases/$SLACK_VER
sudo dpkg -i $SLACK_VER
rm -rf $SLACK_VER

echo
echo "Done"
echo

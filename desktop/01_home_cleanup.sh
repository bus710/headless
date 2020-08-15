#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)"
  exit
fi

echo
echo "Home directory cleanup."
echo

rm -rf ~/Documents
rm -rf ~/Music
rm -rf ~/Videos
rm -rf ~/Templates
rm -rf ~/Public

echo
echo "Done"
echo

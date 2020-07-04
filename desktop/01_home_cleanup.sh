#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)"
  exit
fi

echo
echo "Home directory cleanup."
echo

rmdir ~/Documents
rmdir ~/Music
rmdir ~/Videos
rmdir ~/Templates
rmdir ~/Public

echo
echo "Done"
echo

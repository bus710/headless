#!/bin/bash

if [ "$EUID" == 0 ]
then echo "Please run as normal user (w/o sudo)"
  exit
fi

echo
echo "Firebase install"
echo

curl -sL firebase.tools | bash

echo
echo "Firebase login"
echo

firebase login

echo
echo "Check the detail:"
echo "- https://github.com/firebase/firebase-tools"
echo

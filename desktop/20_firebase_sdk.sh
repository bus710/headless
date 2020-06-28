#!/bin/bash

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

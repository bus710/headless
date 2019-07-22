#!/bin/bash

OSNAME="$(lsb_release -ds)"
echo $OSNAME

if [[ "$OSNAME" == *"Debian"* ]]
then
    echo "Sorry, Debian is not supported by this script"
    exit
else
    echo "ok"
fi

#!/bin/bash

VERSION="flutter_linux_v1.7.8+hotfix.3-stable.tar.xz"

echo 
echo "Install the prerequisites"
echo 

sudo apt install -y lib32stdc++6

echo 
echo "Download and install flutter SDK"
echo 

wget https://storage.googleapis.com/flutter_infra/releases/stable/linux/$VERSION

echo
echo "Wait for untar"
echo

tar xf $VERSION
rm -rf ~/flutter
mv flutter ~/
rm $VERSION

echo 
echo "Config the SDK"
echo 

flutter doctor

echo
echo "Change the channel"
echo

flutter channel master
flutter upgrade

echo 
echo "Install webdev" 
echo

flutter pub global activate webdev


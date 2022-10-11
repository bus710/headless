#!/bin/bash

# Installing pip3 and libs for powerline-shell.

# 1. For the basic stuff
sudo apt install -y python3-pip

yes | sudo pip3 install setuptools
yes | sudo pip3 install wheel
yes | sudo pip3 install pylint
yes | sudo pip3 install ipython
yes | sudo pip3 install pyserial

# 2. For the Qt5/QML stuff
sudo apt install -y python3-pyqt5
sudo apt install -y python3-pyqt5.qtquick*
sudo apt install -y pyqt5-dev-*
sudo apt install -y qttools5-dev-*

sudo apt install qml-module-qtquick2
sudo apt install qml-module-qtquick-window2
sudo apt install qml-module-qtquick-controls2
sudo apt install qml-module-qtquick-layouts

# To check the package version
# sudo apt-cache show qml-module-qtquick2
# sudo apt-cache show qml-module-qtquick-controls2
# sudo apt-cache show qml-module-qtquick-layouts

# Or visit doc.qt.io
# https://doc.qt.io/qt-5/qtquickcontrols2-index.html

# 3. pyqtgraph
pip3 install pyqtgraph

# For the powerline stuff
#yes | sudo pip3 install powerline-status
#yes | sudo pip3 install powerline-gitstatus

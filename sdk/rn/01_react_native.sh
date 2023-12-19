#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]; then
	echo "Please run as normal user (w/o sudo)"
	exit
fi

term_color_red() {
	echo -e "\e[91m"
}

term_color_white() {
	echo -e "\e[39m"
}

confirmation() {
	term_color_red
	echo "Install RN tools"
	echo "Do you want to install? (y/n)"
	term_color_white

	echo
	read -n 1 -r ANSWER
	echo

	if [[ ! $ANSWER == "y" ]]; then
		exit 1
	fi
	echo ""
	sudo echo ""
}

install_rn_tools() {
  term_color_red
  echo "Install basic RN cli tools"
  term_color_white

  npm root -g
  npm install -g react-native@latest
  npm install -g react-native-cli@latest
  npm install -g react-devtools@latest
}

install_watchman() {
  term_color_red
  echo "Install watchman"
  term_color_white

	# To use the prebuilt binary files
	# https://facebook.github.io/watchman/docs/install.html#prebuilt-binaries-2
	# https://github.com/facebook/watchman/issues/1019#issuecomment-1263343842
	# https://packages.debian.org/search?keywords=libssl&searchon=names&suite=oldstable&section=all
	
	cd /home/$LOGNAME/Downloads 
	sudo rm -rf ./watchman*

	WVERSION=$(curl -o- -s https://api.github.com/repos/facebook/watchman/releases/latest | jq -r '.tag_name')

 	sudo rm -rf /usr/local/lib/libglog*
 	sudo rm -rf /usr/local/lib/libsnappy*
 	sudo rm -rf /usr/local/lib/libgflags*
 	sudo rm -rf /usr/local/lib/libevent-2*
 	sudo rm -rf /usr/local/bin/watchman
 	sudo rm -rf /usr/local/bin/watchmanctl
 	sudo rm -rf /usr/local/var/run/watchman

	wget -O libssl.deb http://ftp.us.debian.org/debian/pool/main/o/openssl/libssl1.1_1.1.1w-0+deb11u1_amd64.deb
	sudo dpkg -i libssl.deb
	sudo rm -rf libssl.deb
	
	wget -O watchman.zip https://github.com/facebook/watchman/releases/download/$WVERSION/watchman-$WVERSION-linux.zip
	unzip watchman.zip
	sudo rm -rf watchman.zip
	sudo mv watchman-* watchman
	ls watchman
	sudo mkdir -p /usr/local/{bin,lib} /usr/local/var/run/watchman
	sudo cp watchman/bin/* /usr/local/bin
	sudo cp watchman/lib/* /usr/local/lib
	sudo chmod 755 /usr/local/bin/watchman
	sudo chmod 2777 /usr/local/var/run/watchman
} 

post() {
	term_color_red
  echo "To start a new RN project:"
  echo "- $ npx react-native@latest init \$PROJECT_NAME"
  echo "- $ cd \$PROJECT_NAME"
  echo "- $ npm start"
  echo "- $ npm run android # in another terminal"
  echo 
	term_color_white
}


trap term_color_white EXIT
confirmation
install_rn_tools
install_watchman
post

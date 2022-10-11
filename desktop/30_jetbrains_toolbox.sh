#!/bin/bash

# from https://gist.github.com/jen20/218642f3c2cd0e2ce8b6b95ca59e0538

set -e

RELEASE="https://www.jetbrains.com/toolbox-app/"
TOOLBOX_PATH="${HOME}/.local/share/JetBrains/Toolbox/bin/"

if [[ "$EUID" == 0 ]]; then 
    echo "Please run as normal user (w/o sudo)"
    exit
fi

CPU_TYPE=$(uname -p)

if [[ $CPU_TYPE != "x86_64" ]]; then
    echo
    echo "Only x86_64 can be used."
    echo
    # actually supports ARM64
    exit
fi

echo
echo -e "\e[91m"
echo "Please check these web sites:"
echo "- $RELEASE"
echo 
echo "Do you want to install ToolBox? (y/n)"
echo -e "\e[39m"
echo

echo
read -n 1 ans
echo

if [[ $ans == "y" ]]; then
    if [[ -f $TOOLBOX_PATH ]]; then
        rm -rf $TOOLBOX_PATH
    fi

    mkdir -p $TOOLBOX_PATH

    echo
    echo "Installing jetbrains Toolbox"
    echo 

    URL=$(curl -s 'https://data.services.jetbrains.com//products/releases?code=TBA&latest=true&type=release' | jq -r '.TBA[0].downloads.linux.link')

    DOWNLOAD_TEMP_DIR=$(mktemp -d)

    mkdir -p "${DOWNLOAD_TEMP_DIR}"

    curl -L "${URL}" --output "${DOWNLOAD_TEMP_DIR}/toolbox.tar.gz"

    TOOLBOX_TEMP_DIR=$(mktemp -d)

    tar -C "$TOOLBOX_TEMP_DIR" -xvf "${DOWNLOAD_TEMP_DIR}/toolbox.tar.gz"
    rm "${DOWNLOAD_TEMP_DIR}/toolbox.tar.gz"
    rm -rf "${TOOLBOX_TEMP_DIR}"

    echo 
    echo "Done."
    echo "- Restart terminal"
    echo "- Try jetbrains-toolbox and install IDEs"
    echo "- There will be shortcuts under ~/.local/share/applications"
    echo
fi

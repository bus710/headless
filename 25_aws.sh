#!/bin/bash

# https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html

set -e

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)"
  exit
fi

CPU_TYPE=$(uname -p)

if [[ $CPU_TYPE != "x86_64" ]] || [[ $CPU_TYPE != "aarch64" ]]; then
    echo
    echo "This is not x86_64 or aarch64."
    echo

    exit
fi

echo
echo "Remove if exist"
echo

sudo rm -rf /usr/local/aws-cli
sudo rm -rf /usr/local/bin/aws
sudo rm -rf /usr/local/bin/aws_completer

echo
echo "Get the package"
echo

curl "https://awscli.amazonaws.com/awscli-exe-linux-${CPU_TYPE}.zip" -o "awscliv2.zip"

echo
echo "Unzip..."
echo

unzip awscliv2.zip

echo 
echo "Install aws"
echo

sudo ./aws/install

echo
echo "Check the version"
echo

aws --version

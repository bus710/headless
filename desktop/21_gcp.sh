#!/bin/bash

echo
echo "Add the repo"
echo

echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

echo
echo "Install addtional packages"
echo

sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    gnupg

echo 
echo "Get the public key"
echo

curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
    sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

echo
echo "Install GCP SDK"
echo

sudo apt update && sudo apt install -y google-cloud-sdk

echo
echo "Install App Engine - Go"
echo

sudo apt install -y google-cloud-sdk-app-engine-go

echo 
echo "Init"
echo

gcloud init

echo 
echo "Check the detail:"
echo "- https://cloud.google.com/sdk/docs/downloads-apt-get"
echo



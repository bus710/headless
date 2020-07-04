#!/bin/bash

set -e

# Pushing commits to a pre-configured repository.
# Can check the repo from 00_git_setup.sh.

echo
git status
echo

echo -e "\e[91m"
echo "Do you want to add and commit all changes? (y/n)"
echo -e "\e[39m"

read -n 1 ans

if [ $ans == "y" ]
then
    echo 
    echo
    git add --all

    echo -e "\e[91m"
    echo "Message?"
    echo -e "\e[39m"

    read msg
    echo

    git commit -m "$msg"
    git push

    echo 
    echo "git add --all"
    echo "git commit -m $msg"
    echo "git push"
    echo
fi

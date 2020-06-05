#!/bin/bash

# Pushing commits to a pre-configured repository.
# Can check the repo from 00_git_setup.sh.

echo -e "\e[91m"
echo "Which branch (git branch)"
echo -e "\e[39m"

git branch

echo -e "\e[91m"
echo "Updated files (git diff --name-status)"
echo -e "\e[39m"

git diff --name-status

echo -e "\e[91m"
echo "Untracked files (git ls-files --others --exclude-standard)"
echo -e "\e[39m"

git ls-files --others --exclude-standard

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

    git commit -m $msg
    git push

    echo 
    echo "git add --all"
    echo "git commit -m $msg"
    echo "git push"
    echo
fi

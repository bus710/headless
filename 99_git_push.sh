# Pushing commits to a pre-configured repository.
# Can check the repo from 00_git_setup.sh.

echo -e "\e[91m"
echo "git diff --name-status"
echo -e "\e[39m"

git diff --name-status

echo -e "\e[91m"
echo "git ls-files --others --exclude-standard"
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
    git commit -m "A minor update"
    git push

    echo 
    echo "git add --all"
    echo "git commit -m 'A minor update'"
    echo "git push"
    echo
fi

echo
echo "Install snapd and snap packages"
echo

sudo apt install snapd

# Classic
#sudo snap install --classic goland
sudo snap install --classic android-studio 
sudo snap install --classic code 
sudo snap install --classic code-insiders 
sudo snap install --classic slack
sudo snap install --beta sqlitebrowser

# Not classic
sudo snap install mqtt-explorer

echo
echo "Config ideavim for no sound"
echo

cat ideavimrc >> ~/.ideavimrc

echo
echo "These are installed:"
echo "- Android Studio"
echo "- Vscode"
echo "- Vscode insider"
echo "- Mqtt explorer"
echo "- Sqlite browser"
echo

echo
echo "For Android Studio:"
echo "   Install Ideavim, Dracula, File Watcher, Flutter"
echo "   dartfmt: File > Settings > Languages > Flutter"
echo "   SDK update: File > Settings > Appearance > System Settings > Android SDK"
echo "   webdev issue: flutter pub pub cache repair"
echo


#!/bin/sh
set -e

sudo rm -rf /etc/nix /nix
sudo rm -rf ~/.nix-profile ~/.nix-defexpr ~/.nix-channels
sudo rm -rf /var/root/.nix-profile /var/root/.nix-defexpr /var/root/.nix-channels

sudo systemctl stop nix-daemon.service nix-daemon.socket 2>/dev/null || true
sudo systemctl disable nix-daemon.service nix-daemon.socket 2>/dev/null || true
sudo rm -f /etc/systemd/system/nix-daemon.service /etc/systemd/system/nix-daemon.socket
sudo rm -f /etc/systemd/system/sockets.target.wants/nix-daemon.socket
sudo systemctl daemon-reload

for i in $(seq 1 32); do sudo userdel nixbld$i 2>/dev/null || true; done
sudo groupdel nixbld 2>/dev/null || true

sudo rm -rf /etc/bashrc.backup-before-nix
sudo rm -rf /etc/zshrc
sudo rm -rf /etc/zshrc.backup-before-nix
sudo rm -rf /etc/zsh/zshrc.backup-before-nix
sudo rm -f /etc/profile.d/nix.sh

grep -n nix /etc/profile || true

sudo rm -rf /etc/bash.bashrc.backup-before-nix
sudo rm -f /etc/bashrc.bak /etc/zshrc.bak

echo "Done"

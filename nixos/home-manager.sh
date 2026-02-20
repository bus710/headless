#!/bin/sh

nix-channel --add https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz home-manager
nix-channel --update

nix-shell '<home-manager>' -A install

#!/bin/sh

# https://nixos.org/download/

curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh -s -- --daemon

echo ""
echo "Source the nix-sh"

. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

echo "Done"

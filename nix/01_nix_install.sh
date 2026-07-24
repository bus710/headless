#!/bin/sh

# https://nixos.org/download/

curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh -s -- --daemon

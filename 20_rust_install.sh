#!/bin/bash

curl https://sh.rustup.rs -sSf | sh
source $HOME/.cargo/env

echo
echo "See the version below"
echo

rustc --version
cargo --version



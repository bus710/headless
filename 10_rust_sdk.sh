#!/bin/bash

# https://www.rust-lang.org/tools/install

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env

echo
echo "See the version below"
echo

rustc --version
cargo --version

echo
echo "Update rust and add components"
echo

rustup update
rustup component add rustfmt clippy rls rust-analysis rust-src

echo
echo "Done"
echo



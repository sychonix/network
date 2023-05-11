#Install Dependencies
```
sudo apt-get update

sudo apt install --assume-yes git clang curl libssl-dev llvm libudev-dev make protobuf-compiler

sudo apt install build-essential

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

source $HOME/.cargo/env

rustc --version

rustup default stable

rustup update

rustup update nightly

rustup target add wasm32-unknown-unknown --toolchain nightly

rustup show

rustup +nightly show
```

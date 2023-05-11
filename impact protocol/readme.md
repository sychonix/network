# Impact Protocol 

### Install Dependencies
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
### Create a New Screen
```
screen -S impact
```
Instal Binary
```
git clone https://github.com/GlobalBoost/impactprotocol
cd impactprotocol
cargo build --release
```
### Generate Mining Key
```
./target/release/impact generate-mining-key --chain=impact-testnet
```
Then it will come out as follows
```
Public key: 0xxxx
Secret seed: xxxxx
Address: 5xxxxxx
```
Please save both your Public key and Secret Seed
### Import Wallet
Enter your Secret seed in the form below.
```
./target/release/impact import-mining-key "your_screet_seed" \--base-path /tmp/impactnode \--chain=impact-testnet
```
### Collecting Data
```
./target/release/impact key insert \
  --base-path ~/.impactnode01 \
  --chain=impact-testnet \
  --scheme Ed25519 \
  --suri "your_screet_seed//sysuwh///impact" \
  --key-type gran"
```
```
./target/release/impact key insert \
  --base-path ~/.impactnode01 \
  --chain=impact-testnet \
  --scheme Sr25519 \
  --suri "your_screet_seed//sysuwh///impact" \
  --key-type imon
```
```
./target/release/impact key insert \
  --base-path ~/.impactnode01 \
  --chain=impact-testnet \
  --scheme Sr25519 \
  --suri "your_screet_seed//sysuwh///impact" \
  --key-type auth
```
### Run Node
```
./target/release/impact \
--base-path /tmp/impactnode \
--chain=impact-testnet \
--port 30333 \
--ws-port 9945 \
--ws-external \
--rpc-cors=all \
--rpc-port 9933 \
--rpc-external \
--telemetry-url "wss://telemetry.polkadot.io/submit/ 0" \
--validator \
--author "your_address" \
--rpc-methods Unsafe \
--name sysuwh \
```



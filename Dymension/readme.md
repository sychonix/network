
<p align="center">
  <img height="100" height="auto" src="https://avatars.githubusercontent.com/u/108229184?s=200&v=4">
</p>

# Dymension Testnet | Chain ID : 35-C | Custom Port : 242

### Official Documentation:
>- [Validator setup instructions](https://docs.dymension.xyz/validators/full-node/run-a-node)

### Stake with Sychonix:
>-  https://explorer.nodexcapital.com/dymension/staking/dymvaloper1n9yenan0nuxrqfy85pyrg5qatuwcnraw729th3

# Setup validator name
Replace YOUR_MONIKER with your validator name
```
MONIKER="YOUR_MONIKER"
```
# Install dependencies
Update system and install build tools
```
sudo apt -q update
sudo apt -qy install curl git jq lz4 build-essential
sudo apt -qy upgrade
```
# Install Go
```
sudo rm -rf /usr/local/go
curl -Ls https://go.dev/dl/go1.19.7.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)
```
# Download and build binaries
```
# Clone project repository
cd $HOME
rm -rf dymension
git clone https://github.com/dymensionxyz/dymension.git
cd dymension
git checkout v0.2.0-beta
​
# Build binaries
make build

# Prepare binaries for Cosmovisor
mkdir -p $HOME/.dymension/cosmovisor/genesis/bin
mv bin/dymd $HOME/.dymension/cosmovisor/genesis/bin/
rm -rf build

# Create application symlinks
ln -s $HOME/.dymension/cosmovisor/genesis $HOME/.dymension/cosmovisor/current
sudo ln -s $HOME/.dymension/cosmovisor/current/bin/dymd /usr/local/bin/dymd
```
# Install Cosmovisor and create a service
```
# Download and install Cosmovisor
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0
​
# Create service
sudo tee /etc/systemd/system/dymd.service > /dev/null << EOF
[Unit]
Description=dymension-testnet node service
After=network-online.target
​
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.dymension"
Environment="DAEMON_NAME=dymd"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.dymension/cosmovisor/current/bin"
​
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable dymd
```
# Initialize the node
```
# Set node configuration
dymd config chain-id 35-C
dymd config keyring-backend test
dymd config node tcp://localhost:46657
​
# Initialize the node
dymd init $MONIKER --chain-id 35-C
​
# Download genesis and addrbook
curl -Ls https://snapshots.kjnodes.com/dymension-testnet/genesis.json > $HOME/.dymension/config/genesis.json
curl -Ls https://snapshots.kjnodes.com/dymension-testnet/addrbook.json > $HOME/.dymension/config/addrbook.json
​
# Add seeds
sed -i -e "s|^seeds *=.*|seeds = \"3f472746f46493309650e5a033076689996c8881@dymension-testnet.rpc.kjnodes.com:46659\"|" $HOME/.dymension/config/config.toml
​
# Set minimum gas price
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.025udym,0.025uatom\"|" $HOME/.dymension/config/app.toml
​
# Set pruning
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.dymension/config/app.toml
​
# Set custom ports
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:46658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:46657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:46060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:46656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":46660\"%" $HOME/.dymension/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:46317\"%; s%^address = \":8080\"%address = \":46080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:46090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:46091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:46545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:46546\"%" $HOME/.dymension/config/app.toml
```
# Start service and check the logs
```
sudo systemctl start dymd && sudo journalctl -u dymd -f --no-hostname -o cat
```
# Useful commands
Useful set of commands for node operators. From key management to chain governance.

# 🔑 Key management
Add new key
```
dymd keys add wallet
```
Recover existing key
```
dymd keys add wallet --recover
```
List all keys
```
dymd keys list
```
Delete key
```
dymd keys delete wallet
```
Export key to the file
```
dymd keys export wallet
```
Import key from the file
```
dymd keys import wallet wallet.backup
```
Query wallet balance
```
dymd q bank balances $(dymd keys show wallet -a)
```
# 👷 Validator management
Please make sure you have adjusted moniker, identity, details and website to match your values.
Create new validator
```
dymd tx staking create-validator \
--amount 1000000udym \
--pubkey $(dymd tendermint show-validator) \
--moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id 35-C \
--commission-rate 0.05 \
--commission-max-rate 0.20 \
--commission-max-change-rate 0.01 \
--min-self-delegation 1 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.025udym \
-y
```
Edit existing validator
```
dymd tx staking edit-validator \
--new-moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL"
--chain-id 35-C \
--commission-rate 0.05 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.025udym \
-y
```
Unjail validator
```
dymd tx slashing unjail --from wallet --chain-id 35-C --gas-adjustment 1.4 --gas auto --gas-prices 0.025udym -y
```
Jail reason
```
dymd query slashing signing-info $(dymd tendermint show-validator)
```
List all active validators
```
dymd q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```
List all inactive validators
```
dymd q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```
View validator details
```
dymd q staking validator $(dymd keys show wallet --bech val -a)
```

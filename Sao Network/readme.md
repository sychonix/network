
<p align="center">
  <img height="100" height="auto" src="https://i.imgur.com/bZzE0Ie.png">
</p>

# Sao Network Testnet | Chain ID : sao-testnet0 | Port : 245
### Setup validator name
Replace **YOUR_MONIKER** with your validator name
```
MONIKER="YOUR_MONIKER"
```
### **Install dependencies**
Update system and install build tools
```
sudo apt -q update
sudo apt -qy install curl git jq lz4 build-essential
sudo apt -qy upgrade
```

### Install Go
```
sudo rm -rf /usr/local/go
curl -Ls https://go.dev/dl/go1.19.6.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)
```

### **Download and build binaries**
```
# Clone project repository
cd $HOME
rm -rf sao-consensus
git clone https://github.com/SaoNetwork/sao-consensus.git
cd sao-consensus
git checkout testnet0

# Build binaries
make build

# Prepare binaries for Cosmovisor
mkdir -p $HOME/.sao/cosmovisor/genesis/bin
mv build/linux/saod $HOME/.sao/cosmovisor/genesis/bin/
rm -rf build

# Create application symlinks
ln -s $HOME/.sao/cosmovisor/genesis $HOME/.sao/cosmovisor/current
sudo ln -s $HOME/.sao/cosmovisor/current/bin/saod /usr/local/bin/saod
```
# Install Cosmovisor and create a service
```
# Download and install Cosmovisor
# Download and install Cosmovisor
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0

# Create service
sudo tee /etc/systemd/system/saod.service > /dev/null << EOF
[Unit]
Description=sao-testnet node service
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.sao"
Environment="DAEMON_NAME=saod"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.sao/cosmovisor/current/bin"

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable saod
```
### **Initialize the node**
```
# Set node configuration
saod config chain-id sao-testnet0
saod config keyring-backend test
saod config node tcp://localhost:49657

# Initialize the node
saod init $MONIKER --chain-id sao-testnet0

# Download genesis and addrbook
curl -Ls https://snapshots.kjnodes.com/sao-testnet/genesis.json > $HOME/.sao/config/genesis.json
curl -Ls https://snapshots.kjnodes.com/sao-testnet/addrbook.json > $HOME/.sao/config/addrbook.json

# Add seeds
sed -i -e "s|^seeds *=.*|seeds = \"3f472746f46493309650e5a033076689996c8881@sao-testnet.rpc.kjnodes.com:49659\"|" $HOME/.sao/config/config.toml

# Set minimum gas price
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.0001sao\"|" $HOME/.sao/config/app.toml

# Set pruning
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.sao/config/app.toml

# Set custom ports
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:49658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:49657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:49060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:49656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":49660\"%" $HOME/.sao/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:49317\"%; s%^address = \":8080\"%address = \":49080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:49090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:49091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:49545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:49546\"%" $HOME/.sao/config/app.toml
```
### **Start service and check the logs**
```
sudo systemctl start saod && sudo journalctl -u saod -f --no-hostname -o cat
```
### **Useful Commands**

------------------------
### **🔑 Key management**
Add new key
```
saod keys add wallet
```
Recover existing key
```
nibid keys add wallet --recover
```
Export key to the file
```
saod keys export wallet
```
List all keys
```
saod keys list
```
Import key from the file
```
saod keys import wallet wallet.backup
```
Delete key
```
saod keys delete wallet
```
Query wallet balance
```
saod q bank balances $(andromedad keys show wallet -a)
```
------------------------

### 👷 Validator management
Create new validator
``` 
saod tx staking create-validator \
--amount 1000000sao \
--pubkey $(saod tendermint show-validator) \
--moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id sao-testnet0 \
--commission-rate 0.05 \
--commission-max-rate 0.20 \
--commission-max-change-rate 0.01 \
--min-self-delegation 1 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.0001sao \
-y
```
Edit existing validator
```
saod tx staking edit-validator \
--new-moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL"
--chain-id sao-testnet0 \
--commission-rate 0.05 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.0001sao \
-y
```
Unjail validator
```
saod tx slashing unjail --from wallet --chain-id sao-testnet0 --gas-adjustment 1.4 --gas auto --gas-prices 0.0001sao -y
```
Jail reason
```
saod query slashing signing-info $(saod tendermint show-validator)
```
### 💲 Token management
Delegate tokens to yourself
```
saod tx staking delegate $(saod keys show wallet --bech val -a) 1000000sao --from wallet --chain-id sao-testnet0 --gas-adjustment 1.4 --gas auto --gas-prices 0.0001sao -y
```
Delegate tokens to validator
```
saod tx staking delegate <TO_VALOPER_ADDRESS> 1000000sao --from wallet --chain-id sao-testnet0 --gas-adjustment 1.4 --gas auto --gas-prices 0.0001sao -y
```
Send tokens to the wallet
```
saod tx bank send wallet <TO_WALLET_ADDRESS> 1000000sao --from wallet --chain-id sao-testnet0 --gas-adjustment 1.4 --gas auto --gas-prices 0.0001sao -y
```
### 🚨 Maintenance
Get validator info
```
saod status 2>&1 | jq .ValidatorInfo
```
Get sync info
```
saod status 2>&1 | jq .SyncInfo
```

Remove node
***Please, before proceeding with the next step! All chain data will be lost! Make sure you have backed up your priv_validator_key.json!***
```
cd $HOME
sudo systemctl stop saod
sudo systemctl disable saod
sudo rm /etc/systemd/system/saod.service
sudo systemctl daemon-reload
rm -f $(which saod)
rm -rf $HOME/.sao
rm -rf $HOME/sao-consensus
```

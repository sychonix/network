
<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/andromeda.png">
</p>

# Andromeda Testnet | Chain ID : galileo-3 | Custom Port : 244

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
curl -Ls https://go.dev/dl/go1.19.7.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)
```

### **Download and build binaries**
```
# Clone project repository
cd $HOME
rm -rf andromedad
git clone https://github.com/andromedaprotocol/andromedad.git
cd andromedad
git checkout galileo-3-v1.1.0-beta1
```

# Build binaries
```
make build
```

# Prepare binaries for Cosmovisor
```
mkdir -p $HOME/.andromedad/cosmovisor/genesis/bin
mv build/andromedad $HOME/.andromedad/cosmovisor/genesis/bin/
rm -rf build
```

# Create application symlinks
```
ln -s $HOME/.andromedad/cosmovisor/genesis $HOME/.andromedad/cosmovisor/current
sudo ln -s $HOME/.andromedad/cosmovisor/current/bin/andromedad /usr/local/bin/andromedad
</pre>
```

### **Install Cosmovisor and create a service** 
# Download and install Cosmovisor

```
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0
```

# Create service
```
sudo tee /etc/systemd/system/andromedad.service > /dev/null << EOF
[Unit]
Description=andromeda-testnet node service
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.andromedad"
Environment="DAEMON_NAME=andromedad"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.andromedad/cosmovisor/current/bin"

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable andromedad
```

### **Initialize the node**
```
# Set node configuration
andromedad config chain-id galileo-3
andromedad config keyring-backend test
andromedad config node tcp://localhost:47657

# Initialize the node
andromedad init $MONIKER --chain-id galileo-3

# Download genesis and addrbook
curl -Ls https://snapshots.sychonix.com/andromeda-testnet/genesis.json > $HOME/.andromedad/config/genesis.json
curl -Ls https://snapshots.sychonix.com/andromeda-testnet/addrbook.json > $HOME/.andromedad/config/addrbook.json

# Add seeds
sed -i -e "s|^seeds *=.*|seeds = \"3f472746f46493309650e5a033076689996c8881@andromeda-testnet.rpc.kjnodes.com:47659\"|" $HOME/.andromedad/config/config.toml

# Set minimum gas price
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.0001uandr\"|" $HOME/.andromedad/config/app.toml

# Set pruning
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.andromedad/config/app.toml

# Set custom ports
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:47658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:47657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:47060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:47656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":47660\"%" $HOME/.andromedad/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:47317\"%; s%^address = \":8080\"%address = \":47080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:47090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:47091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:47545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:47546\"%" $HOME/.andromedad/config/app.toml
```

### **Download latest chain snapshot**
```
curl -L https://snapshots.sychonix.com/andromeda-testnet/snapshot_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.andromedad
[[ -f $HOME/.andromedad/data/upgrade-info.json ]] && cp $HOME/.andromedad/data/upgrade-info.json $HOME/.andromedad/cosmovisor/genesis/upgrade-info.json
```
### **Start service and check the logs**
```
sudo systemctl start andromedad && sudo journalctl -u andromedad -f --no-hostname -o cat
```
### **Useful Commands**

------------------------
### **🔑 Key management**
Add new key
```
andromedad keys add wallet
```
Recover existing key
```
andromedad keys add wallet --recover
```
Export key to the file
```
andromedad keys export wallet
```
List all keys
```
andromedad keys list
```
Import key from the file
```
andromedad keys import wallet wallet.backup
```
Delete key
```
andromedad keys delete wallet
```
Query wallet balance
```
andromedad q bank balances $(andromedad keys show wallet -a)
```
------------------------

### 👷 Validator management
Create new validator
``` 
andromedad tx staking create-validator \
--amount 1000000uandr \
--pubkey $(andromedad tendermint show-validator) \
--moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id galileo-3 \
--commission-rate 0.05 \
--commission-max-rate 0.20 \
--commission-max-change-rate 0.01 \
--min-self-delegation 1 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.0001uandr \
-y
```
Edit existing validator
```
andromedad tx staking edit-validator \
--new-moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL"
--chain-id galileo-3 \
--commission-rate 0.05 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.0001uandr \
-y
```
Unjail validator
```
andromedad tx slashing unjail --from wallet --chain-id galileo-3 --gas-adjustment 1.4 --gas auto --gas-prices 0.0001uandr -y
```
Jail reason
```
andromedad query slashing signing-info $(andromedad tendermint show-validator)
```
List all active validators
```
andromedad q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```
List all inactive validators
```
andromedad q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```
View validator details
```
andromedad q staking validator $(andromedad keys show wallet --bech val -a)
```
### 💲 Token management
Withdraw rewards from all validators
```
andromedad tx distribution withdraw-all-rewards --from wallet --chain-id galileo-3 --gas-adjustment 1.4 --gas auto --gas-prices 0.0001uandr -y
```
Withdraw commission and rewards from your validator
```
andromedad tx distribution withdraw-rewards $(andromedad keys show wallet --bech val -a) --commission --from wallet --chain-id galileo-3 --gas-adjustment 1.4 --gas auto --gas-prices 0.0001uandr -y
```
Delegate tokens to yourself
```
andromedad tx staking delegate $(andromedad keys show wallet --bech val -a) 1000000uandr --from wallet --chain-id galileo-3 --gas-adjustment 1.4 --gas auto --gas-prices 0.0001uandr -y
```
Delegate tokens to validator
```
andromedad tx staking delegate <TO_VALOPER_ADDRESS> 1000000uandr --from wallet --chain-id galileo-3 --gas-adjustment 1.4 --gas auto --gas-prices 0.0001uandr -y
```
Redelegate tokens to another validator
```
andromedad tx staking redelegate $(andromedad keys show wallet --bech val -a) <TO_VALOPER_ADDRESS> 1000000uandr --from wallet --chain-id galileo-3 --gas-adjustment 1.4 --gas auto --gas-prices 0.0001uandr -y
```
Unbond tokens from your validator
```
andromedad tx staking unbond $(andromedad keys show wallet --bech val -a) 1000000uandr --from wallet --chain-id galileo-3 --gas-adjustment 1.4 --gas auto --gas-prices 0.0001uandr -y
```
Send tokens to the wallet
```
andromedad tx bank send wallet <TO_WALLET_ADDRESS> 1000000uandr --from wallet --chain-id galileo-3 --gas-adjustment 1.4 --gas auto --gas-prices 0.0001uandr -y
```
### 🚨 Maintenance
Get validator info
```
andromedad status 2>&1 | jq .ValidatorInfo
```
Get sync info
```
andromedad status 2>&1 | jq .SyncInfo
```
Get node peer
```
echo $(andromedad tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.andromedad/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```
Check if validator key is correct
```
[[ $(andromedad q staking validator $(andromedad keys show wallet --bech val -a) -oj | jq -r .consensus_pubkey.key) = $(andromedad status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```
Get live peers
```
curl -sS http://localhost:47657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```
Set minimum gas price
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0001uandr\"/" $HOME/.andromedad/config/app.toml
```
Enable prometheus
```
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.andromedad/config/config.toml
```
Reset chain data
```
andromedad tendermint unsafe-reset-all --home $HOME/.andromedad --keep-addr-book
```
Remove node
***Please, before proceeding with the next step! All chain data will be lost! Make sure you have backed up your priv_validator_key.json!***
```
cd $HOME
sudo systemctl stop andromedad
sudo systemctl disable andromedad
sudo rm /etc/systemd/system/andromedad.service
sudo systemctl daemon-reload
rm -f $(which andromedad)
rm -rf $HOME/.andromedad
rm -rf $HOME/andromedad
```
### ⚙️ Service Management
Reload service configuration
```
sudo systemctl daemon-reload
```
Enable service
```
sudo systemctl enable andromedad
```
Disable service
```
sudo systemctl disable andromedad
```
Start service
```
sudo systemctl start andromedad
```
Stop service
```
sudo systemctl stop andromedad
```
Restart service
```
sudo systemctl restart andromedad
```
Check service status
```
sudo systemctl status andromedad
```
Check service logs
```
sudo journalctl -u andromedad -f --no-hostname -o cat
```


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

### Disable State Sync 
After successful synchronization using state sync above, we advise you to disable synchronization with state sync and restart the node
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.andromedad/config/config.toml
sudo systemctl restart andromedad && journalctl -u andromedad -f -o cat
```

### Live Peers
```
PEERS="8083dd301a7189284bf5b8d40c4cf239360d653a@5.9.122.49:26656,749114faeb62649d94b8ed496efbdcd4a08b2e3e@136.243.93.134:20095,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:47656,ef6ec2cf74e157e3c6056c0469f3ede08b418ec7@144.76.164.139:15656,c5f6021d8da08ff53e90725c0c2a77f8d65f5e03@195.201.195.40:26656,f1d30c5f2d5882823317718eb4455f87ae846d0a@85.239.235.235:30656,334a842f175c2c24c6b11e8bce39c9d3443471ae@38.242.213.79:26656,d78df88bc4a487c140e466a23f549ed90e7ebfb6@161.97.152.157:27656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.andromedad/config/config.toml
```
### Addrbook (Update every hour)
```
curl -Ls https://snap.nodexcapital.com/andromeda/addrbook.json > $HOME/.andromedad/config/addrbook.json
```
### Genesis
```
curl -Ls https://snap.nodexcapital.com/andromeda/genesis.json > $HOME/.andromedad/config/genesis.json
```

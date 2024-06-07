<h1 align="center">Airchains</h1>

> WARNING: Keep the keys and private keys provided during the setup stages to prevent loss of your points in case of any error.

> We are installing the standard updates and requirements.

#

<h1 align="center">Hardware</h1>

```
Minimum: 2 vCPU 4 RAM
Recommended: 4vCPU 8 RAM
```
<h1 align="center">Setup</h1>

```console
# update
apt update && apt upgrade -y
sudo apt install -y curl git jq lz4 build-essential cmake perl automake autoconf libtool wget libssl-dev

# Install Go
sudo rm -rf /usr/local/go
curl -L https://go.dev/dl/go1.22.3.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> $HOME/.bash_profile
source .bash_profile
```

```console
# Cloning the necessary repositories
git clone https://github.com/airchains-network/evm-station.git
git clone https://github.com/airchains-network/tracks.git
```

```console
# Starting the setup of our evmos network, which is our own locally running network.
cd evm-station
go mod tidy
```

```console
# Complete the setup with this command.
/bin/bash ./scripts/local-setup.sh
```

# 

> RPC will be needed in the next stages, so let's configure it.

> At the bottom, the RPC section will be as follows.

```
nano ~/.evmosd/config/app.toml
```

![image](https://github.com/ruesandora/Airchains/assets/101149671/588a02d0-f7e3-4c25-ac25-ffff281206eb)

> This way, you have learned how to make cosmos RPCs public.

> To ensure the system file works correctly, we create an env.

```console
nano ~/.rollup-env
```

> Enter the necessary variables inside it.

```console
# You do not need to change anything in this code block.
CHAINID="stationevm_9000-1"
MONIKER="localtestnet"
KEYRING="test"
KEYALGO="eth_secp256k1"
LOGLEVEL="info"
HOMEDIR="$HOME/.evmosd"
TRACE=""
BASEFEE=1000000000
CONFIG=$HOMEDIR/config/config.toml
APP_TOML=$HOMEDIR/config/app.toml
GENESIS=$HOMEDIR/config/genesis.json
TMP_GENESIS=$HOMEDIR/config/tmp_genesis.json
        VAL_KEY="mykey"
```

> We write the service file. If you are using a user, change the `root` part accordingly.

```console
# You can copy and paste the entire block with a single command, my children
sudo tee /etc/systemd/system/rolld.service > /dev/null << EOF
[Unit]
Description=ZK
After=network.target

[Service]
User=root
EnvironmentFile=/root/.rollup-env
ExecStart=/root/evm-station/build/station-evm start --metrics "" --log_level info --json-rpc.api eth,txpool,personal,net,debug,web3 --chain-id stationevm_9000-1
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF
```

> We update and start the services.

```
sudo systemctl daemon-reload
sudo systemctl enable rolld
sudo systemctl start rolld
sudo journalctl -u rolld -f --no-hostname -o cat
```
> You should see the logs flowing.

![image](https://github.com/ruesandora/Airchains/assets/101149671/64137490-6b3b-4678-ae26-81c90dd1f952)

#

This command will give us a private key, keep it safe.
```console
/bin/bash ./scripts/local-keys.sh
```

#

We will use eigenlayer as the DA layer. For this, we need a key; we download the binary and give it permission to run.
You can also check out the official documentation for celestia and avail setups.
You can use a mock DA (they said they will allow point earning with mock for a while).
Currently, you cannot change the DA in testnet; they said they will make this possible with an update.

My reason for choosing EigenDA is that it is the easiest, along with Celestia (and tokens are easy to find); we know Celestia by heart - this time, let's go with Eigen.

#

```console
cd $HOME
wget https://github.com/airchains-network/tracks/releases/download/v0.0.2/eigenlayer
mkdir -p $HOME/go/bin
chmod +x $HOME/eigenlayer
mv $HOME/eigenlayer $HOME/go/bin
```

```console
# Replace `WALLETNAME` and save the ECDSA Private Key given to you in the output.
# Close with Ctrl+c, hit enter, and note down the given `public hex`, you will need it later.
# Send 0.5 eth to the given 0x evm address on the holesky network just in case.

eigenlayer operator keys create --key-type ecdsa WALLETNAME
```

> Now we move on to the track and station parts.

```console
cd $HOME
cd tracks
go mod tidy
```

> While inside the tracks folder, start the code below. ```PUBLICHEX``` will be the public key you just received.

> You can change MONIKER (validator name) as you like.

```console
go run cmd/main.go init --daRpc "disperser-holesky.eigenda.xyz" --daKey "PUBLICHEX" --daType "eigen" --moniker "MONIKER" --stationRpc "http://127.0.0.1:8545" --stationAPI "http://127.0.0.1:8545" --stationType "evm"
```

#

> The output will be as follows

![tg_image_2547108070](https://github.com/ruesandora/Airchains/assets/101149671/463e6802-ab58-4e3b-86d2-8ba8c1c15819)

# 

> Now we create a tracker address. Replace `TRACKERWALLET`.

> Save the output, get tokens from the [discord](https://discord.gg/airchains) `switchyard faucet` channel with the air prefixed wallet.

```console
go run cmd/main.go keys junction --accountName TRACKERWALLET --accountPath $HOME/.tracks/junction-accounts/keys
```

> Then we run the prover.

```console
go run cmd/main.go prover v1EVM
```

> Now we need the node id, get it from here.

```console
# You can search for node id with ctrl w, go to the bottom and a little up
nano ~/.tracks/config/sequencer.toml
```

![image](https://github.com/ruesandora/Airchains/assets/101149671/8be10bf2-c873-4e97-a40d-2dd148854991)

#

> In the code below

> `TRACKERWALLET` is the name you wrote above

> `TRACKERWALLET-ADDRESS` is the air wallet

> `IP` is your IP address

> `NODEID` is the node id obtained from sequencer.toml

```console
go run cmd/main.go create-station --accountName TRACKERWALLET --accountPath $HOME/.tracks/junction-accounts/keys --jsonRPC "https://airchains-testnet-rpc.cosmonautstakes.com/" --info "EVM Track" --tracks TRACKERWALLET-ADDRESS --bootstrapNode "/ip4/IP/tcp/2300/p2p/NODEID"
```

#

> We have set up the station, now let's run it with a service.

> Those who do not want to run the service can open a screen and run the command `go run cmd/main.go start` in the tracks folder.

```console
sudo tee /etc/systemd/system/stationd.service > /dev/null << EOF
[Unit]
Description=station track service
After=network-online.target
[Service]
User=root
WorkingDirectory=/root/tracks/
ExecStart=/usr/local/go/bin/go run cmd/main.go start
Restart=always
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
```

```console
sudo systemctl daemon-reload
sudo systemctl enable stationd
sudo systemctl restart stationd
sudo journalctl -u stationd -f --no-hostname -o cat
```

<h1 align="center">Setup is complete, but?</h1>

The setup is complete. But you are not earning points yet.
Import the mnemonic of your tracker wallet into leap wallet and connect at https://points.airchains.io/
You can see the station and your points on the dashboard.
Since we haven't made any transactions yet, 100 points will appear as pending. The reason for this is that you need to create a pod to earn points.
You can think of a pod as a package consisting of 25 txs. Every 25 txs will create 1 pod, and you will earn 5 points from these transactions.
The initial 100 points will be

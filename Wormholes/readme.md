<p style="font-size:14px" align="right">
<a href="https://t.me/GenzDrops" target="_blank">Join our telegram <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>

# RUNNING YOUR OWN NODE

## Environment and Hardware
Wormholes clients are able to run on consumer-grade computers and do not require any special hardware, such as mining machines.
Therefore, you have more options for deploying the node based on your demands. let us think about running a node on both a local physical machine and a cloud server:

## Hardware
### Minimum requirements
* CPU: Main frequency 2.9GHz, 4 cores or above CPU.
* Memory: Capacity 8GB or more.
* Hard Disk: Capacity 500GB or more.
* Network bandwidth: 6M uplink and downlink peer-to-peer rate or higher

## Prepare

First generate your own account through [WORMHOLES WALLET](https://www.limino.com/).

- Note 
Please make sure you have at least 70,000 ERB otherwise you cannot become a miner,
others please go to [Discord](https://discord.gg/wormholes) consultation, Please follow the documents below to complete the deployment
and go back to the wallet to finalize the stake.

Update Machine
```
sudo apt update && sudo apt upgrade -y
```

## Run Node 

* Install docker
```
sudo apt install docker.io -y
```

* Open Port (opsional)
```
ufw allow 30303 && ufw allow 8548 && ufw enable -y
```

* Download script and Run 

```
wget -O start.sh https://raw.githubusercontent.com/Genz22/Testnet-node/main/WORMHOLES/start.sh && chmod +x start.sh && ./start.sh
```

Output
> Enter your private key：

You can input private key Wormholes Wallet

## BECOME A MINER

Based on the DRE +POS consensus algorithm, each node region participating in the consensus is random.
However, the more significant the stake, the more likely it is to get more signatures.
With more probability of getting each block balance reward, such as 0.1 ERB for each incentive, 10 ERB can be obtained with 100 signatures.
(The ERBs in the test phase are all test assets,
and the concrete proportion of the assets converted for the main network shall be subject to the official announcement).

**Here for detail** [OFFICIAL DOCS](https://wormholes.com/docs/Install/stake/index.html)

## Check Node / Command

* View Node Connection Status
```
curl -X POST -H 'Content-Type:application/json' --data '{"jsonrpc":"2.0","method":"net_peerCount","id":1}' http://127.0.0.1:8545
```

* Check Account Balance
```
curl -X POST -H 'Content-Type:application/json' --data '{"jsonrpc":"2.0","method":"eth_getBalance","params":["<address>","pending"],"id":1}' http://127.0.0.1:8545
```

* Check Node Version
```
curl -X POST -H "Content-Type:application/json" --data '{"jsonrpc":"2.0","method":"eth_version","id":64}' http://127.0.0.1:8545
```

* Check Nodekey must be the same as your wallet's private key
```
cat /wm/.wormholes/wormholes/nodekey
```

If not same You can try with `./start.sh`

## Monitor Your Node 

* Download Script
```
wget -O monitor.sh https://raw.githubusercontent.com/Genz22/Testnet-node/main/WORMHOLES/monitor.sh + chmod +x monitor.sh
```

* Run 
```
./monitor.sh
```

Close with `CTRL + C`
And run again with `./monitor.sh`

## Upgrade Node

```
./start.sh
```
  
* Browser

[Block Scan](https://www.wormholesscan.com/#/Validator)

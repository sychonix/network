
layout: '~/layouts/MarkdownLayout.astro'
title: Installation Node
network: Testnet
icon: elixir
---

### Install docker compose
```
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```
```
sudo chmod +x /usr/local/bin/docker-compose
```
### Setup your elixir node
Download the Dockerfile for the Elixir
```
wget https://files.elixir.finance/Dockerfile
```
### Setup the Dockerfile with your wallet info:
```
nano Dockerfile
```
and update it from:
```
FROM elixirprotocol/validator:testnet-1

ENV ADDRESS=<your_address>
ENV PRIVATE_KEY=<your_private_key>
ENV VALIDATOR_NAME=<your_name>
```
Then press `ctrl + x`, then `y`, then `enter`
### Build the Docker image
```
docker build . -f Dockerfile -t elixir-validator
```
It will take some time to build but once its done you can run the validator by executing the following:
```
docker run -it --name ev elixir-validator
```
### Enrol your Wallet as a validator
- Navigate to the [Elixir Network Dashboard](https://dashboard.elixir.finance/) with your wallet-connected browser. Connect with Metamask and switch to the Goerli network.

- Claim your ELXR (If you were part of testnet V1 you would be eligible to receive ELXR). If you need Goerli ETH, you can ask in the [Discord server](https://discord.gg/puzc28Xq).

- Once you have received ELXR tokens, you will need to stake those tokens. Any amount from 100–1000 ELXR will do.

- Next, enroll your validator. You can click the enroll button, and then enter the wallet address used to spin up your validator in the prior steps. Note: there can be a delay before the enrol button becomes active.

- Once this transaction is confirmed, check the [leaderboard](https://dashboard.elixir.finance/leaderboard) to ensure your address is enrolled.

- Then, verify that valid orders are being processed by finding your validator on the [metrics page](https://dashboard.elixir.finance/metrics).

# check log node
```
docker logs -f <Container ID>
```

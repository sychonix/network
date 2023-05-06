
<p align="center">
  <img height="100" height="auto" src="elixir.png">
</p>

# Elixir Protocol
###

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
Then press ctrl + x, then y, then enter
### Build the Docker image
```
docker build . -f Dockerfile -t elixir-validator
```
It will take some time to build but once its done you can run the validator by executing the following:
```
docker run -it --name ev elixir-validator
```

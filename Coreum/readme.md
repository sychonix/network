
<p align="center">
  <img height="100" height="auto" src="https://github.com/nodexcapital/explorer/blob/master/public/logos/coreum.png">
</p>

# Coreum Testnet | Chain ID : coreum-testnet-1

### Official Documentation:
>- [Validator setup instructions](https://docs.coreum.dev/validator/run-validator.html)


Keep $COREUM_HOME/config/node_key.json and $COREUM_HOME/config/priv_validator_key.json files in a safe place, since they can be used to recover the validator node!

# Set the moniker variable to reuse it in the following instructions.

export MONIKER="validator"
 
Set waiting window between validator restart to avoid double signing.
(Check if $COREUM_NODE_CONFIG is set(it should be there, if you haven't exited from the beginning of installation)

crudini --set $COREUM_NODE_CONFIG consensus double_sign_check_height 10
Init new account (if you don't have existing), which will be used for validator control, delegation and staking rewards/commission receiving

cored keys add $MONIKER --keyring-backend os
You will be asked to set the keyring passphrase, set it, and remember/save it, since you will need it to access your private key.

The output example:

- name: validator
  type: local
  address: testcorevaloper15fr7w6trtx8nzkjp33tcqj922q6r82tp05gdpe
  pubkey: '{"@type":"/cosmos.crypto.secp256k1.PubKey","key":"AwzsffiidUiFtmNng5pLTH6cj1hv4Ufa+zKZpmRVGfNk"}'
  mnemonic: ""

**Important** write this mnemonic phrase in a safe place.
It is the only way to recover your account if you ever forget your password.

nice equal sample cabbage demise online winner lady theory invest clarify organ divorce wheel patient gap group endless security price smoke insane link position
Attention! Keep the mnemonic phrase in a safe place, since it can be used to recover the key! (Don't be confused with empty mnemonic after pubkey, it is shown in the end of the output)

If you have the mnemonic you can import it (skip it if you generated account at the previous step)

cored keys add $MONIKER --keyring-backend os --recover
You will be asked to "Enter keyring passphrase" and "Enter your bip39 mnemonic".

Derive the validator-operator address, which will be used for validator creation.

cored keys show $MONIKER --bech val --address --keyring-backend os
# output example:
# testcorevaloper15fr7w6trtx8nzkjp33tcqj922q6r82tp05gdpe
Fund the account.

You can find the recommended amount with calculation at this page.
For the Testnet you can request test tokens at discord channel
Check that you have enough to create the validator(minimum self delegation is 20k)

cored q bank balances  $(cored keys show $MONIKER --address --keyring-backend os) --denom $COREUM_DENOM --node=$COREUM_NODE
Wait until node is fully synced(its important). To check sync status run next command:

echo "catching_up: $(echo  $(cored status) | jq -r '.SyncInfo.catching_up')"
If the output is catching_up: false, then the node is fully synced.

Create validator

set up validator configuration

 # COREUM_VALIDATOR_DELEGATION_AMOUNT default is 20k, must be grater or equal COREUM_MIN_DELEGATION_AMOUNT.
 # We suggest setting 30k, in case of slashing you will be able to unjail validator without replenishing your balance.
 # (Otherwise your validator balance will went below 20k and to start it you should transfer tokens first)
 export COREUM_VALIDATOR_DELEGATION_AMOUNT=20000000000 # (Required) 
 export COREUM_VALIDATOR_NAME="" # (Required) update it with the name which is visible on the explorer
 export COREUM_VALIDATOR_WEB_SITE="" # (Optional) update with the site
 export COREUM_VALIDATOR_IDENTITY="" # (Optional) update with identity id, which can generated on the site https://keybase.io/
 export COREUM_VALIDATOR_COMMISSION_RATE="0.10" # (Required) Update with your commission rate
 export COREUM_VALIDATOR_COMMISSION_MAX_RATE="0.20" # (Required) Update with your commission max rate
 export COREUM_VALIDATOR_COMMISSION_MAX_CHANGE_RATE="0.01" # (Required) Update with your commission max change rate
 export COREUM_MIN_DELEGATION_AMOUNT=20000000000 # (Required) default 20k, must be grater or equal min_self_delegation parameter on the current chain
create validator

cored tx staking create-validator \
--amount=$COREUM_VALIDATOR_DELEGATION_AMOUNT$COREUM_DENOM \
--pubkey="$(cored tendermint show-validator)" \
--moniker="$COREUM_VALIDATOR_NAME" \
--website="$COREUM_VALIDATOR_WEB_SITE" \
--identity="$COREUM_VALIDATOR_IDENTITY" \
--commission-rate="$COREUM_VALIDATOR_COMMISSION_RATE" \
--commission-max-rate="$COREUM_VALIDATOR_COMMISSION_MAX_RATE" \
--commission-max-change-rate="$COREUM_VALIDATOR_COMMISSION_MAX_CHANGE_RATE" \
--min-self-delegation=$COREUM_MIN_DELEGATION_AMOUNT \
--gas auto \
--chain-id=$COREUM_CHAIN_ID \
--from=$MONIKER \
--keyring-backend os -y -b block $COREUM_CHAIN_ID_ARGS
(Optional) Troubleshooting

Error:

Error: rpc error: code = NotFound desc = rpc error: code = NotFound desc = account testcore15fr7w6trtx8nzkjp33tcqj922q6r82tp077avs not found: key not found
It means that your node is not synced yet, wait for the full sync

Error:

Enter keyring passphrase: Error: invalid character 'o' looking for beginning of value Usage: cored tx staking create-validator [flags]
One of the reasons could be by using --home tag during full-node creation and skipping that tag in validator commands.

So, be consistent in your full node and validator commands.

(Optional) You will receive tx hash, final status of which you can check at block explorer.

Check the validator status.

cored q staking validator "$(cored keys show $MONIKER --bech val --address $COREUM_CHAIN_ID_ARGS)"
If you see status: BOND_STATUS_BONDED in the output, then the validator joined active set and is validating.

What is next?
If you don't want to expose your validator node to the internet, but still want to interact with the network, you can run sentry node using the doc.

Last Updated: 13/3/2023, 16.26.51

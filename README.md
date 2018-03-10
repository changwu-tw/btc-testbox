# bitcoin-testnet-box
[![docker pulls](https://img.shields.io/docker/pulls/freewil/bitcoin-testnet-box.svg?style=flat)](https://hub.docker.com/r/freewil/bitcoin-testnet-box/)

Create your own private bitcoin testnet

You must have `bitcoind` and `bitcoin-cli` installed on your system and in the
path unless running this within a [Docker](https://www.docker.com) container
(see [below](#using-with-docker)).

## Starting the testnet-box

This will start up two nodes using the two datadirs `1` and `2`. They
will only connect to each other in order to remain an isolated private testnet.
Two nodes are provided, as one is used to generate blocks and it's balance
will be increased as this occurs (imitating a miner). You may want a second node
where this behavior is not observed.

Node `1` will listen on port `19000`, allowing node `2` to connect to it.

Node `1` will listen on port `19001` and node `2` will listen on port `19011`
for the JSON-RPC server.


```
$ make start
```

## Check the status of the nodes

```
$ make getnetworkinfo
bitcoin-cli -datadir=1  getnetworkinfo
{
  "version": 160000,
  "subversion": "/Satoshi:0.16.0/",
  "protocolversion": 70015,
  "localservices": "000000000000040d",
  "localrelay": true,
  "timeoffset": 0,
  "networkactive": true,
  "connections": 1,
  "networks": [
    {
      "name": "ipv4",
      "limited": false,
      "reachable": true,
      "proxy": "",
      "proxy_randomize_credentials": false
    },
    {
      "name": "ipv6",
      "limited": false,
      "reachable": true,
      "proxy": "",
      "proxy_randomize_credentials": false
    },
    {
      "name": "onion",
      "limited": true,
      "reachable": false,
      "proxy": "",
      "proxy_randomize_credentials": false
    }
  ],
  "relayfee": 0.00001000,
  "incrementalfee": 0.00001000,
  "localaddresses": [
  ],
  "warnings": ""
}
bitcoin-cli -datadir=2  getnetworkinfo
{
  "version": 160000,
  "subversion": "/Satoshi:0.16.0/",
  "protocolversion": 70015,
  "localservices": "000000000000040d",
  "localrelay": true,
  "timeoffset": 0,
  "networkactive": true,
  "connections": 1,
  "networks": [
    {
      "name": "ipv4",
      "limited": false,
      "reachable": true,
      "proxy": "",
      "proxy_randomize_credentials": false
    },
    {
      "name": "ipv6",
      "limited": false,
      "reachable": true,
      "proxy": "",
      "proxy_randomize_credentials": false
    },
    {
      "name": "onion",
      "limited": true,
      "reachable": false,
      "proxy": "",
      "proxy_randomize_credentials": false
    }
  ],
  "relayfee": 0.00001000,
  "incrementalfee": 0.00001000,
  "localaddresses": [
  ],
  "warnings": ""
}
```

## Generating blocks

Normally on the live, real, bitcoin network, blocks are generated, on average,
every 10 minutes. Since this testnet-in-box uses Bitcoin Core's (bitcoind)
regtest mode, we are able to generate a block on a private network
instantly using a simple command.

To generate a block:

```
$ make generate
```

To generate more than 1 block:

```
$ make generate BLOCKS=10
```

## Need to generate at least 100 blocks before there will be a balance in the first wallet
```
$ make generate BLOCKS=200
```

## Verify that there is a balance on the first wallet
```
$ make getwalletinfo
bitcoin-cli -datadir=1  getwalletinfo
{
  "walletname": "wallet.dat",
  "walletversion": 159900,
  "balance": 5550.00000000,
  "unconfirmed_balance": 0.00000000,
  "immature_balance": 3450.00000000,
  "txcount": 211,
  "keypoololdest": 1520705125,
  "keypoolsize": 999,
  "keypoolsize_hd_internal": 1000,
  "paytxfee": 0.00000000,
  "hdmasterkeyid": "7c157dd7da402a2f9628628a9069227fcb703587"
}
bitcoin-cli -datadir=2  getwalletinfo
{
  "walletname": "wallet.dat",
  "walletversion": 159900,
  "balance": 0.00000000,
  "unconfirmed_balance": 0.00000000,
  "immature_balance": 0.00000000,
  "txcount": 0,
  "keypoololdest": 1520705125,
  "keypoolsize": 1000,
  "keypoolsize_hd_internal": 1000,
  "paytxfee": 0.00000000,
  "hdmasterkeyid": "39ffb247125a88fcab204633a3af7887676c54a6"
}
```

## Generate a wallet address for the second wallet
```
$ make address2
```

## Sending bitcoins
To send bitcoins that you've generated to the second wallet: (be sure to change the ADDRESS value below to wallet address generated in the prior command)

```
$ make sendfrom1 ADDRESS=2NGXMJYzSkNjXEhYxsN3WmtYWext3rD2bMU AMOUNT=10
```

## Does the balance show up?
Run the getinfo command again. Does the balance show up? Why not?
```
$ make getwalletinfo
```

## Generate another block
```
$ make generate
$ make getwalletinfo
bitcoin-cli -datadir=1  getwalletinfo
{
  "walletname": "wallet.dat",
  "walletversion": 159900,
  "balance": 5589.99996240,
  "unconfirmed_balance": 0.00000000,
  "immature_balance": 3425.00003760,
  "txcount": 213,
  "keypoololdest": 1520705125,
  "keypoolsize": 999,
  "keypoolsize_hd_internal": 1000,
  "paytxfee": 0.00000000,
  "hdmasterkeyid": "7c157dd7da402a2f9628628a9069227fcb703587"
}
bitcoin-cli -datadir=2  getwalletinfo
{
  "walletname": "wallet.dat",
  "walletversion": 159900,
  "balance": 10.00000000,
  "unconfirmed_balance": 0.00000000,
  "immature_balance": 0.00000000,
  "txcount": 1,
  "keypoololdest": 1520705125,
  "keypoolsize": 999,
  "keypoolsize_hd_internal": 1000,
  "paytxfee": 0.00000000,
  "hdmasterkeyid": "39ffb247125a88fcab204633a3af7887676c54a6"
}
```

## Stopping the testnet-box

```
$ make stop
```

To clean up any files created while running the testnet and restore to the
original state:

```
$ make clean
```

## Using with docker
This testnet-box can be used with [Docker](https://www.docker.com/) to run it in
an isolated container.

### Building docker image

Pull the image
  * `docker pull freewil/bitcoin-testnet-box`

or build it yourself from this directory
  * `docker build -t bitcoin-testnet-box .`

### Running docker container
The docker image will run two bitcoin nodes in the background and is meant to be
attached to allow you to type in commands. The image also exposes
the two JSON-RPC ports from the nodes if you want to be able to access them
from outside the container.
      
   `$ docker run -t -i -p 19001:19001 -p 19011:19011 freewil/bitcoin-testnet-box`

or if you built the docker image yourself:

   `$ docker run -t -i -p 19001:19001 -p 19011:19011 bitcoin-testnet-box`


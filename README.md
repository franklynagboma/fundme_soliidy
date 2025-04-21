## MakeFile

- deploy to sepolia
- deploy to sepolia and verify
- deploy to anvil with local host, you can change this to yours

## env

Create your .env file and append the values for;
- SEPOLIA_RPC_URL,
- ETHERSCAN_API_KEY,
- ANVIL_LOCAL_RPC_URL
From your terminal, use source .env to inject source added

## Account for private keys

Use below on your terminal
```shell
cast wallet import 'nameOfYourKey' --interactive
``` 
copy your private key to add to as `nameOfYouKey` above.

## Documentation

https://book.getfoundry.sh/

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
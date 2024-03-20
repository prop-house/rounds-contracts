# Farcaster Claim

## Contract Development

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Script

#### Deploy (Goerli)

```shell
forge script script/rounds/nouns/RetroRound.s.sol:RetroRound --chain 8453 --rpc-url https://mainnet.base.org --priority-gas-price 100000000 --broadcast
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```

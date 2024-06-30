<div align="center">
  <p align="center">
    <a href="https://rounds.wtf/" target="blank"><img src="https://i.imgur.com/WJb8mWi.png" width="200" alt="Rounds Logo" /></a>
  </p>
  <h1>Rounds Contracts</h1>
  <p>The smart contracts powering <a href="https://rounds.wtf/" target="blank">rounds.wtf</a></p>
</div>

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
forge script script/DeployV2.s.sol:Deploy --chain <chain_id> --rpc-url <rpc_url> --priority-gas-price 100000000 --broadcast --verify
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

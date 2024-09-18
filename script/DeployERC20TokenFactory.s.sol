// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Script} from 'forge-std/Script.sol';
import {ERC20Token} from 'src/tokens/ERC20Token.sol';
import {ERC20TokenFactory} from 'src/tokens/ERC20TokenFactory.sol';
import {UpgradeableBeacon} from 'openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol';
import {ERC1967Proxy} from 'openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol';

contract DeployERC20TokenFactory is Script {
    function run() public returns (ERC20TokenFactory factory) {
        uint256 deployerKey = vm.envUint('DEPLOYER_PRIVATE_KEY');
        vm.startBroadcast(deployerKey);

        address owner = vm.envAddress('OWNER_ADDRESS');

        bytes32 salt = bytes32(uint256(42));

        // forgefmt: disable-next-item
        address erc20TokenBeacon = address(new UpgradeableBeacon{salt: salt}(address(new ERC20Token{salt: salt}()), owner));
        address factoryImpl = address(new ERC20TokenFactory{salt: salt}(erc20TokenBeacon));

        factory = ERC20TokenFactory(
            address(new ERC1967Proxy{salt: salt}(factoryImpl, abi.encodeCall(ERC20TokenFactory.initialize, (owner))))
        );

        // Transfer ownership of the beacon to the factory.
        UpgradeableBeacon(erc20TokenBeacon).transferOwnership(address(factory));

        vm.stopBroadcast();
    }
}

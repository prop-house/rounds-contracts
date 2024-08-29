// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Script} from 'forge-std/Script.sol';
import {UserPayoutEscrow} from 'src/misc/UserPayoutEscrow.sol';
import {UserPayoutEscrowFactory} from 'src/misc/UserPayoutEscrowFactory.sol';
import {UpgradeableBeacon} from 'openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol';
import {ERC1967Proxy} from 'openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol';

contract DeployUserPayoutEscrowFactory is Script {
    function run() public returns (UserPayoutEscrowFactory factory) {
        uint256 deployerKey = vm.envUint('DEPLOYER_PRIVATE_KEY');
        vm.startBroadcast(deployerKey);

        address owner = vm.envAddress('OWNER_ADDRESS');
        address payer = vm.envAddress('PAYER_ADDRESS');

        address userPayoutEscrowBeacon = address(new UpgradeableBeacon(address(new UserPayoutEscrow()), owner));
        address factoryImpl = address(new UserPayoutEscrowFactory(userPayoutEscrowBeacon));

        factory = UserPayoutEscrowFactory(
            address(new ERC1967Proxy(factoryImpl, abi.encodeCall(UserPayoutEscrowFactory.initialize, (owner, payer))))
        );
        vm.stopBroadcast();
    }
}

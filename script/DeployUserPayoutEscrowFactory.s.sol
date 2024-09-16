// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Script} from 'forge-std/Script.sol';
import {UserPayoutEscrow} from 'src/escrows/UserPayoutEscrow.sol';
import {UserPayoutEscrowFactory} from 'src/escrows/UserPayoutEscrowFactory.sol';
import {UpgradeableBeacon} from 'openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol';
import {ERC1967Proxy} from 'openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol';

contract DeployUserPayoutEscrowFactory is Script {
    function run() public returns (UserPayoutEscrowFactory factory) {
        uint256 deployerKey = vm.envUint('DEPLOYER_PRIVATE_KEY');
        vm.startBroadcast(deployerKey);

        address owner = vm.envAddress('OWNER_ADDRESS');
        address payer = vm.envAddress('PAYER_ADDRESS');

        bytes32 salt = bytes32(uint256(42));

        // forgefmt: disable-next-item
        address userPayoutEscrowBeacon = address(new UpgradeableBeacon{salt: salt}(address(new UserPayoutEscrow{salt: salt}()), owner));
        address factoryImpl = address(new UserPayoutEscrowFactory{salt: salt}(userPayoutEscrowBeacon));

        factory = UserPayoutEscrowFactory(
            address(
                new ERC1967Proxy{salt: salt}(
                    factoryImpl, abi.encodeCall(UserPayoutEscrowFactory.initialize, (owner, payer))
                )
            )
        );
        vm.stopBroadcast();
    }
}

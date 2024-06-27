// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Script} from 'forge-std/Script.sol';
import {FarcasterClaimV1} from 'src/legacy/FarcasterClaimV1.sol';

contract DeployLegacy is Script {
    function run() public returns (FarcasterClaimV1 fc) {
        uint256 deployerKey = vm.envUint('DEPLOYER_PRIVATE_KEY');
        vm.startBroadcast(deployerKey);

        address owner = vm.envAddress('FC_OWNER_ADDRESS');
        address signer = vm.envAddress('FC_SIGNER_ADDRESS');

        fc = new FarcasterClaimV1(owner, signer);

        vm.stopBroadcast();
    }
}

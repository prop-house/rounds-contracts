// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Script} from 'forge-std/Script.sol';
import {FarcasterClaim} from 'src/FarcasterClaim.sol';

contract Deploy is Script {
    function run() public returns (FarcasterClaim fc) {
        uint256 deployerKey = vm.envUint('DEPLOYER_PRIVATE_KEY');
        vm.startBroadcast(deployerKey);

        address owner = vm.envAddress('FC_OWNER_ADDRESS');
        address signer = vm.envAddress('FC_SIGNER_ADDRESS');

        fc = new FarcasterClaim(owner, signer);

        vm.stopBroadcast();
    }
}

// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Script} from 'forge-std/Script.sol';
import {SingleRoundV2} from 'src/rounds/SingleRoundV2.sol';
import {UpgradeableBeacon} from 'openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol';

contract DeploySingleRoundV2Beacon is Script {
    function run() public returns (address singleRoundV2Beacon) {
        uint256 deployerKey = vm.envUint('DEPLOYER_PRIVATE_KEY');
        vm.startBroadcast(deployerKey);

        address owner = vm.envAddress('OWNER_ADDRESS');
        singleRoundV2Beacon = address(new UpgradeableBeacon(address(new SingleRoundV2()), owner));

        vm.stopBroadcast();
    }
}

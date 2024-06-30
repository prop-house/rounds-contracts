// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Script} from 'forge-std/Script.sol';
import {SingleRoundV1} from 'src/rounds/SingleRoundV1.sol';
import {UpgradeableBeacon} from 'openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol';

contract DeploySingleRoundV1Beacon is Script {
    function run() public returns (address singleRoundV1Beacon) {
        uint256 deployerKey = vm.envUint('DEPLOYER_PRIVATE_KEY');
        vm.startBroadcast(deployerKey);

        address owner = vm.envAddress('OWNER_ADDRESS');
        singleRoundV1Beacon = address(new UpgradeableBeacon(address(new SingleRoundV1()), owner));

        vm.stopBroadcast();
    }
}

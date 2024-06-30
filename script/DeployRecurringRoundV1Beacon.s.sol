// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Script} from 'forge-std/Script.sol';
import {RecurringRoundV1} from 'src/rounds/RecurringRoundV1.sol';
import {UpgradeableBeacon} from 'openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol';

contract DeployRecurringRoundV1Beacon is Script {
    function run() public returns (address recurringRoundV1Beacon) {
        uint256 deployerKey = vm.envUint('DEPLOYER_PRIVATE_KEY');
        vm.startBroadcast(deployerKey);

        address owner = vm.envAddress('OWNER_ADDRESS');
        recurringRoundV1Beacon = address(new UpgradeableBeacon(address(new RecurringRoundV1()), owner));

        vm.stopBroadcast();
    }
}

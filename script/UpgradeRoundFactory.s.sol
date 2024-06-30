// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Script} from 'forge-std/Script.sol';
import {RoundFactory} from 'src/RoundFactory.sol';

contract UpgradeRoundFactory is Script {
    function run() public returns (address factoryImpl) {
        uint256 deployerKey = vm.envUint('DEPLOYER_PRIVATE_KEY');
        vm.startBroadcast(deployerKey);

        RoundFactory factory = RoundFactory(vm.envAddress('ROUND_FACTORY'));

        address singleRoundV1Beacon = vm.envAddress('SINGLE_ROUND_V1_BEACON');
        address recurringRoundV1Beacon = vm.envAddress('RECURRING_ROUND_V1_BEACON');

        factoryImpl = address(new RoundFactory(singleRoundV1Beacon, recurringRoundV1Beacon));
        factory.upgradeToAndCall(factoryImpl, new bytes(0));

        vm.stopBroadcast();
    }
}

// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Script} from 'forge-std/Script.sol';
import {RoundFactory} from 'src/RoundFactory.sol';
import {SingleRoundV1} from 'src/rounds/SingleRoundV1.sol';
import {SingleRoundV2} from 'src/rounds/SingleRoundV2.sol';
import {IRoundFactory} from 'src/interfaces/IRoundFactory.sol';
import {RecurringRoundV1} from 'src/rounds/RecurringRoundV1.sol';
import {SafeCast} from 'openzeppelin/contracts/utils/math/SafeCast.sol';
import {UpgradeableBeacon} from 'openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol';
import {ERC1967Proxy} from 'openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol';

contract DeployRoundFactory is Script {
    function run() public returns (RoundFactory factory) {
        uint256 deployerKey = vm.envUint('DEPLOYER_PRIVATE_KEY');
        vm.startBroadcast(deployerKey);

        address owner = vm.envAddress('OWNER_ADDRESS');
        address signer = vm.envAddress('SIGNER_ADDRESS');
        address distributor = vm.envAddress('DISTRIBUTOR_ADDRESS');
        address feeClaimer = vm.envAddress('FEE_CLAIMER_ADDRESS');
        uint16 feeBPS = SafeCast.toUint16(vm.envUint('FEE_BPS'));

        address singleRoundV1Beacon = address(new UpgradeableBeacon(address(new SingleRoundV1()), owner));
        address singleRoundV2Beacon = address(new UpgradeableBeacon(address(new SingleRoundV2()), owner));
        address recurringRoundV1Beacon = address(new UpgradeableBeacon(address(new RecurringRoundV1()), owner));
        address factoryImpl =
            address(new RoundFactory(singleRoundV1Beacon, singleRoundV2Beacon, recurringRoundV1Beacon));

        factory = RoundFactory(
            address(
                new ERC1967Proxy(
                    factoryImpl,
                    abi.encodeCall(IRoundFactory.initialize, (owner, signer, distributor, feeClaimer, feeBPS))
                )
            )
        );

        vm.stopBroadcast();
    }
}

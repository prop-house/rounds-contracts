// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Test} from 'forge-std/Test.sol';
import {UpgradeableBeacon} from 'openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol';
import {ERC1967Proxy} from 'openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol';
import {RecurringRoundV1} from 'src/rounds/RecurringRoundV1.sol';
import {IRoundFactory} from 'src/interfaces/IRoundFactory.sol';
import {SingleRoundV1} from 'src/rounds/SingleRoundV1.sol';
import {SingleRoundV2} from 'src/rounds/SingleRoundV2.sol';
import {AssetController} from 'src/abstracts/AssetController.sol';
import {RoundFactory} from 'src/RoundFactory.sol';

contract RoundFactoryTest is Test {
    RoundFactory factory;

    address internal owner = makeAddr('owner');
    address internal admin = makeAddr('admin');
    address internal distributor = makeAddr('distributor');
    address internal feeClaimer = makeAddr('fee_claimer');
    address internal alice = makeAddr('alice');

    address internal signer;
    uint256 internal signerPk;

    function setUp() public {
        (signer, signerPk) = makeAddrAndKey('signer');

        address singleRoundV1Beacon = address(new UpgradeableBeacon(address(new SingleRoundV1()), owner));
        address singleRoundV2Beacon = address(new UpgradeableBeacon(address(new SingleRoundV2()), owner));
        address recurringRoundV1Beacon = address(new UpgradeableBeacon(address(new RecurringRoundV1()), owner));
        address factoryImpl =
            address(new RoundFactory(singleRoundV1Beacon, singleRoundV2Beacon, recurringRoundV1Beacon));
        factory = RoundFactory(
            address(
                new ERC1967Proxy(
                    factoryImpl, abi.encodeCall(IRoundFactory.initialize, (owner, signer, distributor, feeClaimer, 500))
                )
            )
        );

        // Transfer ownership of the beacons to the factory.
        vm.startPrank(owner);
        UpgradeableBeacon(singleRoundV1Beacon).transferOwnership(address(factory));
        UpgradeableBeacon(singleRoundV2Beacon).transferOwnership(address(factory));
        UpgradeableBeacon(recurringRoundV1Beacon).transferOwnership(address(factory));
        vm.stopPrank();
    }

    function test_predictSingleRoundV1Address() public {
        IRoundFactory.SingleRoundV1Config memory config = IRoundFactory.SingleRoundV1Config({
            roundId: 1,
            initialAdmin: admin,
            isFeeEnabled: true,
            isLeafVerificationEnabled: false,
            awardAmount: 100e18,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0)
        });

        address predictedSingleRoundV1 = factory.predictSingleRoundV1Address(config);
        address singleRoundV1 = factory.deploySingleRoundV1(config);

        assertEq(predictedSingleRoundV1, singleRoundV1);
    }

    function test_predictSingleRoundV2Address() public {
        IRoundFactory.SingleRoundV2Config memory config =
            IRoundFactory.SingleRoundV2Config({roundId: 42, initialOwner: admin});

        address predictedSingleRoundV2 = factory.predictSingleRoundV2Address(config);
        address singleRoundV2 = factory.deploySingleRoundV2(config);

        assertEq(predictedSingleRoundV2, singleRoundV2);
    }

    function test_predictRecurringRoundV1Address() public {
        IRoundFactory.RecurringRoundV1Config memory config =
            IRoundFactory.RecurringRoundV1Config({seriesId: 42, initialOwner: admin});

        address predictedRecurringRoundV1 = factory.predictRecurringRoundV1Address(config);
        address recurringRoundV1 = factory.deployRecurringRoundV1(config);

        assertEq(predictedRecurringRoundV1, recurringRoundV1);
    }

    function test_noCollisionWithSameRoundConfig() public {
        IRoundFactory.SingleRoundV2Config memory singleRoundV2Config =
            IRoundFactory.SingleRoundV2Config({roundId: 42, initialOwner: admin});
        IRoundFactory.RecurringRoundV1Config memory recurringRoundV1Config =
            IRoundFactory.RecurringRoundV1Config({seriesId: 42, initialOwner: admin});

        assertNotEq(
            factory.deploySingleRoundV2(singleRoundV2Config), factory.deployRecurringRoundV1(recurringRoundV1Config)
        );
    }
}

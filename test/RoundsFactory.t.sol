// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Test} from 'forge-std/Test.sol';
import {UpgradeableBeacon} from 'openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol';
import {ERC1967Proxy} from 'openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol';
import {IRoundFactory} from 'src/interfaces/IRoundFactory.sol';
import {AssetController} from 'src/AssetController.sol';
import {SingleRoundV1} from 'src/SingleRoundV1.sol';
import {RoundFactory} from 'src/RoundFactory.sol';

contract RoundFactoryTest is Test {
    RoundFactory factory;

    address internal owner = makeAddr('owner');
    address internal admin = makeAddr('admin');
    address internal feeClaimer = makeAddr('fee_claimer');
    address internal alice = makeAddr('alice');

    address internal signer;
    uint256 internal signerPk;

    function setUp() public {
        (signer, signerPk) = makeAddrAndKey('signer');

        address roundBeacon = address(new UpgradeableBeacon(address(new SingleRoundV1()), owner));

        address factoryImpl = address(new RoundFactory(roundBeacon));
        factory = RoundFactory(
            address(
                new ERC1967Proxy(factoryImpl, abi.encodeCall(IRoundFactory.initalize, (owner, signer, feeClaimer, 500)))
            )
        );
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
}

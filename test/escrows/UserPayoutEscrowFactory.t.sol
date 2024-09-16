// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Test} from 'forge-std/Test.sol';
import {UserPayoutEscrow} from 'src/escrows/UserPayoutEscrow.sol';
import {UserPayoutEscrowFactory} from 'src/escrows/UserPayoutEscrowFactory.sol';
import {ERC1967Proxy} from 'openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol';
import {UpgradeableBeacon} from 'openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol';

contract UserPayoutEscrowFactoryTest is Test {
    UserPayoutEscrowFactory factory;

    address internal owner = makeAddr('owner');
    address internal payer = makeAddr('payer');

    address internal signer;
    uint256 internal signerPk;

    function setUp() public {
        (signer, signerPk) = makeAddrAndKey('signer');

        address userPayoutEscrowBeacon = address(new UpgradeableBeacon(address(new UserPayoutEscrow()), owner));
        address factoryImpl = address(new UserPayoutEscrowFactory(userPayoutEscrowBeacon));
        factory = UserPayoutEscrowFactory(
            address(new ERC1967Proxy(factoryImpl, abi.encodeCall(UserPayoutEscrowFactory.initialize, (owner, payer))))
        );

        // Transfer ownership of the beacon to the factory.
        vm.prank(owner);
        UpgradeableBeacon(userPayoutEscrowBeacon).transferOwnership(address(factory));
    }

    function test_initialize() public {
        assertEq(factory.owner(), owner);
        assertEq(factory.payer(), payer);
    }

    function test_predictUserPayoutEscrowAddress() public {
        string memory userID = 'farcaster_3712';
        address predictedEscrow = factory.predictUserPayoutEscrowAddress(userID);

        address escrow = factory.deployUserPayoutEscrow(userID);

        assertEq(predictedEscrow, escrow);
    }

    function test_setUserPayoutEscrowImplementation() public {
        address newImplementation = address(new UserPayoutEscrow());

        vm.prank(owner);
        factory.setUserPayoutEscrowImplementation(newImplementation);

        assertEq(UpgradeableBeacon(factory.userPayoutEscrowBeacon()).implementation(), newImplementation);
    }

    function test_setPayer() public {
        address newPayer = makeAddr('newPayer');

        vm.prank(owner);
        factory.setPayer(newPayer);

        assertEq(factory.payer(), newPayer);
    }
}

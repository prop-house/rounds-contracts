// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Test} from 'forge-std/Test.sol';
import {UserPayoutEscrow} from 'src/misc/UserPayoutEscrow.sol';
import {UserPayoutEscrowFactory} from 'src/misc/UserPayoutEscrowFactory.sol';
import {UpgradeableBeacon} from 'openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol';
import {ERC1967Proxy} from 'openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol';
import {IUserPayoutEscrow} from 'src/interfaces/IUserPayoutEscrow.sol';
import {AssetController} from 'src/AssetController.sol';

contract UserPayoutEscrowTest is Test {
    UserPayoutEscrow escrow;
    UserPayoutEscrowFactory factory;

    address internal factoryOwner = makeAddr('factory_owner');
    address internal payer = makeAddr('payer');
    address payable internal recipient = payable(makeAddr('recipient'));

    function setUp() public {
        address userPayoutEscrowBeacon = address(new UpgradeableBeacon(address(new UserPayoutEscrow()), factoryOwner));
        address factoryImpl = address(new UserPayoutEscrowFactory(userPayoutEscrowBeacon));
        factory = UserPayoutEscrowFactory(
            address(
                new ERC1967Proxy(factoryImpl, abi.encodeCall(UserPayoutEscrowFactory.initialize, (factoryOwner, payer)))
            )
        );

        // Transfer ownership of the beacon to the factory.
        vm.prank(factoryOwner);
        UpgradeableBeacon(userPayoutEscrowBeacon).transferOwnership(address(factory));

        escrow = UserPayoutEscrow(factory.deployUserPayoutEscrow('farcaster_3712'));
    }

    function test_initializeRevertsOnMultipleCalls() public {
        vm.expectRevert(0xf92ee8a9);
        escrow.initialize(address(factory));
    }

    function test_sendPayoutsSuccessfully() public {
        IUserPayoutEscrow.Payout[] memory payouts = new IUserPayoutEscrow.Payout[](1);
        payouts[0] = IUserPayoutEscrow.Payout({
            asset: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0),
            amount: 100 ether
        });
        vm.deal(address(escrow), 100 ether);

        assertEq(address(recipient).balance, 0 ether);

        vm.expectEmit();
        emit IUserPayoutEscrow.PayoutsSent(recipient, payouts);

        vm.prank(payer);
        escrow.send(recipient, payouts);

        assertEq(address(recipient).balance, 100 ether);
    }

    function test_sendRevertsWhenNotPayer() public {
        IUserPayoutEscrow.Payout[] memory payouts = new IUserPayoutEscrow.Payout[](1);
        payouts[0] = IUserPayoutEscrow.Payout({
            asset: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0),
            amount: 100 ether
        });

        // Attempt to call send from a non-payer address
        vm.prank(makeAddr('not_payer'));
        vm.expectRevert(IUserPayoutEscrow.ONLY_PAYER.selector);
        escrow.send(recipient, payouts);
    }

    function test_sendRevertsWhenRecipientIsZeroAddress() public {
        IUserPayoutEscrow.Payout[] memory payouts = new IUserPayoutEscrow.Payout[](1);
        payouts[0] = IUserPayoutEscrow.Payout({
            asset: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0),
            amount: 100 ether
        });

        // Call send with zero address as recipient
        vm.prank(payer);
        vm.expectRevert(IUserPayoutEscrow.INVALID_RECIPIENT.selector);
        escrow.send(payable(address(0)), payouts);
    }
}

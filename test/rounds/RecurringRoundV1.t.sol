// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Test} from 'forge-std/Test.sol';
import {UpgradeableBeacon} from 'openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol';
import {ERC1967Proxy} from 'openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol';
import {IRecurringRoundV1} from 'src/interfaces/IRecurringRoundV1.sol';
import {RecurringRoundV1} from 'src/rounds/RecurringRoundV1.sol';
import {IRoundFactory} from 'src/interfaces/IRoundFactory.sol';
import {AssetController} from 'src/AssetController.sol';
import {RoundFactory} from 'src/RoundFactory.sol';

contract RecurringRoundV1Test is Test {
    RoundFactory factory;
    RecurringRoundV1 round;

    address internal owner = makeAddr('owner');
    address internal admin = makeAddr('admin');
    address internal bot = makeAddr('bot');
    address internal feeClaimer = makeAddr('fee_claimer');
    address internal alice = makeAddr('alice');

    address internal signer;
    uint256 internal signerPk;

    function setUp() public {
        (signer, signerPk) = makeAddrAndKey('signer');

        address recurringRoundV1Beacon = address(new UpgradeableBeacon(address(new RecurringRoundV1()), owner));
        address factoryImpl = address(new RoundFactory(address(0), recurringRoundV1Beacon));
        factory = RoundFactory(
            address(
                new ERC1967Proxy(
                    factoryImpl, abi.encodeCall(IRoundFactory.initialize, (owner, signer, feeClaimer, 500))
                )
            )
        );

        round = RecurringRoundV1(
            payable(
                factory.deployRecurringRoundV1(
                    IRoundFactory.RecurringRoundV1Config({
                        seriesId: 42,
                        initialOwner: admin,
                        isFeeEnabled: true,
                        isLeafVerificationEnabled: false,
                        award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0)
                    })
                )
            )
        );
    }

    function testFuzz_claimETHValidSig(uint120 value, uint40 seriesId, uint40 roundId, uint40 fid) public {
        vm.assume(value > 0);

        vm.prank(owner);
        round = RecurringRoundV1(
            payable(
                factory.deployRecurringRoundV1(
                    IRoundFactory.RecurringRoundV1Config({
                        seriesId: seriesId,
                        initialOwner: admin,
                        isFeeEnabled: true,
                        isLeafVerificationEnabled: false,
                        award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0)
                    })
                )
            )
        );

        vm.deal(address(round), value);
        bytes memory sig = _signClaim(signerPk, roundId, fid, alice, value);

        vm.expectEmit();
        emit IRecurringRoundV1.Claimed(roundId, fid, alice, value);

        vm.prank(bot);
        round.claim(roundId, fid, alice, value, new bytes32[](0), sig);

        bool claimed = round.hasFIDClaimedForRound(roundId, fid);

        assertEq(address(round).balance, 0);
        assertEq(claimed, true);
        assertEq(address(alice).balance, value);
    }

    function test_claimFee() public {
        uint40 roundId = 1;
        uint256 fid = 1;
        uint256 value = 100e18;
        uint256 expectedFee = value * factory.feeBPS() / 10_000;

        vm.deal(address(round), value + expectedFee);
        bytes memory sig = _signClaim(signerPk, roundId, fid, alice, value);

        vm.prank(bot);
        round.claim(roundId, fid, alice, value, new bytes32[](0), sig);

        uint256 feeClaimerBalance = address(feeClaimer).balance;

        vm.prank(feeClaimer);
        round.claimFee();

        assertEq(address(feeClaimer).balance, feeClaimerBalance + expectedFee);
    }

    function _signClaim(uint256 pk, uint256 roundId, uint256 fid, address to, uint256 amount)
        public
        returns (bytes memory signature)
    {
        bytes32 digest = round.hashTypedData(keccak256(abi.encode(round.CLAIM_TYPEHASH(), roundId, fid, to, amount)));
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(pk, digest);

        signature = abi.encodePacked(r, s, v);
        assertEq(signature.length, 65);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Test} from 'forge-std/Test.sol';
import {UpgradeableBeacon} from 'openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol';
import {ERC1967Proxy} from 'openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol';
import {ISingleRoundV1} from 'src/interfaces/ISingleRoundV1.sol';
import {IRoundFactory} from 'src/interfaces/IRoundFactory.sol';
import {SingleRoundV1} from 'src/rounds/SingleRoundV1.sol';
import {AssetController} from 'src/AssetController.sol';
import {RoundFactory} from 'src/RoundFactory.sol';

contract SingleRoundV1Test is Test {
    RoundFactory factory;
    SingleRoundV1 round;

    address internal owner = makeAddr('owner');
    address internal admin = makeAddr('admin');
    address internal bot = makeAddr('bot');
    address internal feeClaimer = makeAddr('fee_claimer');
    address internal alice = makeAddr('alice');

    address internal signer;
    uint256 internal signerPk;

    function setUp() public {
        (signer, signerPk) = makeAddrAndKey('signer');

        address singleRoundV1Beacon = address(new UpgradeableBeacon(address(new SingleRoundV1()), owner));
        address factoryImpl = address(new RoundFactory(singleRoundV1Beacon));
        factory = RoundFactory(
            address(
                new ERC1967Proxy(
                    factoryImpl, abi.encodeCall(IRoundFactory.initialize, (owner, signer, feeClaimer, 500))
                )
            )
        );

        uint256 awardAmount = 100e18;
        round = SingleRoundV1(
            payable(
                factory.deploySingleRoundV1(
                    IRoundFactory.SingleRoundV1Config({
                        roundId: 1,
                        initialAdmin: admin,
                        isFeeEnabled: true,
                        isLeafVerificationEnabled: false,
                        awardAmount: awardAmount,
                        award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0)
                    })
                )
            )
        );
        vm.deal(address(round), awardAmount + round.fee());
    }

    function testFuzz_claimETHValidSig(uint120 value, uint40 roundId, uint40 fid) public {
        vm.assume(value > 0);

        vm.prank(owner);
        round = SingleRoundV1(
            payable(
                factory.deploySingleRoundV1(
                    IRoundFactory.SingleRoundV1Config({
                        roundId: roundId,
                        initialAdmin: admin,
                        isFeeEnabled: true,
                        isLeafVerificationEnabled: false,
                        awardAmount: value,
                        award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0)
                    })
                )
            )
        );

        vm.deal(address(round), value);
        bytes memory sig = _signClaim(signerPk, fid, alice, value);

        vm.expectEmit();
        emit ISingleRoundV1.Claimed(fid, alice, value);

        vm.prank(bot);
        round.claim(fid, alice, value, new bytes32[](0), sig);

        bool claimed = round.hasFIDClaimed(fid);

        assertEq(address(round).balance, 0);
        assertEq(claimed, true);
        assertEq(address(alice).balance, value);
    }

    function test_claimFee() public {
        uint256 feeClaimerBalance = address(feeClaimer).balance;

        vm.prank(feeClaimer);
        round.claimFee();

        assertEq(address(feeClaimer).balance, feeClaimerBalance + round.fee());
    }

    function _signClaim(uint256 pk, uint256 fid, address to, uint256 amount) public returns (bytes memory signature) {
        bytes32 digest = round.hashTypedData(keccak256(abi.encode(round.CLAIM_TYPEHASH(), fid, to, amount)));
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(pk, digest);

        signature = abi.encodePacked(r, s, v);
        assertEq(signature.length, 65);
    }
}

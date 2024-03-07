// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Test} from 'forge-std/Test.sol';
import {FarcasterClaim} from 'src/FarcasterClaim.sol';
import {IFarcasterClaim} from 'src/interfaces/IFarcasterClaim.sol';
import {AssetController} from 'src/AssetController.sol';

contract FarcasterClaimTest is Test {
    FarcasterClaim fc;

    address internal owner = makeAddr('owner');
    address internal bot = makeAddr('bot');
    address internal alice = makeAddr('alice');

    address internal signer;
    uint256 internal signerPk;

    function setUp() public {
        (signer, signerPk) = makeAddrAndKey('signer');

        fc = new FarcasterClaim(owner, signer);
    }

    function testFuzz_claimETHValidSig(uint120 value, uint40 roundId, uint40 fid) public {
        vm.assume(value > 0);

        vm.deal(address(fc), value);
        bytes memory sig = _signClaim(signerPk, roundId, fid, alice);

        vm.startPrank(owner);

        fc.setAssetForRound(roundId, AssetController.Asset(AssetController.AssetType.ETH, address(0), 0));
        fc.setWinnersForRound(roundId, _toSingletonArray(IFarcasterClaim.Winner({fid: fid, amount: value})));

        vm.stopPrank();

        vm.expectEmit();
        emit IFarcasterClaim.Claimed(roundId, fid, alice);

        vm.prank(bot);
        fc.claim(roundId, fid, alice, sig);

        (bool claimed,) = fc.claimInfoByRoundAndFID(roundId, fid);

        assertEq(address(fc).balance, 0);
        assertEq(claimed, true);
        assertEq(address(alice).balance, value);
    }

    function test_withdrawEther() public {
        vm.deal(address(fc), 100e18);

        uint256 balanceBefore = owner.balance;

        vm.prank(owner);
        fc.withdraw(AssetController.Asset(AssetController.AssetType.ETH, address(0), 0), 100e18);

        assertEq(owner.balance - balanceBefore, 100e18);
    }

    function _signClaim(uint256 pk, uint256 roundId, uint256 fid, address to) public returns (bytes memory signature) {
        bytes32 digest = fc.hashTypedData(keccak256(abi.encode(fc.CLAIM_TYPEHASH(), roundId, fid, to)));
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(pk, digest);

        signature = abi.encodePacked(r, s, v);
        assertEq(signature.length, 65);
    }

    function _toSingletonArray(IFarcasterClaim.Winner memory e)
        internal
        pure
        returns (IFarcasterClaim.Winner[] memory w)
    {
        w = new IFarcasterClaim.Winner[](1);
        w[0] = e;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Test} from 'forge-std/Test.sol';
import {UpgradeableBeacon} from 'openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol';
import {ERC1967Proxy} from 'openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol';
import {ISingleRoundV1} from 'src/interfaces/ISingleRoundV1.sol';
import {IRoundFactory} from 'src/interfaces/IRoundFactory.sol';
import {SingleRoundV1} from 'src/rounds/SingleRoundV1.sol';
import {AssetController} from 'src/abstracts/AssetController.sol';
import {RoundFactory} from 'src/RoundFactory.sol';

contract SingleRoundV1Test is Test {
    RoundFactory factory;
    SingleRoundV1 round;

    address internal factoryOwner = makeAddr('factory_owner');
    address internal distributor = makeAddr('distributor');
    address internal bot = makeAddr('bot');
    address internal feeClaimer = makeAddr('fee_claimer');
    address internal alice = makeAddr('alice');

    address internal admin;
    uint256 internal adminPk;
    address internal signer;
    uint256 internal signerPk;

    function setUp() public {
        (signer, signerPk) = makeAddrAndKey('signer');
        (admin, adminPk) = makeAddrAndKey('admin');

        address singleRoundV1Beacon = address(new UpgradeableBeacon(address(new SingleRoundV1()), factoryOwner));
        address factoryImpl = address(new RoundFactory(singleRoundV1Beacon, address(0), address(0)));
        factory = RoundFactory(
            address(
                new ERC1967Proxy(
                    factoryImpl,
                    abi.encodeCall(IRoundFactory.initialize, (factoryOwner, signer, distributor, feeClaimer, 500))
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

    function test_claimInvalidSignatureReverts() public {
        uint256 fid = 1;
        uint256 amount = 100;
        address recipient = alice;

        bytes memory invalidSig = _signClaim(signerPk, fid, address(1), amount);

        vm.expectRevert(ISingleRoundV1.INVALID_SIGNATURE.selector);

        vm.prank(bot);
        round.claim(fid, recipient, amount, new bytes32[](0), invalidSig);
    }

    function test_claimInvalidRecipientReverts() public {
        uint256 fid = 1;
        uint256 amount = 100;

        bytes memory sig = _signClaim(signerPk, fid, address(0), amount);

        vm.expectRevert(ISingleRoundV1.INVALID_RECIPIENT.selector);

        vm.prank(bot);
        round.claim(fid, address(0), amount, new bytes32[](0), sig);
    }

    function test_claimFee() public {
        uint256 feeClaimerBalance = address(feeClaimer).balance;

        vm.prank(feeClaimer);
        round.claimFee();

        assertEq(address(feeClaimer).balance, feeClaimerBalance + round.fee());
    }

    function test_setClaimMerkleRoot() public {
        bytes32 newMerkleRoot = keccak256('new_merkle_root');
        bytes memory sig = _signSetMerkleRoot(adminPk, newMerkleRoot);

        vm.expectEmit();
        emit ISingleRoundV1.ClaimMerkleRootSet(newMerkleRoot);

        vm.prank(admin);
        round.setClaimMerkleRoot(newMerkleRoot, sig);

        assertEq(round.claimMerkleRoot(), newMerkleRoot);
        assertEq(round.nonce(), 1);
    }

    function test_setAdmin() public {
        address newAdmin = makeAddr('new_admin');

        vm.expectEmit();
        emit ISingleRoundV1.AdminSet(newAdmin);

        vm.prank(admin);
        round.setAdmin(newAdmin);

        assertEq(round.admin(), newAdmin);
    }

    function _signClaim(uint256 pk, uint256 fid, address to, uint256 amount) public returns (bytes memory signature) {
        bytes32 digest = round.hashTypedData(keccak256(abi.encode(round.CLAIM_TYPEHASH(), fid, to, amount)));
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(pk, digest);

        signature = abi.encodePacked(r, s, v);
        assertEq(signature.length, 65);
    }

    function _signSetMerkleRoot(uint256 pk, bytes32 root) public returns (bytes memory signature) {
        bytes32 digest =
            round.hashTypedData(keccak256(abi.encode(round.SET_MERKLE_ROOT_TYPEHASH(), root, round.nonce())));
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(pk, digest);

        signature = abi.encodePacked(r, s, v);
        assertEq(signature.length, 65);
    }
}

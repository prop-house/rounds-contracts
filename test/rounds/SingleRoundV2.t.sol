// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Test} from 'forge-std/Test.sol';
import {UpgradeableBeacon} from 'openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol';
import {ERC1967Proxy} from 'openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol';
import {IRoundFactory} from 'src/interfaces/IRoundFactory.sol';
import {ISingleRoundV2} from 'src/interfaces/ISingleRoundV2.sol';
import {SingleRoundV2} from 'src/rounds/SingleRoundV2.sol';
import {AssetController} from 'src/AssetController.sol';
import {RoundFactory} from 'src/RoundFactory.sol';

contract SingleRoundV2Test is Test {
    RoundFactory factory;
    SingleRoundV2 round;

    address internal factoryOwner = makeAddr('factory_owner');
    address internal distributor = makeAddr('distributor');
    address internal feeClaimer = makeAddr('fee_claimer');
    address payable internal alice = payable(makeAddr('alice'));
    address payable internal bob = payable(makeAddr('bob'));

    function setUp() public {
        address singleRoundV2Beacon = address(new UpgradeableBeacon(address(new SingleRoundV2()), factoryOwner));
        address factoryImpl = address(new RoundFactory(address(0), singleRoundV2Beacon, address(0)));
        factory = RoundFactory(
            address(
                new ERC1967Proxy(
                    factoryImpl,
                    abi.encodeCall(IRoundFactory.initialize, (factoryOwner, address(0), distributor, feeClaimer, 1_000))
                )
            )
        );

        round = SingleRoundV2(
            payable(factory.deploySingleRoundV2(IRoundFactory.SingleRoundV2Config({roundId: 42, initialOwner: alice})))
        );
    }

    function testFuzz_distributeFunds(uint256 amount, uint40 batchId, uint16 feeBPS) public {
        vm.assume(amount > 0 && amount < type(uint128).max);
        vm.assume(feeBPS <= 1_000); // Maximum 10% fee

        // Setting up distribution configuration
        ISingleRoundV2.Winner[] memory winners = new ISingleRoundV2.Winner[](1);
        winners[0] = ISingleRoundV2.Winner({fid: 1, recipient: alice, amount: amount});

        ISingleRoundV2.DistributionConfig memory config = ISingleRoundV2.DistributionConfig({
            asset: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0),
            winners: winners,
            fee: amount * feeBPS / 10_000,
            isFinalBatch: false
        });

        // Deposit ETH into contract
        vm.deal(address(round), amount + config.fee);

        // Distribution by authorized distributor
        vm.expectEmit();
        emit ISingleRoundV2.AssetDistributed(config.asset, config.winners);

        vm.prank(factory.distributor());
        round.distribute(batchId, config);

        // Verify distributions
        assertEq(address(alice).balance, amount);
        assertEq(factory.feeClaimer().balance, config.fee);
    }

    function test_distributeAlreadyProcessedBatchReverts() public {
        uint40 batchId = 1;
        uint256 amount = 100;
        uint16 feeBPS = 500;

        ISingleRoundV2.Winner[] memory winners = new ISingleRoundV2.Winner[](1);
        winners[0] = ISingleRoundV2.Winner({fid: 1, recipient: alice, amount: amount});

        ISingleRoundV2.DistributionConfig memory config = ISingleRoundV2.DistributionConfig({
            asset: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0),
            winners: winners,
            fee: amount * feeBPS / 10000,
            isFinalBatch: false
        });

        vm.deal(address(round), amount + config.fee);

        vm.prank(factory.distributor());
        round.distribute(batchId, config);

        vm.prank(factory.distributor());
        vm.expectRevert(ISingleRoundV2.BATCH_ALREADY_PROCESSED.selector);
        round.distribute(batchId, config);
    }

    function test_withdrawFunds() public {
        uint256 amount = 50;
        AssetController.Asset memory asset = AssetController.Asset(AssetController.AssetType.ETH, address(0), 0);

        vm.deal(address(round), amount);
        assertEq(address(round).balance, amount);

        vm.expectEmit();
        emit ISingleRoundV2.WithdrawalCompleted(asset, amount);

        vm.prank(alice);
        round.withdraw(asset, amount);

        assertEq(address(round).balance, 0);
        assertEq(address(alice).balance, amount);
    }

    function test_withdrawByNonOwnerReverts() public {
        uint256 amount = 50;
        AssetController.Asset memory asset = AssetController.Asset(AssetController.AssetType.ETH, address(0), 0);

        vm.deal(address(round), amount);

        vm.prank(bob);
        vm.expectRevert(0x82b42900); // `Unauthorized()`.
        round.withdraw(asset, amount);
    }

    function test_distributeFundsInvalidRecipientReverts() public {
        uint40 batchId = 1;
        uint256 amount = 100;
        uint16 feeBPS = 500;

        ISingleRoundV2.Winner[] memory winners = new ISingleRoundV2.Winner[](1);
        winners[0] = ISingleRoundV2.Winner({fid: 1, recipient: payable(0), amount: amount});

        ISingleRoundV2.DistributionConfig memory config = ISingleRoundV2.DistributionConfig({
            asset: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0),
            winners: winners,
            fee: amount * feeBPS / 10000,
            isFinalBatch: false
        });

        vm.deal(address(round), amount + config.fee);

        vm.prank(factory.distributor());
        vm.expectRevert(ISingleRoundV2.INVALID_RECIPIENT.selector);
        round.distribute(batchId, config);
    }
}

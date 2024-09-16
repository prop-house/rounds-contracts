// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Test} from 'forge-std/Test.sol';
import {UpgradeableBeacon} from 'openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol';
import {ERC1967Proxy} from 'openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol';
import {IRecurringRoundV1} from 'src/interfaces/IRecurringRoundV1.sol';
import {RecurringRoundV1} from 'src/rounds/RecurringRoundV1.sol';
import {IRoundFactory} from 'src/interfaces/IRoundFactory.sol';
import {AssetController} from 'src/abstracts/AssetController.sol';
import {RoundFactory} from 'src/RoundFactory.sol';

contract RecurringRoundV1Test is Test {
    RoundFactory factory;
    RecurringRoundV1 round;

    address internal factoryOwner = makeAddr('factory_owner');
    address internal distributor = makeAddr('distributor');
    address internal feeClaimer = makeAddr('fee_claimer');
    address payable internal alice = payable(makeAddr('alice'));
    address payable internal bob = payable(makeAddr('bob'));

    function setUp() public {
        address recurringRoundV1Beacon = address(new UpgradeableBeacon(address(new RecurringRoundV1()), factoryOwner));
        address factoryImpl = address(new RoundFactory(address(0), address(0), recurringRoundV1Beacon));
        factory = RoundFactory(
            address(
                new ERC1967Proxy(
                    factoryImpl,
                    abi.encodeCall(IRoundFactory.initialize, (factoryOwner, address(0), distributor, feeClaimer, 1_000))
                )
            )
        );

        round = RecurringRoundV1(
            payable(
                factory.deployRecurringRoundV1(
                    IRoundFactory.RecurringRoundV1Config({seriesId: 42, initialOwner: alice})
                )
            )
        );
    }

    function testFuzz_distributeFunds(uint256 amount, uint40 batchId, uint16 feeBPS) public {
        vm.assume(amount > 0 && amount < type(uint128).max);
        vm.assume(feeBPS <= 1_000); // Maximum 10% fee

        // Setting up distribution configuration
        IRecurringRoundV1.Winner[] memory winners = new IRecurringRoundV1.Winner[](1);
        winners[0] = IRecurringRoundV1.Winner({fid: 1, recipient: alice, amount: amount});

        IRecurringRoundV1.DistributionConfig memory config = IRecurringRoundV1.DistributionConfig({
            asset: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0),
            winners: winners,
            fee: amount * feeBPS / 10_000,
            roundId: 1,
            isFinalBatch: false
        });

        // Deposit ETH into contract
        vm.deal(address(round), amount + config.fee);

        // Distribution by authorized distributor
        vm.expectEmit();
        emit IRecurringRoundV1.AssetDistributed(config.roundId, config.asset, config.winners);

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

        IRecurringRoundV1.Winner[] memory winners = new IRecurringRoundV1.Winner[](1);
        winners[0] = IRecurringRoundV1.Winner({fid: 1, recipient: alice, amount: amount});

        IRecurringRoundV1.DistributionConfig memory config = IRecurringRoundV1.DistributionConfig({
            asset: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0),
            winners: winners,
            fee: amount * feeBPS / 10000,
            roundId: 1,
            isFinalBatch: false
        });

        vm.deal(address(round), amount + config.fee);

        vm.prank(factory.distributor());
        round.distribute(batchId, config);

        vm.prank(factory.distributor());
        vm.expectRevert(IRecurringRoundV1.BATCH_ALREADY_PROCESSED.selector);
        round.distribute(batchId, config);
    }

    function test_withdrawFunds() public {
        uint256 amount = 50;
        AssetController.Asset memory asset = AssetController.Asset(AssetController.AssetType.ETH, address(0), 0);

        vm.deal(address(round), amount);
        assertEq(address(round).balance, amount);

        vm.expectEmit();
        emit IRecurringRoundV1.WithdrawalCompleted(asset, amount);

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

        IRecurringRoundV1.Winner[] memory winners = new IRecurringRoundV1.Winner[](1);
        winners[0] = IRecurringRoundV1.Winner({fid: 1, recipient: payable(0), amount: amount});

        IRecurringRoundV1.DistributionConfig memory config = IRecurringRoundV1.DistributionConfig({
            asset: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0),
            winners: winners,
            fee: amount * feeBPS / 10000,
            roundId: 1,
            isFinalBatch: false
        });

        vm.deal(address(round), amount + config.fee);

        vm.prank(factory.distributor());
        vm.expectRevert(IRecurringRoundV1.INVALID_RECIPIENT.selector);
        round.distribute(batchId, config);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Ownable} from 'solady/auth/Ownable.sol';
import {Initializable} from 'solady/utils/Initializable.sol';
import {ISingleRoundV2} from 'src/interfaces/ISingleRoundV2.sol';
import {FixedPointMathLib} from 'solady/utils/FixedPointMathLib.sol';
import {IRoundFactory} from 'src/interfaces/IRoundFactory.sol';
import {AssetController} from 'src/AssetController.sol';

contract SingleRoundV2 is ISingleRoundV2, Initializable, AssetController, Ownable {
    /// @notice 100% in basis points.
    uint16 public constant MAX_BPS = 10_000;

    /// @notice The factory contract that deployed the round instance.
    IRoundFactory public factory;

    /// @notice Determines whether a distribution batch has been processed.
    mapping(uint256 => bool) public isBatchProcessed;

    /// @dev Ensures the caller is the distributor.
    modifier onlyDistributor() {
        if (msg.sender != factory.distributor()) revert ONLY_DISTRIBUTOR();
        _;
    }

    /// @dev Disable any future initialization.
    constructor() {
        _disableInitializers();
    }

    /// @notice Initialize the contract with the given parameters.
    /// @param factory_ The round factory that deployed the round instance.
    /// @param config The round configuration.
    function initialize(address factory_, IRoundFactory.SingleRoundV2Config calldata config) external initializer {
        _initializeOwner(config.initialOwner);
        factory = IRoundFactory(factory_);
    }

    /// @notice Distributes funds to winners using the provided configuration.
    /// @param batchId The ID of the batch.
    /// @param config The distribution configuration.
    function distribute(uint256 batchId, DistributionConfig calldata config) external onlyDistributor {
        if (isBatchProcessed[batchId]) revert BATCH_ALREADY_PROCESSED();

        uint256 total;
        uint256 numberOfWinners = config.winners.length;
        for (uint256 i = 0; i < numberOfWinners;) {
            Winner memory winner = config.winners[i];
            if (winner.recipient == address(0)) revert INVALID_RECIPIENT();

            _transfer(config.asset, winner.amount, address(this), winner.recipient);
            total += winner.amount;
            unchecked {
                ++i;
            }
        }

        // Mark the batch as processed to ensure it is not accidentally processed again.
        isBatchProcessed[batchId] = true;

        // Take a fee from the distributed amount, if non-zero.
        if (config.fee != 0) {
            uint256 fee = FixedPointMathLib.min(config.fee, _getMaxFee(total));
            _transfer(config.asset, fee, address(this), payable(factory.feeClaimer()));

            emit FeeDistributed(fee);
        }

        emit AssetDistributed(config.asset, config.winners);
        if (config.isFinalBatch) {
            emit AssetDistributionCompleted();
        }
    }

    /// @notice Withdraw an asset from the contract.
    /// @param asset The asset to withdraw.
    /// @param amount The amount to withdraw.
    /// @dev Only callable by the owner.
    function withdraw(Asset calldata asset, uint256 amount) external onlyOwner {
        _transfer(asset, amount, address(this), payable(msg.sender));

        emit WithdrawalCompleted(asset, amount);
    }

    /// @dev Returns the maximum fee that can be taken from the total amount.
    /// @param total The total amount to calculate the fee from.
    function _getMaxFee(uint256 total) internal view returns (uint256 maxFee) {
        maxFee = total * factory.feeBPS() / MAX_BPS;
    }

    /// @dev Receive ETH for distribution.
    receive() external payable {}
}

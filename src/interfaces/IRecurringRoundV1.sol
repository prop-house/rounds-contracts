// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {IRoundFactory} from 'src/interfaces/IRoundFactory.sol';
import {AssetController} from 'src/abstracts/AssetController.sol';

interface IRecurringRoundV1 {
    /// @notice Information about a round winner.
    struct Winner {
        /// @dev The Farcaster ID of the winner.
        uint40 fid;
        /// @dev The winner's recipient address.
        address payable recipient;
        /// @dev The amount to be distributed to the winner.
        uint256 amount;
    }

    /// @notice Configuration details for a round distribution.
    struct DistributionConfig {
        /// @dev The ID of the round.
        uint256 roundId;
        /// @dev The asset being offered in the round.
        AssetController.Asset asset;
        /// @dev List of winners and their corresponding amounts.
        Winner[] winners;
        /// @dev Indicates if this is the final batch of winners.
        bool isFinalBatch;
        /// @dev The fee to be taken from the distribution.
        uint256 fee;
    }

    /// @notice Thrown when the caller is not the distributor.
    error ONLY_DISTRIBUTOR();

    /// @notice Thrown when an invalid recipient is provided.
    error INVALID_RECIPIENT();

    /// @notice Thrown when a batch has already been processed.
    error BATCH_ALREADY_PROCESSED();

    /// @notice Emitted when an asset is distributed to winners.
    event AssetDistributed(uint256 roundId, AssetController.Asset asset, Winner[] winners);

    /// @notice Emitted when an asset distribution for a round is completed.
    event AssetDistributionCompleted(uint256 roundId);

    /// @notice Emitted when a fee is distributed.
    event FeeDistributed(uint256 roundId, uint256 fee);

    /// @notice Emitted when a withdrawal is completed.
    event WithdrawalCompleted(AssetController.Asset asset, uint256 amount);

    /// @param factory The round factory that deployed the round instance.
    /// @param config The round configuration.
    function initialize(address factory, IRoundFactory.RecurringRoundV1Config calldata config) external;
}

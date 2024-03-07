// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {AssetController} from 'src/AssetController.sol';

interface IFarcasterClaim {
    /// @notice Struct for a round winner and the amount available to claim.
    struct Winner {
        /// @dev The Farcaster ID of the winner.
        uint40 fid;
        /// @dev The amount available to claim.
        uint120 amount;
    }

    /// @notice Struct for a Farcaster ID's claim information in a given round.
    struct ClaimInfo {
        /// @dev Whether the award has been claimed.
        bool claimed;
        /// @dev The amount available to claim.
        uint120 amount;
    }

    /// @notice Thrown when an award has already been claimed.
    error ALREADY_CLAIMED();

    /// @notice Thrown when there is nothing to claim for a given round.
    error NOTHING_TO_CLAIM();

    /// @notice Thrown when attempting to claim an invalid asset.
    error INVALID_ASSET();

    /// @notice Thrown when an invalid recipient is provided.
    error INVALID_RECIPIENT();

    /// @notice Thrown when an invalid `Claim` signature is provided.
    error INVALID_SIGNATURE();

    /// @notice Emitted when owner changes the signer address.
    event SignerSet(address oldSigner, address newSigner);

    /// @notice Emitted when a round's asset is set.
    /// @param roundId The round ID.
    /// @param asset The asset offered in the round.
    event AssetSet(uint40 indexed roundId, AssetController.Asset asset);

    /// @notice Emitted when winners are set for a given round.
    /// @param roundId The round ID.
    /// @param winners The round winners and their awards.
    event WinnersSet(uint40 indexed roundId, Winner[] winners);

    /// @notice Emitted when a Farcaster ID claims their award for a given round.
    /// @param roundId The round ID.
    /// @param fid The Farcaster ID.
    /// @param to The address that the award was sent to.
    event Claimed(uint40 indexed roundId, uint40 fid, address to);
}

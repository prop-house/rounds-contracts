// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {IRoundFactory} from 'src/interfaces/IRoundFactory.sol';

interface IRecurringRoundV1 {
    /// @notice Thrown when the caller is not the fee claimer.
    error ONLY_FEE_CLAIMER();

    /// @notice Thrown when attempting to claim the fee when they are disabled.
    error FEE_DISABLED();

    /// @notice Thrown when the reduced fee is not less than the current fee.
    error FEE_NOT_REDUCED();

    /// @notice Thrown when fees are already disabled.
    error FEE_ALREADY_DISABLED();

    /// @notice Thrown when the available fee amount is 0.
    error NO_FEE_TO_CLAIM();

    /// @notice Thrown when an award has already been claimed.
    error ALREADY_CLAIMED();

    /// @notice Thrown when there are insufficient funds for withdrawal.
    error INSUFFICIENT_FUNDS();

    /// @notice Thrown when there is nothing to claim for a given round.
    error NOTHING_TO_CLAIM();

    /// @notice Thrown when an invalid recipient is provided.
    error INVALID_RECIPIENT();

    /// @notice Thrown when an invalid `Claim` signature is provided.
    error INVALID_SIGNATURE();

    /// @notice Thrown when a merkle leaf is invalid.
    error INVALID_LEAF();

    /// @notice Emitted when the round owner changes the claim merkle root for a round.
    /// @param roundId The round ID.
    /// @param newClaimMerkleRoot The new claim merkle root.
    event ClaimMerkleRootSet(uint256 roundId, bytes32 newClaimMerkleRoot);

    /// @notice Emitted when a Farcaster ID claims their award for a given round.
    /// @param roundId The round ID.
    /// @param fid The Farcaster ID.
    /// @param to The address that the award was sent to.
    /// @param amount The award amount.
    event Claimed(uint256 roundId, uint256 fid, address to, uint256 amount);

    /// @notice Emitted when the round fee is reduced.
    /// @param previousFee The previous round fee.
    /// @param newReducedFee The reduced round fee.
    event FeeReduced(uint256 previousFee, uint256 newReducedFee);

    /// @notice Emitted when the round fee is disabled.
    event FeeDisabled();

    /// @notice Emitted when the round fee is claimed.
    /// @param amount The amount claimed.
    event FeeClaimed(uint256 amount);

    /// @param factory The round factory that deployed the round instance.
    /// @param config The round configuration.
    function initialize(address factory, IRoundFactory.RecurringRoundV1Config calldata config) external;
}

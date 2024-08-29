// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {AssetController} from 'src/AssetController.sol';

interface IUserPayoutEscrow {
    /// @notice Asset payout information.
    struct Payout {
        /// @dev The assets being distributed.
        AssetController.Asset asset;
        /// @dev The amount to be distributed to the user.
        uint256 amount;
    }

    /// @notice Thrown when the caller is not the payer.
    error ONLY_PAYER();

    /// @notice Thrown when an invalid recipient is provided.
    error INVALID_RECIPIENT();

    /// @notice Emitted when payouts are sent to a recipient.
    /// @param recipient The recipient of the payouts.
    /// @param payouts The payouts to be sent.
    event PayoutsSent(address recipient, Payout[] payouts);

    /// @param factory The factory that deployed this escrow.
    function initialize(address factory) external;
}

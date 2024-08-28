// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

interface IUserPayoutEscrowFactory {
    /// @notice Emitted when the payer address is updated.
    event PayerSet(address newPayer);

    /// @notice Emitted when a new user payout escrow is deployed.
    /// @param escrow The deployed escrow address.
    /// @param userID The user ID.
    event UserPayoutEscrowDeployed(address escrow, string userID);

    /// @notice The address authorized to send payouts to users via a contract call.
    function payer() external view returns (address);
}

// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {AssetController} from 'src/AssetController.sol';

interface IRoundFactory {
    /// @notice The round configuration.
    struct RoundConfig {
        /// @dev The round ID.
        uint40 roundId;
        /// @dev The round admin.
        address admin;
        /// @dev The award asset amount.
        uint256 amount;
        /// @dev The award asset information.
        AssetController.Asset award;
    }

    /// @notice Thrown when the round beacon owner is not the factory contract.
    error ROUND_BEACON_OWNER_NOT_FACTORY();

    /// @notice Thrown when the fee BPS is above the maximum allowable fee.
    error FEE_BPS_TOO_HIGH();

    /// @notice Emitted when the signer address is updated.
    event SignerSet(address newSigner);

    /// @notice Emitted when the fee claimer address is updated.
    event FeeClaimerSet(address newFeeClaimer);

    /// @notice Emitted when the fee BPS is updated.
    event FeeBPSSet(uint16 newFeeBPS);

    /// @notice Emitted when a new round is deployed.
    event RoundDeployed(address round, uint40 roundId, address admin, uint256 awardAmount, AssetController.Asset award);

    /// @notice The owner of the factory contract and child round contracts.
    function owner() external view returns (address);

    /// @notice The server address that signs message for functions that
    /// require server authorization.
    function signer() external view returns (address);

    /// @notice The address with permission to claim fees.
    function feeClaimer() external view returns (address);

    /// @notice The fee percentage for all rounds with fee enabled.
    function feeBPS() external view returns (uint16);
}

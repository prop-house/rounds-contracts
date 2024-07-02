// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {AssetController} from 'src/AssetController.sol';

interface IRoundFactory {
    /// @notice All round types.
    enum RoundType {
        Single,
        Recurring
    }

    /// @notice All round versions.
    enum RoundVersion {
        V1
    }

    /// @notice The single round V1 configuration.
    struct SingleRoundV1Config {
        /// @dev The round ID.
        uint40 roundId;
        /// @dev The initial round admin.
        address initialAdmin;
        /// @dev Whether the round fee is enabled.
        bool isFeeEnabled;
        /// @dev Whether claim leaf verification is enabled.
        bool isLeafVerificationEnabled;
        /// @dev The award asset amount.
        uint256 awardAmount;
        /// @dev The award asset information.
        AssetController.Asset award;
    }

    /// @notice The recurring round V1 configuration.
    struct RecurringRoundV1Config {
        /// @dev The recurring round series ID.
        uint40 seriesId;
        /// @dev The initial round owner.
        address initialOwner;
    }

    /// @notice Thrown when the fee BPS is above the maximum allowable fee.
    error FEE_BPS_TOO_HIGH();

    /// @notice Emitted when the signer address is updated.
    event SignerSet(address newSigner);

    /// @notice Emitted when the distributor address is updated.
    event DistributorSet(address newDistributor);

    /// @notice Emitted when the fee claimer address is updated.
    event FeeClaimerSet(address newFeeClaimer);

    /// @notice Emitted when the fee BPS is updated.
    event FeeBPSSet(uint16 newFeeBPS);

    /// @notice Emitted when a new v1 single round is deployed.
    /// @param round The deployed round address.
    /// @param config The round configuration.
    event SingleRoundV1Deployed(address round, SingleRoundV1Config config);

    /// @notice Emitted when a new v1 recurring round is deployed.
    /// @param round The deployed round address.
    /// @param config The round configuration.
    event RecurringRoundV1Deployed(address round, RecurringRoundV1Config config);

    /// @param owner The owner of the factory contract and child round contracts.
    /// @param signer The server address that signs message for functions that require server authorization.
    /// @param distributor The address authorized to distribute funds via a contract call.
    /// @param feeClaimer The address with permission to claim fees.
    /// @param feeBPS The fee percentage for all rounds with fee enabled.
    function initialize(address owner, address signer, address distributor, address feeClaimer, uint16 feeBPS)
        external;

    /// @notice The owner of the factory contract and child round contracts.
    function owner() external view returns (address);

    /// @notice The server address that signs message for functions that
    /// require server authorization.
    function signer() external view returns (address);

    /// @notice The address authorized to distribute funds via a contract call.
    function distributor() external view returns (address);

    /// @notice The address with permission to claim fees.
    function feeClaimer() external view returns (address);

    /// @notice The fee percentage for all rounds with fee enabled.
    function feeBPS() external view returns (uint16);
}

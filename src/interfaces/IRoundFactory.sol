// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

interface IRoundFactory {
    /// @notice Emitted when owner changes the signer address.
    event SignerSet(address oldSigner, address newSigner);

    /// @notice Emitted when a new round is deployed.
    event RoundDeployed(uint40 roundId, address round);

    /// @notice The owner of the factory contract and child round contracts.
    function owner() external view returns (address);

    /// @notice The server address that signs message for functions that
    /// require server authorization.
    function signer() external view returns (address);
}

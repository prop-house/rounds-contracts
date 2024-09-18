// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

interface IERC20TokenFactory {
    /// @notice Information required to deploy a new ERC20 token.
    struct ERC20TokenConfig {
        /// @dev The token name.
        string name;
        /// @dev The token symbol.
        string symbol;
        /// @dev The initial token supply.
        uint256 initialSupply;
        /// @dev The recipient of the initial token supply.
        address initialSupplyRecipient;
    }

    /// @notice Emitted when a new ERC20 token is deployed.
    /// @param token The deployed token address.
    /// @param config The ERC20 token configuration.
    event ERC20TokenDeployed(address token, ERC20TokenConfig config);

    /// @notice The owner of the factory contract and child token contracts.
    function owner() external view returns (address);
}

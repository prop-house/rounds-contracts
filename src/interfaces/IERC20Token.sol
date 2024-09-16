// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {IERC20TokenFactory} from 'src/interfaces/IERC20TokenFactory.sol';

interface IERC20Token {
    /// @notice Thrown when the caller is not the factory owner.
    error ONLY_FACTORY_OWNER();

    /// @notice Thrown when the token name is invalid.
    error INVALID_TOKEN_NAME();

    /// @notice Thrown when the token symbol is invalid.
    error INVALID_TOKEN_SYMBOL();

    /// @param factory The ERC20 token factory that deployed the token instance.
    /// @param config The ERC20 token configuration.
    function initialize(address factory, IERC20TokenFactory.ERC20TokenConfig calldata config) external;
}

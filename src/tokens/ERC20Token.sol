// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {ERC20} from 'solady/tokens/ERC20.sol';
import {Initializable} from 'solady/utils/Initializable.sol';
import {IERC20TokenFactory} from 'src/interfaces/IERC20TokenFactory.sol';
import {IERC20Token} from 'src/interfaces/IERC20Token.sol';

contract ERC20Token is IERC20Token, ERC20, Initializable {
    /// @notice The factory that deployed this token.
    IERC20TokenFactory public factory;

    /// @notice The token name.
    string internal _name;

    /// @notice The token symbol.
    string internal _symbol;

    /// @dev Ensures the caller is the factory owner.
    modifier onlyFactoryOwner() {
        if (msg.sender != factory.owner()) revert ONLY_FACTORY_OWNER();
        _;
    }

    /// @dev Disable any future initialization.
    constructor() {
        _disableInitializers();
    }

    /// @param factory_ The factory that deployed this token.
    /// @param config The ERC20 token configuration.
    function initialize(address factory_, IERC20TokenFactory.ERC20TokenConfig calldata config) external initializer {
        factory = IERC20TokenFactory(factory_);

        if (bytes(config.name).length == 0) revert INVALID_TOKEN_NAME();
        if (bytes(config.symbol).length == 0) revert INVALID_TOKEN_SYMBOL();

        _name = config.name;
        _symbol = config.symbol;

        // Distribute the initial token supply, if any.
        for (uint256 i = 0; i < config.allocations.length; i++) {
            _mint(config.allocations[i].recipient, config.allocations[i].amount);
        }
    }

    /// @notice The token name.
    function name() public view override returns (string memory) {
        return _name;
    }

    /// @notice The token symbol.
    function symbol() public view override returns (string memory) {
        return _symbol;
    }

    /// @notice Mints new tokens.
    /// @param recipient The recipient of the minted tokens.
    /// @param amount The amount of tokens to mint.
    function mint(address recipient, uint256 amount) external onlyFactoryOwner {
        _mint(recipient, amount);
    }
}

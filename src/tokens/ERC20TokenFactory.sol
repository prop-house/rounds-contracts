// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Ownable} from 'solady/auth/Ownable.sol';
import {Initializable} from 'solady/utils/Initializable.sol';
import {BeaconProxy} from 'openzeppelin/contracts/proxy/beacon/BeaconProxy.sol';
import {UpgradeableBeacon} from 'openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol';
import {UUPSUpgradeable} from 'openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol';
import {IERC20TokenFactory} from 'src/interfaces/IERC20TokenFactory.sol';
import {IERC20Token} from 'src/interfaces/IERC20Token.sol';

contract ERC20TokenFactory is IERC20TokenFactory, Initializable, UUPSUpgradeable, Ownable {
    /// @notice The beacon contract address for the ERC20 token implementation.
    address public immutable erc20TokenBeacon;

    /// @param erc20TokenBeacon_ The ERC20 token beacon contract address.
    /// @dev Disable any future initialization.
    constructor(address erc20TokenBeacon_) {
        _disableInitializers();

        erc20TokenBeacon = erc20TokenBeacon_;
    }

    /// @param owner_ The owner of the factory contract and child token contracts.
    function initialize(address owner_) external initializer {
        _initializeOwner(owner_);
    }

    /// @notice The owner of the factory contract and child token contracts.
    function owner() public view override(IERC20TokenFactory, Ownable) returns (address) {
        return super.owner();
    }

    /// @notice Predicts a ERC20 token address for a given deployer and nonce.
    /// @param deployer The deployer address.
    /// @param nonce A unique nonce.
    function predictERC20TokenAddress(address deployer, uint256 nonce) external view returns (address token) {
        token = _predictERC20TokenAddress(erc20TokenBeacon, _getERC20TokenSalt(deployer, nonce));
    }

    /// @notice Deploy an ERC20 token contract.
    /// @param nonce A unique nonce.
    /// @param config The ERC20 token configuration.
    function deployERC20Token(uint256 nonce, ERC20TokenConfig calldata config) external returns (address token) {
        token = address(new BeaconProxy{salt: _getERC20TokenSalt(msg.sender, nonce)}(erc20TokenBeacon, new bytes(0)));
        IERC20Token(token).initialize(address(this), config);
        emit ERC20TokenDeployed(token, config);
    }

    /// @notice Upgrade the ERC20 token implementation.
    /// @param newImplementation The new implementation address.
    function setERC20TokenImplementation(address newImplementation) external onlyOwner {
        UpgradeableBeacon(erc20TokenBeacon).upgradeTo(newImplementation);
    }

    /// @dev Generates a ERC20 token salt for a given deployer and nonce.
    /// @param deployer The deployer address.
    /// @param nonce A unique nonce.
    function _getERC20TokenSalt(address deployer, uint256 nonce) internal view returns (bytes32 salt) {
        salt = keccak256(abi.encode(block.chainid, deployer, nonce));
    }

    // forgefmt: disable-next-item
    /// @notice Predicts an ERC20 token address for a given beacon address and salt.
    /// @param beacon The beacon address.
    /// @param salt The create2 salt.
    function _predictERC20TokenAddress(address beacon, bytes32 salt) internal view returns (address token) {
        token = address(uint160(uint256(keccak256(
            abi.encodePacked(
                bytes1(0xff),
                address(this),
                salt,
                keccak256(abi.encodePacked(type(BeaconProxy).creationCode, abi.encode(beacon, new bytes(0))))
            )
        ))));
    }

    /// @dev Allows the owner to upgrade the ERC20 token factory implementation.
    /// @param newImplementation The implementation to upgrade to.
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}

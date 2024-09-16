// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Ownable} from 'solady/auth/Ownable.sol';
import {Initializable} from 'solady/utils/Initializable.sol';
import {BeaconProxy} from 'openzeppelin/contracts/proxy/beacon/BeaconProxy.sol';
import {UpgradeableBeacon} from 'openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol';
import {UUPSUpgradeable} from 'openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol';
import {IUserPayoutEscrowFactory} from 'src/interfaces/IUserPayoutEscrowFactory.sol';
import {IUserPayoutEscrow} from 'src/interfaces/IUserPayoutEscrow.sol';

contract UserPayoutEscrowFactory is IUserPayoutEscrowFactory, Initializable, UUPSUpgradeable, Ownable {
    /// @notice The beacon contract address for the user payout escrow implementation.
    address public immutable userPayoutEscrowBeacon;

    /// @notice Address authorized to send payouts to users via a contract call.
    address public payer;

    /// @param userPayoutEscrowBeacon_ The user payout escrow beacon contract address.
    /// @dev Disable any future initialization.
    constructor(address userPayoutEscrowBeacon_) {
        _disableInitializers();

        userPayoutEscrowBeacon = userPayoutEscrowBeacon_;
    }

    /// @param owner_ The owner of the factory contract and child escrow contracts.
    /// @param payer_ The address authorized to send payouts to users via a contract call.
    function initialize(address owner_, address payer_) external initializer {
        _initializeOwner(owner_);

        emit PayerSet(payer = payer_);
    }

    // forgefmt: disable-next-item
    /// @notice Predicts a user payout escrow address for a given user.
    /// @param userID The user ID.
    function predictUserPayoutEscrowAddress(string calldata userID) external view returns (address escrow) {
        escrow = _predictEscrowAddress(
            userPayoutEscrowBeacon, _getUserPayoutEscrowSalt(userID)
        );
    }

    /// @notice Deploy a user payout escrow contract.
    function deployUserPayoutEscrow(string calldata userID) external returns (address escrow) {
        escrow = address(new BeaconProxy{salt: _getUserPayoutEscrowSalt(userID)}(userPayoutEscrowBeacon, new bytes(0)));
        IUserPayoutEscrow(escrow).initialize(address(this));
        emit UserPayoutEscrowDeployed(escrow, userID);
    }

    /// @notice Upgrade the user payout escrow implementation.
    /// @param newImplementation The new implementation address.
    function setUserPayoutEscrowImplementation(address newImplementation) external onlyOwner {
        UpgradeableBeacon(userPayoutEscrowBeacon).upgradeTo(newImplementation);
    }

    /// @notice Update the address authorized to send payouts to users via a contract call.
    /// @param newPayer The new payer address.
    function setPayer(address newPayer) external onlyOwner {
        emit PayerSet(payer = newPayer);
    }

    /// @dev Generates a user payout escrow salt using the user ID.
    /// @param userID The user ID.
    function _getUserPayoutEscrowSalt(string calldata userID) internal pure returns (bytes32 salt) {
        salt = keccak256(abi.encode(userID));
    }

    // forgefmt: disable-next-item
    /// @notice Predicts an escrow address for a given beacon address and salt.
    /// @param beacon The beacon address.
    /// @param salt The create2 salt.
    function _predictEscrowAddress(address beacon, bytes32 salt) internal view returns (address escrow) {
        escrow = address(uint160(uint256(keccak256(
            abi.encodePacked(
                bytes1(0xff),
                address(this),
                salt,
                keccak256(abi.encodePacked(type(BeaconProxy).creationCode, abi.encode(beacon, new bytes(0))))
            )
        ))));
    }

    /// @dev Allows the owner to upgrade the user payout escrow factory implementation.
    /// @param newImplementation The implementation to upgrade to.
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}

// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Ownable} from 'solady/auth/Ownable.sol';
import {LibClone} from 'solady/utils/LibClone.sol';
import {UUPSUpgradeable} from 'solady/utils/UUPSUpgradeable.sol';
import {IRoundFactory} from 'src/interfaces/IRoundFactory.sol';
import {AssetController} from 'src/AssetController.sol';
import {IRound} from 'src/interfaces/IRound.sol';

contract RoundFactory is IRoundFactory, UUPSUpgradeable, Ownable {
    using LibClone for address;

    /// @notice The claim implementation contract address.
    address public immutable claimImpl;

    /// @notice Address authorized to sign `Claim` messages
    address public signer;

    /// @param _claimImpl The claim implementation contract address.
    /// @param _owner The address that manages all claim contracts.
    /// @param _signer Server address that must sign `Claim` messages.
    constructor(address _claimImpl, address _owner, address _signer) {
        _initializeOwner(_owner);

        claimImpl = _claimImpl;
        signer = _signer;
    }

    /// @notice The owner of the factory contract and child round contracts.
    function owner() public view override(IRoundFactory, Ownable) returns (address) {
        return super.owner();
    }

    // forgefmt: disable-next-item
    /// @notice Predicts a round address for the provided round ID.
    /// @param roundId The round ID.
    /// @param admin The round admin.
    /// @param award The award asset.
    function predictRoundAddress(uint40 roundId, address admin, AssetController.Asset calldata award) external view returns (address round) {
        round = claimImpl.predictDeterministicAddress(_salt(roundId, admin, award), address(this));
    }

    // forgefmt: disable-next-item
    /// @notice Deploy a new round contract.
    /// @param roundId The round ID.
    /// @param admin The round admin.
    /// @param award The award asset.
    function deployRound(uint40 roundId, address admin, AssetController.Asset calldata award) external returns (address round) {
        round = claimImpl.cloneDeterministic(_salt(roundId, admin, award));

        IRound(round).initialize(address(this), admin, award);
        emit RoundDeployed(roundId, round);
    }

    /// @notice Update the server address that signs message for functions that
    /// require server authorization.
    /// @param _signer The new signer address.
    function setSigner(address _signer) external onlyOwner {
        emit SignerSet(signer, signer = _signer);
    }

    // forgefmt: disable-next-item
    /// @dev Returns the salt for a given round ID.
    /// @param roundId The round ID.
    /// @param admin The round admin.
    /// @param award The award asset.
    function _salt(uint40 roundId, address admin, AssetController.Asset calldata award) internal pure returns (bytes32 salt) {
        salt = keccak256(abi.encode(roundId, admin, award));
    }

    /// @dev Allows the owner to upgrade the claim factory implementation.
    /// @param newImplementation The implementation to upgrade to.
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}

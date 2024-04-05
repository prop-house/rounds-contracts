// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Ownable} from 'solady/auth/Ownable.sol';
import {BeaconProxy} from 'openzeppelin/contracts/proxy/beacon/BeaconProxy.sol';
import {UpgradeableBeacon} from 'openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol';
import {UUPSUpgradeable} from 'solady/utils/UUPSUpgradeable.sol';
import {IRoundFactory} from 'src/interfaces/IRoundFactory.sol';
import {IRound} from 'src/interfaces/IRound.sol';

contract RoundFactory is IRoundFactory, UUPSUpgradeable, Ownable {
    /// @notice The maximum allowable fee percentage (10%).
    uint16 public constant MAX_FEE_BPS = 1_000;

    /// @notice The round beacon contract.
    UpgradeableBeacon public immutable roundBeacon;

    /// @notice Address authorized to sign `Claim` messages
    address public signer;

    /// @notice The address with permission to claim fees.
    address public feeClaimer;

    /// @notice The fee percentage for all rounds with fee enabled.
    uint16 public feeBPS;

    /// @param roundBeacon_ The round beacon contract address.
    /// @param owner_ The address that manages all claim contracts.
    /// @param signer_ Server address that must sign `Claim` messages.
    constructor(address roundBeacon_, address owner_, address signer_) {
        _initializeOwner(owner_);

        roundBeacon = UpgradeableBeacon(roundBeacon_);
        signer = signer_;

        if (roundBeacon.owner() != address(this)) revert ROUND_BEACON_OWNER_NOT_FACTORY();
    }

    /// @notice The owner of the factory contract and child round contracts.
    function owner() public view override(IRoundFactory, Ownable) returns (address) {
        return super.owner();
    }

    /// @notice Predicts a round address for a given configuration.
    /// @param config The round configuration.
    function predictRoundAddress(RoundConfig calldata config) external view returns (address round) {
        round = address(
            uint160(
                uint256(
                    keccak256(
                        abi.encodePacked(
                            bytes1(0xff),
                            address(this),
                            _salt(config),
                            keccak256(
                                abi.encodePacked(type(BeaconProxy).creationCode, abi.encode(roundBeacon, new bytes(0)))
                            )
                        )
                    )
                )
            )
        );
    }

    /// @notice Deploy a new round contract.
    /// @param config The round configuration.
    function deployRound(RoundConfig calldata config) external returns (address round) {
        round = address(new BeaconProxy{salt: _salt(config)}(address(roundBeacon), new bytes(0)));
        IRound(round).initialize(address(this), config.admin, config.amount, config.award);

        emit RoundDeployed(round, config.roundId, config.admin, config.amount, config.award);
    }

    /// @notice Upgrade the round implementation.
    /// @param newImplementation The new implementation address.
    function setRoundImplementation(address newImplementation) external onlyOwner {
        roundBeacon.upgradeTo(newImplementation);
    }

    /// @notice Update the server address that signs message for functions that
    /// require server authorization.
    /// @param newSigner The new signer address.
    function setSigner(address newSigner) external onlyOwner {
        emit SignerSet(signer = newSigner);
    }

    /// @notice Update the address with permission to claim fees.
    /// @param newFeeClaimer The new fee claimer address.
    function setFeeClaimer(address newFeeClaimer) external onlyOwner {
        emit FeeClaimerSet(feeClaimer = newFeeClaimer);
    }

    /// @notice Update the fee percentage for all rounds with fee enabled.
    /// @param newFeeBPS The new fee percentage.
    function setFeeBPS(uint16 newFeeBPS) external onlyOwner {
        if (newFeeBPS > MAX_FEE_BPS) revert FEE_BPS_TOO_HIGH();
        emit FeeBPSSet(feeBPS = newFeeBPS);
    }

    /// @dev Returns the salt for a given round ID.
    /// @param config The round configuration.
    function _salt(RoundConfig calldata config) internal pure returns (bytes32 salt) {
        salt = keccak256(abi.encode(config.roundId, config.admin, config.amount, config.award));
    }

    /// @dev Allows the owner to upgrade the claim factory implementation.
    /// @param newImplementation The implementation to upgrade to.
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}

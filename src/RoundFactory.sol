// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Ownable} from 'solady/auth/Ownable.sol';
import {Initializable} from 'solady/utils/Initializable.sol';
import {BeaconProxy} from 'openzeppelin/contracts/proxy/beacon/BeaconProxy.sol';
import {UpgradeableBeacon} from 'openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol';
import {UUPSUpgradeable} from 'openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol';
import {IRecurringRoundV1} from 'src/interfaces/IRecurringRoundV1.sol';
import {ISingleRoundV1} from 'src/interfaces/ISingleRoundV1.sol';
import {IRoundFactory} from 'src/interfaces/IRoundFactory.sol';

contract RoundFactory is IRoundFactory, Initializable, UUPSUpgradeable, Ownable {
    /// @notice The maximum allowable fee percentage (10%).
    uint16 public constant MAX_FEE_BPS = 1_000;

    /// @notice The v1 single round beacon contract address.
    address public immutable singleRoundV1Beacon;

    /// @notice The v1 recurring round beacon contract address.
    address public immutable recurringRoundV1Beacon;

    /// @notice Address authorized to sign `Claim` messages
    address public signer;

    /// @notice The address with permission to claim fees.
    address public feeClaimer;

    /// @notice The fee percentage for all rounds with fee enabled.
    uint16 public feeBPS;

    /// @param singleRoundV1Beacon_ The v1 single round beacon contract address.
    /// @param recurringRoundV1Beacon_ The v1 recurring round beacon contract address.
    /// @dev Disable any future initialization.
    constructor(address singleRoundV1Beacon_, address recurringRoundV1Beacon_) {
        _disableInitializers();

        singleRoundV1Beacon = singleRoundV1Beacon_;
        recurringRoundV1Beacon = recurringRoundV1Beacon_;
    }

    /// @param owner_ The owner of the factory contract and child round contracts.
    /// @param signer_ The server address that signs message for functions that require server authorization.
    /// @param feeClaimer_ The address with permission to claim fees.
    /// @param feeBPS_ The fee percentage for all rounds with fee enabled.
    function initialize(address owner_, address signer_, address feeClaimer_, uint16 feeBPS_) external initializer {
        _initializeOwner(owner_);

        emit SignerSet(signer = signer_);
        emit FeeClaimerSet(feeClaimer = feeClaimer_);
        emit FeeBPSSet(feeBPS = feeBPS_);
    }

    /// @notice The owner of the factory contract and child round contracts.
    function owner() public view override(IRoundFactory, Ownable) returns (address) {
        return super.owner();
    }

    /// @notice Predicts a v1 single round address for a given configuration.
    /// @param config The round configuration.
    function predictSingleRoundV1Address(SingleRoundV1Config calldata config) external view returns (address round) {
        round = _predictRoundAddress(
            singleRoundV1Beacon, _generateSalt(RoundType.Single, RoundVersion.V1, abi.encode(config))
        );
    }

    // forgefmt: disable-next-item
    /// @notice Predicts a v1 recurring round address for a given configuration.
    /// @param config The round configuration.
    function predictRecurringRoundV1Address(RecurringRoundV1Config calldata config) external view returns (address round) {
        round = _predictRoundAddress(
            recurringRoundV1Beacon, _generateSalt(RoundType.Recurring, RoundVersion.V1, abi.encode(config))
        );
    }

    /// @notice Deploy a v1 single round.
    /// @param config The round configuration.
    function deploySingleRoundV1(SingleRoundV1Config calldata config) external returns (address round) {
        round = address(
            new BeaconProxy{salt: _generateSalt(RoundType.Single, RoundVersion.V1, abi.encode(config))}(
                singleRoundV1Beacon, new bytes(0)
            )
        );
        ISingleRoundV1(round).initialize(address(this), config);
        emit SingleRoundV1Deployed(round, config);
    }

    /// @notice Deploy a v1 recurring round.
    /// @param config The round configuration.
    function deployRecurringRoundV1(RecurringRoundV1Config calldata config) external returns (address round) {
        round = address(
            new BeaconProxy{salt: _generateSalt(RoundType.Recurring, RoundVersion.V1, abi.encode(config))}(
                recurringRoundV1Beacon, new bytes(0)
            )
        );
        IRecurringRoundV1(round).initialize(address(this), config);
        emit RecurringRoundV1Deployed(round, config);
    }

    /// @notice Upgrade the v1 single round implementation.
    /// @param newImplementation The new implementation address.
    function setSingleRoundV1Implementation(address newImplementation) external onlyOwner {
        UpgradeableBeacon(singleRoundV1Beacon).upgradeTo(newImplementation);
    }

    /// @notice Upgrade the v1 recurring round implementation.
    /// @param newImplementation The new implementation address.
    function setRecurringRoundV1Implementation(address newImplementation) external onlyOwner {
        UpgradeableBeacon(recurringRoundV1Beacon).upgradeTo(newImplementation);
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

    // forgefmt: disable-next-item
    /// @dev Generates a salt based on the round type, version, and configuration.
    /// @param type_ The round type.
    /// @param version The round version.
    /// @param config The round configuration.
    function _generateSalt(RoundType type_, RoundVersion version, bytes memory config) internal pure returns (bytes32 salt) {
        salt = keccak256(abi.encode(type_, version, config));
    }

    // forgefmt: disable-next-item
    /// @notice Predicts a round address for a given beacon address and salt.
    /// @param beacon The beacon address.
    /// @param salt The create2 salt.
    function _predictRoundAddress(address beacon, bytes32 salt) internal view returns (address round) {
        round = address(uint160(uint256(keccak256(
            abi.encodePacked(
                bytes1(0xff),
                address(this),
                salt,
                keccak256(abi.encodePacked(type(BeaconProxy).creationCode, abi.encode(beacon, new bytes(0))))
            )
        ))));
    }

    /// @dev Allows the owner to upgrade the claim factory implementation.
    /// @param newImplementation The implementation to upgrade to.
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}

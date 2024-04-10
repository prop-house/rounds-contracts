// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Ownable} from 'solady/auth/Ownable.sol';
import {Initializable} from 'solady/utils/Initializable.sol';
import {BeaconProxy} from 'openzeppelin/contracts/proxy/beacon/BeaconProxy.sol';
import {UpgradeableBeacon} from 'openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol';
import {UUPSUpgradeable} from 'openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol';
import {ISingleRoundV1} from 'src/interfaces/ISingleRoundV1.sol';
import {IRoundFactory} from 'src/interfaces/IRoundFactory.sol';

contract RoundFactory is IRoundFactory, Initializable, UUPSUpgradeable, Ownable {
    /// @notice The maximum allowable fee percentage (10%).
    uint16 public constant MAX_FEE_BPS = 1_000;

    /// @notice The single round V1 beacon contract.
    UpgradeableBeacon public immutable singleRoundV1Beacon;

    /// @notice Address authorized to sign `Claim` messages
    address public signer;

    /// @notice The address with permission to claim fees.
    address public feeClaimer;

    /// @notice The fee percentage for all rounds with fee enabled.
    uint16 public feeBPS;

    /// @param singleRoundV1Beacon_ The round beacon contract address.
    constructor(address singleRoundV1Beacon_) {
        singleRoundV1Beacon = UpgradeableBeacon(singleRoundV1Beacon_);
    }

    /// @param owner_ The owner of the factory contract and child round contracts.
    /// @param signer_ The server address that signs message for functions that require server authorization.
    /// @param feeClaimer_ The address with permission to claim fees.
    /// @param feeBPS_ The fee percentage for all rounds with fee enabled.
    function initalize(address owner_, address signer_, address feeClaimer_, uint16 feeBPS_) external initializer {
        _initializeOwner(owner_);

        emit SignerSet(signer = signer_);
        emit FeeClaimerSet(feeClaimer = feeClaimer_);
        emit FeeBPSSet(feeBPS = feeBPS_);
    }

    /// @notice The owner of the factory contract and child round contracts.
    function owner() public view override(IRoundFactory, Ownable) returns (address) {
        return super.owner();
    }

    /// @notice Predicts a single round address for a given configuration.
    /// @param config The round configuration.
    function predictSingleRoundV1Address(SingleRoundV1Config calldata config) external view returns (address round) {
        round = address(
            uint160(
                uint256(
                    keccak256(
                        abi.encodePacked(
                            bytes1(0xff),
                            address(this),
                            _singleRoundV1Salt(config),
                            keccak256(
                                abi.encodePacked(
                                    type(BeaconProxy).creationCode, abi.encode(singleRoundV1Beacon, new bytes(0))
                                )
                            )
                        )
                    )
                )
            )
        );
    }

    /// @notice Deploy a V1 single round.
    /// @param config The round configuration.
    function deploySingleRoundV1(SingleRoundV1Config calldata config) external returns (address round) {
        round = address(new BeaconProxy{salt: _singleRoundV1Salt(config)}(address(singleRoundV1Beacon), new bytes(0)));

        ISingleRoundV1(round).initialize(address(this), config);
        emit SingleRoundV1Deployed(round, config);
    }

    /// @notice Upgrade the round implementation.
    /// @param newImplementation The new implementation address.
    function setSingleRoundV1Implementation(address newImplementation) external onlyOwner {
        singleRoundV1Beacon.upgradeTo(newImplementation);
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

    /// @dev Returns the salt for a V1 single round.
    /// @param config The round configuration.
    function _singleRoundV1Salt(SingleRoundV1Config calldata config) internal pure returns (bytes32 salt) {
        salt = keccak256(abi.encode(RoundType.Single, RoundVersion.V1, config));
    }

    /// @dev Allows the owner to upgrade the claim factory implementation.
    /// @param newImplementation The implementation to upgrade to.
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}

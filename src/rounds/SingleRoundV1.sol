// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {EIP712} from 'solady/utils/EIP712.sol';
import {Initializable} from 'solady/utils/Initializable.sol';
import {SignatureCheckerLib} from 'solady/utils/SignatureCheckerLib.sol';
import {ISingleRoundV1} from 'src/interfaces/ISingleRoundV1.sol';
import {MerkleProofLib} from 'solady/utils/MerkleProofLib.sol';
import {IRoundFactory} from 'src/interfaces/IRoundFactory.sol';
import {AssetController} from 'src/AssetController.sol';

contract SingleRoundV1 is ISingleRoundV1, Initializable, AssetController, EIP712 {
    /// @notice 100% in basis points.
    uint16 public constant MAX_BPS = 10_000;

    /// @notice EIP-712 typehash for `SetMerkleRoot` message
    bytes32 public constant SET_MERKLE_ROOT_TYPEHASH = keccak256('SetMerkleRoot(bytes32 merkleRoot,uint40 nonce)');

    /// @notice EIP-712 typehash for `Claim` message.
    bytes32 public constant CLAIM_TYPEHASH = keccak256('Claim(uint256 fid,address to,uint256 amount)');

    /// @notice The factory contract that deployed the round instance.
    IRoundFactory public factory;

    /// @notice The round admin, who has access to the funds in the contract and
    /// is responsible for signing off on round winners (setting a merkle root).
    address public admin;

    /// @notice The nonce used to prevent signature replay attacks.
    uint40 public nonce;

    /// @notice Whether the merkle tree leaf verification is enabled.
    bool public isLeafVerificationEnabled;

    /// @notice Whether the fee is enabled on the round.
    bool public isFeeEnabled;

    /// @notice Whether fee has been claimed.
    bool public isFeeClaimed;

    /// @notice The fee charged for the round.
    uint256 public fee;

    /// @notice The award offered in the round.
    Asset public award;

    /// @notice The claim merkle root containing round winner FIDs, verified addresses, and award amounts.
    bytes32 public claimMerkleRoot;

    /// @notice Whether a FID has claimed their award in the round.
    mapping(uint256 fid => bool hasClaimed) public hasFIDClaimed;

    /// @dev Ensures the caller is the fee claimer.
    modifier onlyFeeClaimer() {
        if (msg.sender != factory.feeClaimer()) revert ONLY_FEE_CLAIMER();
        _;
    }

    /// @dev Ensures the caller is the admin.
    modifier onlyAdmin() {
        if (msg.sender != admin) revert ONLY_ADMIN();
        _;
    }

    /// @dev Disable any future initialization.
    constructor() {
        _disableInitializers();
    }

    /// @param factory_ The round factory that deployed the round instance.
    /// @param config The round configuration.
    function initialize(address factory_, IRoundFactory.SingleRoundV1Config calldata config) external initializer {
        factory = IRoundFactory(factory_);
        admin = config.initialAdmin;
        award = config.award;

        isFeeEnabled = config.isFeeEnabled;
        isLeafVerificationEnabled = config.isLeafVerificationEnabled;

        if (config.isFeeEnabled) {
            fee = config.awardAmount * factory.feeBPS() / MAX_BPS;
        }
    }

    /// @notice Set the round admin.
    function setAdmin(address newAdmin) external onlyAdmin {
        if (newAdmin == address(0)) revert INVALID_ADMIN();
        emit AdminSet(admin = newAdmin);
    }

    /// @notice Set the claim merkle root containing round winner FIDs, verified addresses, and award amounts.
    /// @param claimMerkleRoot_ The round claim merkle root.
    /// @param sig The set merkle root admin signature.
    function setClaimMerkleRoot(bytes32 claimMerkleRoot_, bytes calldata sig) external {
        if (!_isValidSetMerkleRootSig(claimMerkleRoot_, sig)) revert INVALID_SIGNATURE();

        // Increment the nonce to prevent signature replays.
        nonce += 1;

        emit ClaimMerkleRootSet(claimMerkleRoot = claimMerkleRoot_);
    }

    /// @notice Claim a round award.
    /// @param fid The farcaster ID of the claimer.
    /// @param to The recipient address.
    /// @param amount The amount of tokens owed.
    /// @param proof The merkle proof to prove address and amount are in tree.
    /// @param sig The claim signature.
    function claim(uint256 fid, address to, uint256 amount, bytes32[] calldata proof, bytes calldata sig) external {
        if (hasFIDClaimed[fid]) revert ALREADY_CLAIMED();

        if (!_isValidClaimSig(fid, to, amount, sig)) revert INVALID_SIGNATURE();
        if (isLeafVerificationEnabled && !_isValidClaimLeaf(fid, to, amount, proof)) revert INVALID_LEAF();
        if (to == address(0)) revert INVALID_RECIPIENT();
        if (amount == 0) revert NOTHING_TO_CLAIM();

        hasFIDClaimed[fid] = true;
        _transfer(award, amount, address(this), payable(to));

        emit Claimed(fid, to, amount);
    }

    /// @notice Claim the round fee.
    function claimFee() external onlyFeeClaimer {
        if (!isFeeEnabled) revert FEE_DISABLED();
        if (isFeeClaimed) revert FEE_ALREADY_CLAIMED();

        isFeeClaimed = true;
        _transfer(award, fee, address(this), payable(factory.feeClaimer()));

        emit FeeClaimed(fee);
    }

    /// @notice Reduce the round fee.
    /// @param newFee The reduced round fee.
    function reduceFee(uint256 newFee) external onlyFeeClaimer {
        if (newFee >= fee) revert FEE_NOT_REDUCED();

        emit FeeReduced(fee = newFee);
    }

    /// @notice Disable the fee for the round.
    function disableFee() external onlyFeeClaimer {
        if (!isFeeEnabled) revert FEE_ALREADY_DISABLED();

        isFeeEnabled = false;
        emit FeeDisabled();
    }

    /// @notice Withdraw an asset from the contract.
    /// @param asset The asset to withdraw.
    /// @param amount The amount to withdraw.
    /// @dev Only callable by the admin.
    function withdraw(Asset calldata asset, uint256 amount) external onlyAdmin {
        _transfer(asset, amount, address(this), payable(msg.sender));
    }

    /// @dev EIP-712 helper.
    function hashTypedData(bytes32 structHash) external view returns (bytes32) {
        return _hashTypedData(structHash);
    }

    /// @dev Get the asset ID for the given asset.
    /// @param asset The asset to get the ID for.
    function _getAssetID(Asset memory asset) internal pure returns (bytes32) {
        return keccak256(abi.encode(asset));
    }

    /// @dev EIP-712 domain name and contract version.
    function _domainNameAndVersion() internal pure override returns (string memory, string memory) {
        return ('Rounds', '1');
    }

    /// @dev Verify EIP-712 `SetMerkleRoot` signature.
    /// @param root The merkle root.
    /// @param sig The signature authenticating the merkle root information.
    function _isValidSetMerkleRootSig(bytes32 root, bytes calldata sig) internal view returns (bool) {
        bytes32 digest = _hashTypedData(keccak256(abi.encode(SET_MERKLE_ROOT_TYPEHASH, root, nonce)));
        return SignatureCheckerLib.isValidSignatureNowCalldata(admin, digest, sig);
    }

    // forgefmt: disable-next-item
    /// @dev Verify EIP-712 `Claim` signature.
    /// @param fid The farcaster ID of the claimer.
    /// @param to The recipient address.
    /// @param amount The amount of tokens owed.
    /// @param sig The signature authenticating the claim information.
    function _isValidClaimSig(uint256 fid, address to, uint256 amount, bytes calldata sig) internal view returns (bool) {
        bytes32 digest = _hashTypedData(keccak256(abi.encode(CLAIM_TYPEHASH, fid, to, amount)));
        return SignatureCheckerLib.isValidSignatureNowCalldata(factory.signer(), digest, sig);
    }

    // forgefmt: disable-next-item
    /// @notice Verify a claim leaf.
    /// @param fid The farcaster ID of the claimer.
    /// @param to The recipient address.
    /// @param amount The amount of tokens owed.
    /// @param proof The merkle proof to prove the FID, address, and amount are in the tree.
    function _isValidClaimLeaf(uint256 fid, address to, uint256 amount, bytes32[] calldata proof) internal view returns (bool) {
        bytes32 leaf = keccak256(abi.encodePacked(fid, to, amount));
        return MerkleProofLib.verify(proof, claimMerkleRoot, leaf);
    }

    /// @dev Receive ETH for award claims.
    receive() external payable {}
}

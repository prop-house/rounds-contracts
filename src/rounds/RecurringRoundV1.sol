// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {EIP712} from 'solady/utils/EIP712.sol';
import {Ownable} from 'solady/auth/Ownable.sol';
import {Initializable} from 'solady/utils/Initializable.sol';
import {SignatureCheckerLib} from 'solady/utils/SignatureCheckerLib.sol';
import {IRecurringRoundV1} from 'src/interfaces/IRecurringRoundV1.sol';
import {MerkleProofLib} from 'solady/utils/MerkleProofLib.sol';
import {IRoundFactory} from 'src/interfaces/IRoundFactory.sol';
import {AssetController} from 'src/AssetController.sol';

contract RecurringRoundV1 is IRecurringRoundV1, Initializable, AssetController, EIP712, Ownable {
    /// @notice 100% in basis points.
    uint16 public constant MAX_BPS = 10_000;

    // forgefmt: disable-next-item
    /// @notice EIP-712 typehash for `SetMerkleRoot` message
    bytes32 public constant SET_MERKLE_ROOT_TYPEHASH = keccak256('SetMerkleRoot(uint256 roundId,bytes32 merkleRoot,uint40 nonce)');

    /// @notice EIP-712 typehash for `Claim` message.
    bytes32 public constant CLAIM_TYPEHASH = keccak256('Claim(uint256 roundId,uint256 fid,address to,uint256 amount)');

    /// @notice The factory contract that deployed the round instance.
    IRoundFactory public factory;

    /// @notice The nonce used to prevent signature replay attacks.
    uint40 public nonce;

    /// @notice Whether the merkle tree leaf verification is enabled.
    bool public isLeafVerificationEnabled;

    /// @notice Whether the fee is enabled on the round.
    bool public isFeeEnabled;

    /// @notice The total fee earned.
    uint128 public feeEarned;

    /// @notice The fee amount that has already been claimed.
    uint128 public feeClaimed;

    /// @notice The award offered in the recurring round.
    Asset public award;

    /// @notice The claim merkle roots containing round winner FIDs, verified addresses, and award amounts.
    mapping(uint256 roundId => bytes32 claimMerkleRoot) public claimMerkleRootForRound;

    /// @notice Whether a FID has claimed their award in a round.
    mapping(uint256 roundId => mapping(uint256 fid => bool hasClaimed)) public hasFIDClaimedForRound;

    /// @dev Ensures the caller is the fee claimer.
    modifier onlyFeeClaimer() {
        if (msg.sender != factory.feeClaimer()) revert ONLY_FEE_CLAIMER();
        _;
    }

    /// @dev Disable any future initialization.
    constructor() {
        _disableInitializers();
    }

    /// @param factory_ The round factory that deployed the round instance.
    /// @param config The round configuration.
    function initialize(address factory_, IRoundFactory.RecurringRoundV1Config calldata config) external initializer {
        _initializeOwner(config.initialOwner);

        factory = IRoundFactory(factory_);
        award = config.award;

        isFeeEnabled = config.isFeeEnabled;
        isLeafVerificationEnabled = config.isLeafVerificationEnabled;
    }

    /// @notice Set the claim merkle root containing round winner FIDs, verified addresses, and award amounts
    /// for a given round.
    /// @param roundId The round ID.
    /// @param claimMerkleRoot_ The round claim merkle root.
    /// @param sig The set merkle root owner signature.
    function setClaimMerkleRoot(uint256 roundId, bytes32 claimMerkleRoot_, bytes calldata sig) external {
        if (!_isValidSetMerkleRootSig(roundId, claimMerkleRoot_, sig)) revert INVALID_SIGNATURE();

        // Increment the nonce to prevent signature replays.
        nonce += 1;

        emit ClaimMerkleRootSet(roundId, claimMerkleRootForRound[roundId] = claimMerkleRoot_);
    }

    /// @notice Claim a round award.
    /// @param roundId The round ID.
    /// @param fid The farcaster ID of the claimer.
    /// @param to The recipient address.
    /// @param amount The amount of tokens owed.
    /// @param proof The merkle proof to prove address and amount are in tree.
    /// @param sig The claim signature.
    function claim(
        uint256 roundId,
        uint256 fid,
        address to,
        uint256 amount,
        bytes32[] calldata proof,
        bytes calldata sig
    ) external {
        if (hasFIDClaimedForRound[roundId][fid]) revert ALREADY_CLAIMED();

        if (!_isValidClaimSig(roundId, fid, to, amount, sig)) revert INVALID_SIGNATURE();
        if (isLeafVerificationEnabled && !_isValidClaimLeaf(roundId, fid, to, amount, proof)) revert INVALID_LEAF();
        if (to == address(0)) revert INVALID_RECIPIENT();
        if (amount == 0) revert NOTHING_TO_CLAIM();

        // Fees are only earned on claimed funds.
        feeEarned += uint128(amount * factory.feeBPS() / MAX_BPS);

        hasFIDClaimedForRound[roundId][fid] = true;
        _transfer(award, amount, address(this), payable(to));

        emit Claimed(roundId, fid, to, amount);
    }

    /// @notice Claim the round fee.
    /// @dev Anyone can call this function.
    function claimFee() external {
        if (!isFeeEnabled) revert FEE_DISABLED();

        uint128 claimableFee = feeEarned - feeClaimed;
        if (claimableFee == 0) revert NO_FEE_TO_CLAIM();

        feeClaimed += claimableFee;
        _transfer(award, claimableFee, address(this), payable(factory.feeClaimer()));

        emit FeeClaimed(claimableFee);
    }

    /// @notice Reduce the round fee.
    /// @param newFee The reduced round fee.
    function reduceFee(uint128 newFee) external onlyFeeClaimer {
        if (newFee >= feeEarned) revert FEE_NOT_REDUCED();

        emit FeeReduced(feeEarned, feeEarned = newFee);
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
    /// @dev Only callable by the owner.
    function withdraw(Asset calldata asset, uint256 amount) external onlyOwner {
        // Ensure sufficient balance when withdrawing the award asset.
        if (_getAssetID(asset) == _getAssetID(award)) {
            uint256 availableBalance = _balanceOf(asset, address(this)) - feeEarned;
            if (amount > availableBalance) revert INSUFFICIENT_FUNDS();
        }
        _transfer(asset, amount, address(this), payable(msg.sender));
    }

    /// @dev EIP-712 helper.
    function hashTypedData(bytes32 structHash) external view returns (bytes32) {
        return _hashTypedData(structHash);
    }

    /// @dev EIP-712 domain name and contract version.
    function _domainNameAndVersion() internal pure override returns (string memory, string memory) {
        return ('Rounds', '1');
    }

    /// @dev Get the asset ID for the given asset.
    /// @param asset The asset to get the ID for.
    function _getAssetID(Asset memory asset) internal pure returns (bytes32) {
        return keccak256(abi.encode(asset));
    }

    /// @dev Verify EIP-712 `SetMerkleRoot` signature.
    /// @param roundId The round ID.
    /// @param root The merkle root.
    /// @param sig The signature authenticating the merkle root information.
    function _isValidSetMerkleRootSig(uint256 roundId, bytes32 root, bytes calldata sig) internal view returns (bool) {
        bytes32 digest = _hashTypedData(keccak256(abi.encode(SET_MERKLE_ROOT_TYPEHASH, roundId, root, nonce)));
        return SignatureCheckerLib.isValidSignatureNowCalldata(owner(), digest, sig);
    }

    // forgefmt: disable-next-item
    /// @dev Verify EIP-712 `Claim` signature.
    /// @param roundId The round ID.
    /// @param fid The farcaster ID of the claimer.
    /// @param to The recipient address.
    /// @param amount The amount of tokens owed.
    /// @param sig The signature authenticating the claim information.
    function _isValidClaimSig(uint256 roundId, uint256 fid, address to, uint256 amount, bytes calldata sig) internal view returns (bool) {
        bytes32 digest = _hashTypedData(keccak256(abi.encode(CLAIM_TYPEHASH, roundId, fid, to, amount)));
        return SignatureCheckerLib.isValidSignatureNowCalldata(factory.signer(), digest, sig);
    }

    // forgefmt: disable-next-item
    /// @notice Verify a claim leaf.
    /// @param roundId The round ID.
    /// @param fid The farcaster ID of the claimer.
    /// @param to The recipient address.
    /// @param amount The amount of tokens owed.
    /// @param proof The merkle proof to prove the FID, address, and amount are in the tree.
    function _isValidClaimLeaf(uint256 roundId, uint256 fid, address to, uint256 amount, bytes32[] calldata proof) internal view returns (bool) {
        bytes32 leaf = keccak256(abi.encodePacked(roundId, fid, to, amount));
        return MerkleProofLib.verify(proof, claimMerkleRootForRound[roundId], leaf);
    }

    /// @dev Receive ETH for award claims.
    receive() external payable {}
}

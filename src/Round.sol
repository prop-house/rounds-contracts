// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {EIP712} from 'solady/utils/EIP712.sol';
import {Initializable} from 'solady/utils/Initializable.sol';
import {SignatureCheckerLib} from 'solady/utils/SignatureCheckerLib.sol';
import {MerkleProofLib} from 'solady/utils/MerkleProofLib.sol';
import {IRoundFactory} from 'src/interfaces/IRoundFactory.sol';
import {AssetController} from 'src/AssetController.sol';
import {IRound} from 'src/interfaces/IRound.sol';

contract Round is IRound, Initializable, AssetController, EIP712 {
    /// @notice EIP-712 typehash for `SetMerkleRoot` message
    bytes32 public constant SET_MERKLE_ROOT_TYPEHASH = keccak256('SetMerkleRoot(bytes32 merkleRoot,uint96 nonce)');

    /// @notice EIP-712 typehash for `Claim` message.
    bytes32 public constant CLAIM_TYPEHASH = keccak256('Claim(uint256 fid,address to)');

    /// @notice The factory contract that deployed the round instance.
    IRoundFactory public factory;

    /// @notice The round admin, who has access to the funds in the contract and
    /// is responsible for signing off on round winners (setting a merkle root).
    address public admin;

    /// @notice The nonce used to prevent signature replay attacks.
    uint96 public nonce;

    /// @notice The merkle root containing round winner FIDs, verified addresses, and award amounts.
    bytes32 public merkleRoot;

    /// @notice The award offered in the round.
    Asset public award;

    /// @notice Whether a FID has claimed their award in the round.
    mapping(uint256 fid => bool hasClaimed) public hasFIDClaimed;

    /// @dev Ensures the caller is the admin.
    modifier onlyAdmin() {
        if (msg.sender != admin) revert ONLY_ADMIN();
        _;
    }

    /// @param factory_ The round factory that deployed the round instance.
    /// @param admin_ The admin of the round.
    /// @param asset The award asset.
    function initialize(address factory_, address admin_, Asset calldata asset) external initializer {
        factory = IRoundFactory(factory_);
        admin = admin_;
        award = asset;
    }

    /// @notice Set the merkle root containing round winner FIDs, verified addresses, and award amounts.
    /// @param merkleRoot_ The round claim merkle root.
    /// @param sig The set merkle root admin signature.
    function setMerkleRoot(bytes32 merkleRoot_, bytes calldata sig) external {
        if (!_isValidSetMerkleRootSig(merkleRoot_, sig)) revert INVALID_SIGNATURE();

        // Increment the nonce to prevent signature replays.
        nonce += 1;

        emit MerkleRootSet(merkleRoot = merkleRoot_);
    }

    /// @notice Claim a round award.
    /// @param fid The farcaster ID of the claimer.
    /// @param to The recipient address.
    /// @param amount The amount of tokens owed.
    /// @param proof The merkle proof to prove address and amount are in tree.
    /// @param sig The claim signature.
    function claim(uint256 fid, address to, uint256 amount, bytes32[] calldata proof, bytes calldata sig) external {
        if (hasFIDClaimed[fid]) revert ALREADY_CLAIMED();

        if (!_isValidClaimSig(fid, to, sig)) revert INVALID_SIGNATURE();
        if (!_isValidClaimLeaf(fid, to, amount, proof)) revert INVALID_LEAF();
        if (to == address(0)) revert INVALID_RECIPIENT();
        if (amount == 0) revert NOTHING_TO_CLAIM();

        hasFIDClaimed[fid] = true;
        _transfer(award, amount, address(this), payable(to));

        emit Claimed(fid, to, amount);
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

    /// @dev EIP-712 domain name and contract version.
    function _domainNameAndVersion() internal pure override returns (string memory, string memory) {
        return ('Rounds', '1');
    }

    /// @dev Verify EIP-712 `SetMerkleRoot` signature.
    /// @param root The merkle root.
    /// @param signature The signature authenticating the claim information.
    function _isValidSetMerkleRootSig(bytes32 root, bytes calldata signature) internal view returns (bool) {
        bytes32 digest = _hashTypedData(keccak256(abi.encode(SET_MERKLE_ROOT_TYPEHASH, root, nonce)));
        return SignatureCheckerLib.isValidSignatureNowCalldata(admin, digest, signature);
    }

    /// @dev Verify EIP-712 `Claim` signature.
    /// @param fid The farcaster ID of the claimer.
    /// @param to The recipient address.
    /// @param signature The signature authenticating the claim information.
    function _isValidClaimSig(uint256 fid, address to, bytes calldata signature) internal view returns (bool) {
        bytes32 digest = _hashTypedData(keccak256(abi.encode(CLAIM_TYPEHASH, fid, to)));
        return SignatureCheckerLib.isValidSignatureNowCalldata(factory.signer(), digest, signature);
    }

    // forgefmt: disable-next-item
    /// @notice Verify a claim leaf.
    /// @param fid The farcaster ID of the claimer.
    /// @param to The recipient address.
    /// @param amount The amount of tokens owed.
    /// @param proof The merkle proof to prove the FID, address, and amount are in the tree.
    function _isValidClaimLeaf(uint256 fid, address to, uint256 amount, bytes32[] calldata proof) internal view returns (bool) {
        bytes32 leaf = keccak256(abi.encodePacked(fid, to, amount));
        return MerkleProofLib.verify(proof, merkleRoot, leaf);
    }

    /// @dev Receive ETH for award claims.
    receive() external payable {}
}

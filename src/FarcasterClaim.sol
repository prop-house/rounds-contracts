// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {EIP712} from 'solady/utils/EIP712.sol';
import {Ownable} from 'solady/auth/Ownable.sol';
import {SignatureCheckerLib} from 'solady/utils/SignatureCheckerLib.sol';
import {IFarcasterClaim} from 'src/interfaces/IFarcasterClaim.sol';
import {AssetController} from 'src/AssetController.sol';

contract FarcasterClaim is IFarcasterClaim, AssetController, Ownable, EIP712 {
    /// @notice EIP-712 typehash for `Claim` message
    bytes32 public constant CLAIM_TYPEHASH = keccak256('Claim(uint256 roundId,uint256 fid,address to)');

    /// @notice Address authorized to sign `Claim` messages
    address public signer;

    /// @notice Mapping of Round IDs to the asset offered in the round.
    mapping(uint40 roundId => Asset asset) public assetOfferedInRound;

    /// @notice Mapping of Farcaster IDs to their claim amount and status for a given round.
    mapping(uint40 roundId => mapping(uint40 fid => ClaimInfo info)) public claimInfoByRoundAndFID;

    /// @notice Set owner and signer contract parameters.
    /// @param _owner Contract owner address. Can withdraw and change paramters.
    /// @param _signer Server address that must sign `Claim` messages.
    constructor(address _owner, address _signer) {
        _initializeOwner(_owner);

        emit SignerSet(address(0), signer = _signer);
    }

    /// @notice Claim an award for a given round.
    /// @param roundId The round ID.
    /// @param fid The Farcaster ID.
    /// @param to The address to send the award to.
    /// @param sig The `Claim` signature.
    function claim(uint40 roundId, uint40 fid, address to, bytes calldata sig) external {
        Asset storage asset = assetOfferedInRound[roundId];
        ClaimInfo storage info = claimInfoByRoundAndFID[roundId][fid];

        if (!_verifySignature(roundId, fid, to, sig)) revert INVALID_SIGNATURE();
        if (to == address(0)) revert INVALID_RECIPIENT();

        if (asset.assetType == AssetType.NONE) revert INVALID_ASSET();
        if (info.amount == 0) revert NOTHING_TO_CLAIM();
        if (info.claimed) revert ALREADY_CLAIMED();

        info.claimed = true;
        _transfer(asset, info.amount, address(this), payable(to));

        emit Claimed(roundId, fid, to);
    }

    /// @notice Withdraw an asset from the contract.
    /// @param asset The asset to withdraw.
    /// @param amount The amount to withdraw.
    /// @dev Only callable by the owner.
    function withdraw(Asset calldata asset, uint256 amount) external onlyOwner {
        _transfer(asset, amount, address(this), payable(msg.sender));
    }

    /// @notice Set signer address. Only callable by owner.
    /// @param _signer New signer address
    function setSigner(address _signer) external onlyOwner {
        emit SignerSet(signer, signer = _signer);
    }

    /// @notice Sets the asset for a given round.
    /// @param roundId The round ID.
    /// @param asset The asset to offer in the round.
    function setAssetForRound(uint40 roundId, Asset calldata asset) external onlyOwner {
        assetOfferedInRound[roundId] = asset;

        emit AssetSet(roundId, asset);
    }

    /// @notice Sets the winners for a given round.
    /// @param roundId The round ID.
    /// @param winners The round winners and their awards.
    function setWinnersForRound(uint40 roundId, Winner[] calldata winners) external onlyOwner {
        for (uint256 i = 0; i < winners.length; i++) {
            claimInfoByRoundAndFID[roundId][winners[i].fid].amount = winners[i].amount;
        }
        emit WinnersSet(roundId, winners);
    }

    /// @dev EIP-712 helper.
    function hashTypedData(bytes32 structHash) external view returns (bytes32) {
        return _hashTypedData(structHash);
    }

    /// @dev EIP-712 domain name and contract version.
    function _domainNameAndVersion() internal pure override returns (string memory, string memory) {
        return ('rounds-wtf-farcaster-claim', '1');
    }

    /// @dev Verify EIP-712 `Claim` signature.
    function _verifySignature(uint256 roundId, uint256 fid, address to, bytes calldata sig)
        internal
        view
        returns (bool)
    {
        bytes32 digest = _hashTypedData(keccak256(abi.encode(CLAIM_TYPEHASH, roundId, fid, to)));
        return SignatureCheckerLib.isValidSignatureNowCalldata(signer, digest, sig);
    }

    /// @dev Receive ETH for award claims.
    receive() external payable {}
}

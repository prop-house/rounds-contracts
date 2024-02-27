// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {ERC20} from 'solady/tokens/ERC20.sol';
import {ERC721} from 'solady/tokens/ERC721.sol';
import {ERC1155} from 'solady/tokens/ERC1155.sol';
import {SafeTransferLib} from 'solady/utils/SafeTransferLib.sol';

abstract contract AssetController {
    using SafeTransferLib for address;

    /// @notice Supported asset types
    enum AssetType {
        ETH,
        ERC20,
        ERC721,
        ERC1155
    }

    /// @notice Common struct for all supported asset types
    struct Asset {
        AssetType assetType;
        address token;
        uint256 identifier;
        uint256 amount;
    }

    /// @notice Thrown when unused asset parameters are populated
    error UNUSED_ASSET_PARAMETERS();

    /// @notice Thrown when an ether transfer does not succeed
    error ETHER_TRANSFER_FAILED();

    /// @notice Thrown when the ERC721 transfer amount is not equal to one
    error INVALID_ERC721_TRANSFER_AMOUNT();

    /// @notice Thrown when an unknown asset type is provided
    error INVALID_ASSET_TYPE();

    /// @notice Thrown when no asset amount is provided
    error MISSING_ASSET_AMOUNT();

    /// @dev Returns the balance of `asset` for `account`
    /// @param asset The asset to fetch the balance of
    /// @param account The account to fetch the balance for
    function _balanceOf(Asset memory asset, address account) internal view returns (uint256) {
        if (asset.assetType == AssetType.ETH) {
            return account.balance;
        }
        if (asset.assetType == AssetType.ERC20) {
            return ERC20(asset.token).balanceOf(account);
        }
        if (asset.assetType == AssetType.ERC721) {
            return ERC721(asset.token).ownerOf(asset.identifier) == account ? 1 : 0;
        }
        if (asset.assetType == AssetType.ERC1155) {
            return ERC1155(asset.token).balanceOf(account, asset.identifier);
        }
        revert INVALID_ASSET_TYPE();
    }

    /// @dev Transfer a given asset from the provided `from` address to the `to` address
    /// @param asset The asset to transfer, including the asset amount
    /// @param source The account supplying the asset
    /// @param recipient The asset recipient
    function _transfer(Asset memory asset, address source, address payable recipient) internal {
        if (asset.assetType == AssetType.ETH) {
            // Ensure neither the token nor the identifier parameters are set
            if ((uint160(asset.token) | asset.identifier) != 0) {
                revert UNUSED_ASSET_PARAMETERS();
            }

            _transferETH(recipient, asset.amount);
        } else if (asset.assetType == AssetType.ERC20) {
            // Ensure that no identifier is supplied
            if (asset.identifier != 0) {
                revert UNUSED_ASSET_PARAMETERS();
            }

            _transferERC20(asset.token, source, recipient, asset.amount);
        } else if (asset.assetType == AssetType.ERC721) {
            _transferERC721(asset.token, asset.identifier, source, recipient, asset.amount);
        } else if (asset.assetType == AssetType.ERC1155) {
            _transferERC1155(asset.token, asset.identifier, source, recipient, asset.amount);
        } else {
            revert INVALID_ASSET_TYPE();
        }
    }

    /// @notice Transfers one or more assets from the provided `from` address to the `to` address
    /// @param assets The assets to transfer, including the asset amounts
    /// @param source The account supplying the assets
    /// @param recipient The asset recipient
    function _transferMany(Asset[] memory assets, address source, address payable recipient) internal {
        uint256 assetCount = assets.length;
        for (uint256 i = 0; i < assetCount;) {
            _transfer(assets[i], source, recipient);
            unchecked {
                ++i;
            }
        }
    }

    /// @notice Transfers ETH to a recipient address
    /// @param recipient The transfer recipient
    /// @param amount The amount of ETH to transfer
    function _transferETH(address payable recipient, uint256 amount) internal {
        _assertNonZeroAmount(amount);

        bool success;
        assembly {
            success := call(10000, recipient, amount, 0, 0, 0, 0)
        }
        if (!success) {
            revert ETHER_TRANSFER_FAILED();
        }
    }

    /// @notice Transfers ERC20 tokens from a provided account to a recipient address
    /// @param token The token to transfer
    /// @param source The transfer source
    /// @param recipient The transfer recipient
    /// @param amount The amount to transfer
    function _transferERC20(address token, address source, address recipient, uint256 amount) internal {
        _assertNonZeroAmount(amount);

        // Use `transfer` if the source is this contract
        if (source == address(this)) {
            token.safeTransfer(recipient, amount);
        } else {
            token.safeTransferFrom(source, recipient, amount);
        }
    }

    /// @notice Transfers an ERC721 token to a recipient address
    /// @param token The token to transfer
    /// @param identifier The ID of the token to transfer
    /// @param source The transfer source
    /// @param recipient The transfer recipient
    /// @param amount The token amount (Must be 1)
    function _transferERC721(address token, uint256 identifier, address source, address recipient, uint256 amount)
        internal
    {
        if (amount != 1) {
            revert INVALID_ERC721_TRANSFER_AMOUNT();
        }
        ERC721(token).transferFrom(source, recipient, identifier);
    }

    /// @notice Transfers ERC1155 tokens to a recipient address
    /// @param token The token to transfer
    /// @param identifier The ID of the token to transfer
    /// @param source The transfer source
    /// @param recipient The transfer recipient
    /// @param amount The amount to transfer
    function _transferERC1155(address token, uint256 identifier, address source, address recipient, uint256 amount)
        internal
    {
        _assertNonZeroAmount(amount);

        ERC1155(token).safeTransferFrom(source, recipient, identifier, amount, new bytes(0));
    }

    /// @dev Ensure that a given asset amount is not zero
    /// @param amount The amount to check
    function _assertNonZeroAmount(uint256 amount) internal pure {
        // Revert if the supplied amount is equal to zero
        if (amount == 0) {
            revert MISSING_ASSET_AMOUNT();
        }
    }
}

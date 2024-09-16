// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Initializable} from 'solady/utils/Initializable.sol';
import {IUserPayoutEscrow} from 'src/interfaces/IUserPayoutEscrow.sol';
import {IUserPayoutEscrowFactory} from 'src/interfaces/IUserPayoutEscrowFactory.sol';
import {AssetController} from 'src/abstracts/AssetController.sol';

contract UserPayoutEscrow is IUserPayoutEscrow, Initializable, AssetController {
    /// @notice The factory that deployed this escrow.
    IUserPayoutEscrowFactory public factory;

    /// @dev Ensures the caller is the payer.
    modifier onlyPayer() {
        if (msg.sender != factory.payer()) revert ONLY_PAYER();
        _;
    }

    /// @dev Disable any future initialization.
    constructor() {
        _disableInitializers();
    }

    /// @param factory_ The factory that deployed this escrow.
    function initialize(address factory_) external initializer {
        factory = IUserPayoutEscrowFactory(factory_);
    }

    /// @notice Sends payouts to the recipient.
    /// @param recipient The recipient of the payouts.
    /// @param payouts The payouts to be sent.
    function send(address payable recipient, Payout[] calldata payouts) external onlyPayer {
        if (recipient == address(0)) revert INVALID_RECIPIENT();

        uint256 numberOfPayouts = payouts.length;
        for (uint256 i = 0; i < numberOfPayouts; ++i) {
            Payout memory payout = payouts[i];

            _transfer(payout.asset, payout.amount, address(this), recipient);
        }
        emit PayoutsSent(recipient, payouts);
    }
}

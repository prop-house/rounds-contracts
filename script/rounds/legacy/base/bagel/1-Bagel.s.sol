// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Script} from 'forge-std/Script.sol';
import {AssetController} from 'src/AssetController.sol';
import {FarcasterClaimV1} from 'src/legacy/FarcasterClaimV1.sol';
import {IFarcasterClaimV1} from 'src/legacy/interfaces/IFarcasterClaimV1.sol';

contract Bagel1 is Script {
    function run() public {
        uint256 ownerKey = vm.envUint('OWNER_PRIVATE_KEY');
        vm.startBroadcast(ownerKey);

        uint40 ROUND_ID = 32;

        FarcasterClaimV1 fc = FarcasterClaimV1(payable(vm.envAddress('FARCASTER_CLAIM_ADDRESS')));

        // BAGEL is offered in the round.
        fc.setAssetForRound(
            ROUND_ID,
            AssetController.Asset(
                AssetController.AssetType.ERC20, address(0x835e336782A1D04db6eb44C44024650D18a138C2), 0
            )
        );

        IFarcasterClaimV1.Winner[] memory winners = new IFarcasterClaimV1.Winner[](14);
        winners[0] = IFarcasterClaimV1.Winner({fid: 3950, amount: 5208333.333333333 ether});
        winners[1] = IFarcasterClaimV1.Winner({fid: 210744, amount: 1041666.6666666667 ether});
        winners[2] = IFarcasterClaimV1.Winner({fid: 394770, amount: 694444.4444444445 ether});
        winners[3] = IFarcasterClaimV1.Winner({fid: 399892, amount: 347222.22222222225 ether});
        winners[4] = IFarcasterClaimV1.Winner({fid: 399932, amount: 347222.22222222225 ether});
        winners[5] = IFarcasterClaimV1.Winner({fid: 406879, amount: 694444.4444444445 ether});
        winners[6] = IFarcasterClaimV1.Winner({fid: 407859, amount: 347222.22222222225 ether});
        winners[7] = IFarcasterClaimV1.Winner({fid: 408178, amount: 347222.22222222225 ether});
        winners[8] = IFarcasterClaimV1.Winner({fid: 409211, amount: 347222.22222222225 ether});
        winners[9] = IFarcasterClaimV1.Winner({fid: 409513, amount: 347222.22222222225 ether});
        winners[10] = IFarcasterClaimV1.Winner({fid: 413957, amount: 694444.4444444445 ether});
        winners[11] = IFarcasterClaimV1.Winner({fid: 417275, amount: 347222.22222222225 ether});
        winners[12] = IFarcasterClaimV1.Winner({fid: 423127, amount: 347222.22222222225 ether});
        winners[13] = IFarcasterClaimV1.Winner({fid: 425661, amount: 1388888.888888889 ether});

        fc.setWinnersForRound(ROUND_ID, winners);

        vm.stopBroadcast();
    }
}

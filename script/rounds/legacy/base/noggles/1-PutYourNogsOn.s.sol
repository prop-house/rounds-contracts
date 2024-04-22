// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Script} from 'forge-std/Script.sol';
import {AssetController} from 'src/AssetController.sol';
import {FarcasterClaimV1} from 'src/legacy/FarcasterClaimV1.sol';
import {IFarcasterClaimV1} from 'src/legacy/interfaces/IFarcasterClaimV1.sol';

contract PutYourNogsOn1 is Script {
    function run() public {
        uint256 ownerKey = vm.envUint('OWNER_PRIVATE_KEY');
        vm.startBroadcast(ownerKey);

        uint40 ROUND_ID = 17;

        FarcasterClaimV1 fc = FarcasterClaimV1(payable(vm.envAddress('FARCASTER_CLAIM_ADDRESS')));

        // NOGS is offered in the round.
        fc.setAssetForRound(
            ROUND_ID,
            AssetController.Asset(
                AssetController.AssetType.ERC20, address(0x13741C5dF9aB03E7Aa9Fb3Bf1f714551dD5A5F8a), 0
            )
        );

        IFarcasterClaimV1.Winner[] memory winners = new IFarcasterClaimV1.Winner[](26);
        winners[0] = IFarcasterClaimV1.Winner({fid: 2163, amount: 104166.66666666667 ether});
        winners[1] = IFarcasterClaimV1.Winner({fid: 3827, amount: 312500 ether});
        winners[2] = IFarcasterClaimV1.Winner({fid: 10430, amount: 104166.66666666667 ether});
        winners[3] = IFarcasterClaimV1.Winner({fid: 13006, amount: 520833.3333333334 ether});
        winners[4] = IFarcasterClaimV1.Winner({fid: 15434, amount: 1354166.6666666667 ether});
        winners[5] = IFarcasterClaimV1.Winner({fid: 20133, amount: 312500 ether});
        winners[6] = IFarcasterClaimV1.Winner({fid: 20198, amount: 2291666.666666667 ether});
        winners[7] = IFarcasterClaimV1.Winner({fid: 20624, amount: 104166.66666666667 ether});
        winners[8] = IFarcasterClaimV1.Winner({fid: 23192, amount: 104166.66666666667 ether});
        winners[9] = IFarcasterClaimV1.Winner({fid: 191593, amount: 104166.66666666667 ether});
        winners[10] = IFarcasterClaimV1.Winner({fid: 193998, amount: 1041666.6666666667 ether});
        winners[11] = IFarcasterClaimV1.Winner({fid: 196215, amount: 416666.6666666667 ether});
        winners[12] = IFarcasterClaimV1.Winner({fid: 214447, amount: 312500 ether});
        winners[13] = IFarcasterClaimV1.Winner({fid: 228795, amount: 208333.33333333334 ether});
        winners[14] = IFarcasterClaimV1.Winner({fid: 240987, amount: 312500 ether});
        winners[15] = IFarcasterClaimV1.Winner({fid: 246523, amount: 208333.33333333334 ether});
        winners[16] = IFarcasterClaimV1.Winner({fid: 263648, amount: 104166.66666666667 ether});
        winners[17] = IFarcasterClaimV1.Winner({fid: 323251, amount: 1041666.6666666667 ether});
        winners[18] = IFarcasterClaimV1.Winner({fid: 368096, amount: 104166.66666666667 ether});
        winners[19] = IFarcasterClaimV1.Winner({fid: 392157, amount: 104166.66666666667 ether});
        winners[20] = IFarcasterClaimV1.Winner({fid: 392209, amount: 104166.66666666667 ether});
        winners[21] = IFarcasterClaimV1.Winner({fid: 398799, amount: 208333.33333333334 ether});
        winners[22] = IFarcasterClaimV1.Winner({fid: 399306, amount: 104166.66666666667 ether});
        winners[23] = IFarcasterClaimV1.Winner({fid: 403304, amount: 208333.33333333334 ether});
        winners[24] = IFarcasterClaimV1.Winner({fid: 403318, amount: 104166.66666666667 ether});
        winners[25] = IFarcasterClaimV1.Winner({fid: 413213, amount: 104166.66666666667 ether});

        fc.setWinnersForRound(ROUND_ID, winners);

        vm.stopBroadcast();
    }
}

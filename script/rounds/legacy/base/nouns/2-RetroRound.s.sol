// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Script} from 'forge-std/Script.sol';
import {AssetController} from 'src/AssetController.sol';
import {FarcasterClaimV1} from 'src/legacy/FarcasterClaimV1.sol';
import {IFarcasterClaimV1} from 'src/legacy/interfaces/IFarcasterClaimV1.sol';

contract RetroRound2 is Script {
    function run() public {
        uint256 ownerKey = vm.envUint('OWNER_PRIVATE_KEY');
        vm.startBroadcast(ownerKey);

        uint40 ROUND_ID = 2;

        FarcasterClaimV1 fc = FarcasterClaimV1(payable(vm.envAddress('FARCASTER_CLAIM_ADDRESS')));

        // ETH is offered in the round.
        fc.setAssetForRound(ROUND_ID, AssetController.Asset(AssetController.AssetType.ETH, address(0), 0));

        IFarcasterClaimV1.Winner[] memory winners = new IFarcasterClaimV1.Winner[](38);
        winners[0] = IFarcasterClaimV1.Winner({fid: 803, amount: 0.219718 ether});
        winners[1] = IFarcasterClaimV1.Winner({fid: 1886, amount: 0.177465 ether});
        winners[2] = IFarcasterClaimV1.Winner({fid: 2235, amount: 0.152113 ether});
        winners[3] = IFarcasterClaimV1.Winner({fid: 2433, amount: 0.160563 ether});
        winners[4] = IFarcasterClaimV1.Winner({fid: 3095, amount: 0.059155 ether});
        winners[5] = IFarcasterClaimV1.Winner({fid: 3642, amount: 0.152113 ether});
        winners[6] = IFarcasterClaimV1.Winner({fid: 3827, amount: 0.042254 ether});
        winners[7] = IFarcasterClaimV1.Winner({fid: 4487, amount: 0.202817 ether});
        winners[8] = IFarcasterClaimV1.Winner({fid: 4567, amount: 0.076056 ether});
        winners[9] = IFarcasterClaimV1.Winner({fid: 5450, amount: 0.084507 ether});
        winners[10] = IFarcasterClaimV1.Winner({fid: 5701, amount: 0.092958 ether});
        winners[11] = IFarcasterClaimV1.Winner({fid: 6164, amount: 0.008451 ether});
        winners[12] = IFarcasterClaimV1.Winner({fid: 6852, amount: 0.033803 ether});
        winners[13] = IFarcasterClaimV1.Winner({fid: 7418, amount: 0.143662 ether});
        winners[14] = IFarcasterClaimV1.Winner({fid: 7759, amount: 0.160563 ether});
        winners[15] = IFarcasterClaimV1.Winner({fid: 9135, amount: 0.228169 ether});
        winners[16] = IFarcasterClaimV1.Winner({fid: 9391, amount: 0.025352 ether});
        winners[17] = IFarcasterClaimV1.Winner({fid: 11500, amount: 0.050704 ether});
        winners[18] = IFarcasterClaimV1.Winner({fid: 12111, amount: 0.008451 ether});
        winners[19] = IFarcasterClaimV1.Winner({fid: 12590, amount: 0.101408 ether});
        winners[20] = IFarcasterClaimV1.Winner({fid: 13006, amount: 0.042253 ether});
        winners[21] = IFarcasterClaimV1.Winner({fid: 15434, amount: 0.11831 ether});
        winners[22] = IFarcasterClaimV1.Winner({fid: 18570, amount: 0.042254 ether});
        winners[23] = IFarcasterClaimV1.Winner({fid: 20147, amount: 0.059155 ether});
        winners[24] = IFarcasterClaimV1.Winner({fid: 210444, amount: 0.008451 ether});
        winners[25] = IFarcasterClaimV1.Winner({fid: 214447, amount: 0.067606 ether});
        winners[26] = IFarcasterClaimV1.Winner({fid: 214753, amount: 0.016901 ether});
        winners[27] = IFarcasterClaimV1.Winner({fid: 216523, amount: 0.126759 ether});
        winners[28] = IFarcasterClaimV1.Winner({fid: 217261, amount: 0.008451 ether});
        winners[29] = IFarcasterClaimV1.Winner({fid: 224636, amount: 0.050704 ether});
        winners[30] = IFarcasterClaimV1.Winner({fid: 243300, amount: 0.076056 ether});
        winners[31] = IFarcasterClaimV1.Winner({fid: 245681, amount: 0.042254 ether});
        winners[32] = IFarcasterClaimV1.Winner({fid: 246448, amount: 0.008451 ether});
        winners[33] = IFarcasterClaimV1.Winner({fid: 260114, amount: 0.033803 ether});
        winners[34] = IFarcasterClaimV1.Winner({fid: 263498, amount: 0.033803 ether});
        winners[35] = IFarcasterClaimV1.Winner({fid: 283030, amount: 0.016901 ether});
        winners[36] = IFarcasterClaimV1.Winner({fid: 308666, amount: 0.050704 ether});
        winners[37] = IFarcasterClaimV1.Winner({fid: 367876, amount: 0.016901 ether});

        fc.setWinnersForRound(ROUND_ID, winners);

        vm.stopBroadcast();
    }
}

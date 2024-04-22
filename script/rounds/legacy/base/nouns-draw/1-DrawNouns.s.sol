// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Script} from 'forge-std/Script.sol';
import {AssetController} from 'src/AssetController.sol';
import {FarcasterClaimV1} from 'src/legacy/FarcasterClaimV1.sol';
import {IFarcasterClaimV1} from 'src/legacy/interfaces/IFarcasterClaimV1.sol';

contract DrawNouns1 is Script {
    function run() public {
        uint256 ownerKey = vm.envUint('OWNER_PRIVATE_KEY');
        vm.startBroadcast(ownerKey);

        uint40 ROUND_ID = 41;

        FarcasterClaimV1 fc = FarcasterClaimV1(payable(vm.envAddress('FARCASTER_CLAIM_ADDRESS')));

        // ETH is offered in the round.
        fc.setAssetForRound(ROUND_ID, AssetController.Asset(AssetController.AssetType.ETH, address(0), 0));

        IFarcasterClaimV1.Winner[] memory winners = new IFarcasterClaimV1.Winner[](41);
        winners[0] = IFarcasterClaimV1.Winner({fid: 3413, amount: 0.1038961038961039 ether});
        winners[1] = IFarcasterClaimV1.Winner({fid: 4383, amount: 0.006493506493506494 ether});
        winners[2] = IFarcasterClaimV1.Winner({fid: 4577, amount: 0.05194805194805195 ether});
        winners[3] = IFarcasterClaimV1.Winner({fid: 5632, amount: 0.07142857142857144 ether});
        winners[4] = IFarcasterClaimV1.Winner({fid: 15294, amount: 0.025974025974025976 ether});
        winners[5] = IFarcasterClaimV1.Winner({fid: 20013, amount: 0.05194805194805195 ether});
        winners[6] = IFarcasterClaimV1.Winner({fid: 20359, amount: 0.006493506493506494 ether});
        winners[7] = IFarcasterClaimV1.Winner({fid: 20539, amount: 0.025974025974025976 ether});
        winners[8] = IFarcasterClaimV1.Winner({fid: 197061, amount: 0.07792207792207792 ether});
        winners[9] = IFarcasterClaimV1.Winner({fid: 221477, amount: 0.045454545454545456 ether});
        winners[10] = IFarcasterClaimV1.Winner({fid: 228911, amount: 0.01948051948051948 ether});
        winners[11] = IFarcasterClaimV1.Winner({fid: 234512, amount: 0.01948051948051948 ether});
        winners[12] = IFarcasterClaimV1.Winner({fid: 253402, amount: 0.012987012987012988 ether});
        winners[13] = IFarcasterClaimV1.Winner({fid: 263648, amount: 0.006493506493506494 ether});
        winners[14] = IFarcasterClaimV1.Winner({fid: 290654, amount: 0.012987012987012988 ether});
        winners[15] = IFarcasterClaimV1.Winner({fid: 296588, amount: 0.006493506493506494 ether});
        winners[16] = IFarcasterClaimV1.Winner({fid: 308607, amount: 0.006493506493506494 ether});
        winners[17] = IFarcasterClaimV1.Winner({fid: 310382, amount: 0.006493506493506494 ether});
        winners[18] = IFarcasterClaimV1.Winner({fid: 313054, amount: 0.012987012987012988 ether});
        winners[19] = IFarcasterClaimV1.Winner({fid: 374867, amount: 0.03246753246753247 ether});
        winners[20] = IFarcasterClaimV1.Winner({fid: 382205, amount: 0.07792207792207793 ether});
        winners[21] = IFarcasterClaimV1.Winner({fid: 382808, amount: 0.01948051948051948 ether});
        winners[22] = IFarcasterClaimV1.Winner({fid: 396844, amount: 0.01948051948051948 ether});
        winners[23] = IFarcasterClaimV1.Winner({fid: 396891, amount: 0.05844155844155845 ether});
        winners[24] = IFarcasterClaimV1.Winner({fid: 396902, amount: 0.03246753246753247 ether});
        winners[25] = IFarcasterClaimV1.Winner({fid: 397077, amount: 0.006493506493506494 ether});
        winners[26] = IFarcasterClaimV1.Winner({fid: 399310, amount: 0.006493506493506494 ether});
        winners[27] = IFarcasterClaimV1.Winner({fid: 409379, amount: 0.006493506493506494 ether});
        winners[28] = IFarcasterClaimV1.Winner({fid: 413213, amount: 0.006493506493506494 ether});
        winners[29] = IFarcasterClaimV1.Winner({fid: 417318, amount: 0.006493506493506494 ether});
        winners[30] = IFarcasterClaimV1.Winner({fid: 425661, amount: 0.006493506493506494 ether});
        winners[31] = IFarcasterClaimV1.Winner({fid: 433072, amount: 0.012987012987012988 ether});
        winners[32] = IFarcasterClaimV1.Winner({fid: 434038, amount: 0.006493506493506494 ether});
        winners[33] = IFarcasterClaimV1.Winner({fid: 441949, amount: 0.025974025974025976 ether});
        winners[34] = IFarcasterClaimV1.Winner({fid: 452609, amount: 0.006493506493506494 ether});
        winners[35] = IFarcasterClaimV1.Winner({fid: 457752, amount: 0.012987012987012988 ether});
        winners[36] = IFarcasterClaimV1.Winner({fid: 465810, amount: 0.012987012987012988 ether});
        winners[37] = IFarcasterClaimV1.Winner({fid: 466693, amount: 0.012987012987012988 ether});
        winners[38] = IFarcasterClaimV1.Winner({fid: 487407, amount: 0.012987012987012988 ether});
        winners[39] = IFarcasterClaimV1.Winner({fid: 488938, amount: 0.025974025974025976 ether});
        winners[40] = IFarcasterClaimV1.Winner({fid: 490689, amount: 0.01948051948051948 ether});

        fc.setWinnersForRound(ROUND_ID, winners);

        vm.stopBroadcast();
    }
}

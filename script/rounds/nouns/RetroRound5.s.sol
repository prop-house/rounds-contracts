// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Script} from 'forge-std/Script.sol';
import {FarcasterClaim} from 'src/FarcasterClaim.sol';
import {AssetController} from 'src/AssetController.sol';
import {IFarcasterClaim} from 'src/interfaces/IFarcasterClaim.sol';

contract RetroRound5 is Script {
    function run() public {
        uint256 ownerKey = vm.envUint('OWNER_PRIVATE_KEY');
        vm.startBroadcast(ownerKey);

        uint40 ROUND_ID = 5;

        FarcasterClaim fc = FarcasterClaim(payable(vm.envAddress('FARCASTER_CLAIM_ADDRESS')));

        // ETH is offered in the round.
        fc.setAssetForRound(ROUND_ID, AssetController.Asset(AssetController.AssetType.ETH, address(0), 0));

        IFarcasterClaim.Winner[] memory winners = new IFarcasterClaim.Winner[](112);
        winners[0] = IFarcasterClaim.Winner({fid: 8, amount: 0.04745529573590096 ether});
        winners[1] = IFarcasterClaim.Winner({fid: 54, amount: 0.006189821182943603 ether});
        winners[2] = IFarcasterClaim.Winner({fid: 429, amount: 0.002063273727647867 ether});
        winners[3] = IFarcasterClaim.Winner({fid: 472, amount: 0.18775790921595592 ether});
        winners[4] = IFarcasterClaim.Winner({fid: 742, amount: 0.002063273727647867 ether});
        winners[5] = IFarcasterClaim.Winner({fid: 803, amount: 0.02682255845942228 ether});
        winners[6] = IFarcasterClaim.Winner({fid: 834, amount: 0.059834938101788165 ether});
        winners[7] = IFarcasterClaim.Winner({fid: 1079, amount: 0.024759284731774415 ether});
        winners[8] = IFarcasterClaim.Winner({fid: 1097, amount: 0.12998624484181567 ether});
        winners[9] = IFarcasterClaim.Winner({fid: 1301, amount: 0.22696011004126543 ether});
        winners[10] = IFarcasterClaim.Winner({fid: 1407, amount: 0.002063273727647867 ether});
        winners[11] = IFarcasterClaim.Winner({fid: 1556, amount: 0.033012379642365884 ether});
        winners[12] = IFarcasterClaim.Winner({fid: 1894, amount: 0.02682255845942228 ether});
        winners[13] = IFarcasterClaim.Winner({fid: 2235, amount: 0.02475928473177441 ether});
        winners[14] = IFarcasterClaim.Winner({fid: 2266, amount: 0.01031636863823934 ether});
        winners[15] = IFarcasterClaim.Winner({fid: 2433, amount: 0.1795048143053645 ether});
        winners[16] = IFarcasterClaim.Winner({fid: 2618, amount: 0.002063273727647867 ether});
        winners[17] = IFarcasterClaim.Winner({fid: 2757, amount: 0.026822558459422278 ether});
        winners[18] = IFarcasterClaim.Winner({fid: 3095, amount: 0.012379642365887206 ether});
        winners[19] = IFarcasterClaim.Winner({fid: 3413, amount: 0.006189821182943603 ether});
        winners[20] = IFarcasterClaim.Winner({fid: 3417, amount: 0.0453920220082531 ether});
        winners[21] = IFarcasterClaim.Winner({fid: 3642, amount: 0.11966987620357632 ether});
        winners[22] = IFarcasterClaim.Winner({fid: 3711, amount: 0.0577716643741403 ether});
        winners[23] = IFarcasterClaim.Winner({fid: 3734, amount: 0.02063273727647868 ether});
        winners[24] = IFarcasterClaim.Winner({fid: 3781, amount: 0.014442916093535074 ether});
        winners[25] = IFarcasterClaim.Winner({fid: 3827, amount: 0.03094910591471801 ether});
        winners[26] = IFarcasterClaim.Winner({fid: 3895, amount: 0.01856946354883081 ether});
        winners[27] = IFarcasterClaim.Winner({fid: 4132, amount: 0.008253094910591471 ether});
        winners[28] = IFarcasterClaim.Winner({fid: 4134, amount: 0.012379642365887207 ether});
        winners[29] = IFarcasterClaim.Winner({fid: 4167, amount: 0.026822558459422278 ether});
        winners[30] = IFarcasterClaim.Winner({fid: 4199, amount: 0.004126547455295735 ether});
        winners[31] = IFarcasterClaim.Winner({fid: 4513, amount: 0.002063273727647867 ether});
        winners[32] = IFarcasterClaim.Winner({fid: 4567, amount: 0.0453920220082531 ether});
        winners[33] = IFarcasterClaim.Winner({fid: 4583, amount: 0.002063273727647867 ether});
        winners[34] = IFarcasterClaim.Winner({fid: 4719, amount: 0.002063273727647867 ether});
        winners[35] = IFarcasterClaim.Winner({fid: 4795, amount: 0.04126547455295735 ether});
        winners[36] = IFarcasterClaim.Winner({fid: 4895, amount: 0.01031636863823934 ether});
        winners[37] = IFarcasterClaim.Winner({fid: 5376, amount: 0.008253094910591471 ether});
        winners[38] = IFarcasterClaim.Winner({fid: 5515, amount: 0.022696011004126545 ether});
        winners[39] = IFarcasterClaim.Winner({fid: 5701, amount: 0.024759284731774415 ether});
        winners[40] = IFarcasterClaim.Winner({fid: 5708, amount: 0.002063273727647867 ether});
        winners[41] = IFarcasterClaim.Winner({fid: 7143, amount: 0.004126547455295735 ether});
        winners[42] = IFarcasterClaim.Winner({fid: 7418, amount: 0.014442916093535076 ether});
        winners[43] = IFarcasterClaim.Winner({fid: 7759, amount: 0.03920220082530949 ether});
        winners[44] = IFarcasterClaim.Winner({fid: 8680, amount: 0.08459422283356258 ether});
        winners[45] = IFarcasterClaim.Winner({fid: 9280, amount: 0.1320495185694635 ether});
        winners[46] = IFarcasterClaim.Winner({fid: 9581, amount: 0.016506189821182942 ether});
        winners[47] = IFarcasterClaim.Winner({fid: 9967, amount: 0.008253094910591471 ether});
        winners[48] = IFarcasterClaim.Winner({fid: 10605, amount: 0.04951856946354883 ether});
        winners[49] = IFarcasterClaim.Winner({fid: 11500, amount: 0.008253094910591471 ether});
        winners[50] = IFarcasterClaim.Winner({fid: 11508, amount: 0.006189821182943603 ether});
        winners[51] = IFarcasterClaim.Winner({fid: 11617, amount: 0.002063273727647867 ether});
        winners[52] = IFarcasterClaim.Winner({fid: 11778, amount: 0.004126547455295735 ether});
        winners[53] = IFarcasterClaim.Winner({fid: 11990, amount: 0.012379642365887206 ether});
        winners[54] = IFarcasterClaim.Winner({fid: 12342, amount: 0.08665749656121044 ether});
        winners[55] = IFarcasterClaim.Winner({fid: 12590, amount: 0.016506189821182942 ether});
        winners[56] = IFarcasterClaim.Winner({fid: 13006, amount: 0.006189821182943603 ether});
        winners[57] = IFarcasterClaim.Winner({fid: 14396, amount: 0.004126547455295735 ether});
        winners[58] = IFarcasterClaim.Winner({fid: 14782, amount: 0.006189821182943603 ether});
        winners[59] = IFarcasterClaim.Winner({fid: 15153, amount: 0.002063273727647867 ether});
        winners[60] = IFarcasterClaim.Winner({fid: 15434, amount: 0.04951856946354882 ether});
        winners[61] = IFarcasterClaim.Winner({fid: 15516, amount: 0.012379642365887206 ether});
        winners[62] = IFarcasterClaim.Winner({fid: 19530, amount: 0.03920220082530949 ether});
        winners[63] = IFarcasterClaim.Winner({fid: 20104, amount: 0.02682255845942228 ether});
        winners[64] = IFarcasterClaim.Winner({fid: 20133, amount: 0.006189821182943603 ether});
        winners[65] = IFarcasterClaim.Winner({fid: 20147, amount: 0.014442916093535074 ether});
        winners[66] = IFarcasterClaim.Winner({fid: 20198, amount: 0.1217331499312242 ether});
        winners[67] = IFarcasterClaim.Winner({fid: 20539, amount: 0.028885832187070148 ether});
        winners[68] = IFarcasterClaim.Winner({fid: 20558, amount: 0.006189821182943603 ether});
        winners[69] = IFarcasterClaim.Winner({fid: 20721, amount: 0.004126547455295735 ether});
        winners[70] = IFarcasterClaim.Winner({fid: 20945, amount: 0.016506189821182942 ether});
        winners[71] = IFarcasterClaim.Winner({fid: 20977, amount: 0.002063273727647867 ether});
        winners[72] = IFarcasterClaim.Winner({fid: 22420, amount: 0.002063273727647867 ether});
        winners[73] = IFarcasterClaim.Winner({fid: 23036, amount: 0.002063273727647867 ether});
        winners[74] = IFarcasterClaim.Winner({fid: 23426, amount: 0.002063273727647867 ether});
        winners[75] = IFarcasterClaim.Winner({fid: 191593, amount: 0.022696011004126545 ether});
        winners[76] = IFarcasterClaim.Winner({fid: 191770, amount: 0.002063273727647867 ether});
        winners[77] = IFarcasterClaim.Winner({fid: 193159, amount: 0.01031636863823934 ether});
        winners[78] = IFarcasterClaim.Winner({fid: 193998, amount: 0.03507565337001375 ether});
        winners[79] = IFarcasterClaim.Winner({fid: 210628, amount: 0.002063273727647867 ether});
        winners[80] = IFarcasterClaim.Winner({fid: 211135, amount: 0.006189821182943603 ether});
        winners[81] = IFarcasterClaim.Winner({fid: 216523, amount: 0.002063273727647867 ether});
        winners[82] = IFarcasterClaim.Winner({fid: 224636, amount: 0.012379642365887206 ether});
        winners[83] = IFarcasterClaim.Winner({fid: 225736, amount: 0.008253094910591471 ether});
        winners[84] = IFarcasterClaim.Winner({fid: 226517, amount: 0.05983493810178817 ether});
        winners[85] = IFarcasterClaim.Winner({fid: 226538, amount: 0.04745529573590096 ether});
        winners[86] = IFarcasterClaim.Winner({fid: 230941, amount: 0.09078404401650618 ether});
        winners[87] = IFarcasterClaim.Winner({fid: 238425, amount: 0.002063273727647867 ether});
        winners[88] = IFarcasterClaim.Winner({fid: 243300, amount: 0.11966987620357633 ether});
        winners[89] = IFarcasterClaim.Winner({fid: 244145, amount: 0.004126547455295735 ether});
        winners[90] = IFarcasterClaim.Winner({fid: 246523, amount: 0.002063273727647867 ether});
        winners[91] = IFarcasterClaim.Winner({fid: 248032, amount: 0.002063273727647867 ether});
        winners[92] = IFarcasterClaim.Winner({fid: 249586, amount: 0.004126547455295735 ether});
        winners[93] = IFarcasterClaim.Winner({fid: 253193, amount: 0.004126547455295735 ether});
        winners[94] = IFarcasterClaim.Winner({fid: 263943, amount: 0.006189821182943603 ether});
        winners[95] = IFarcasterClaim.Winner({fid: 266767, amount: 0.006189821182943603 ether});
        winners[96] = IFarcasterClaim.Winner({fid: 268290, amount: 0.006189821182943603 ether});
        winners[97] = IFarcasterClaim.Winner({fid: 272717, amount: 0.002063273727647867 ether});
        winners[98] = IFarcasterClaim.Winner({fid: 273430, amount: 0.002063273727647867 ether});
        winners[99] = IFarcasterClaim.Winner({fid: 297024, amount: 0.006189821182943603 ether});
        winners[100] = IFarcasterClaim.Winner({fid: 310213, amount: 0.004126547455295735 ether});
        winners[101] = IFarcasterClaim.Winner({fid: 312747, amount: 0.002063273727647867 ether});
        winners[102] = IFarcasterClaim.Winner({fid: 323251, amount: 0.061898211829436035 ether});
        winners[103] = IFarcasterClaim.Winner({fid: 342737, amount: 0.002063273727647867 ether});
        winners[104] = IFarcasterClaim.Winner({fid: 368096, amount: 0.002063273727647867 ether});
        winners[105] = IFarcasterClaim.Winner({fid: 378356, amount: 0.002063273727647867 ether});
        winners[106] = IFarcasterClaim.Winner({fid: 378856, amount: 0.002063273727647867 ether});
        winners[107] = IFarcasterClaim.Winner({fid: 382205, amount: 0.012379642365887207 ether});
        winners[108] = IFarcasterClaim.Winner({fid: 384860, amount: 0.004126547455295735 ether});
        winners[109] = IFarcasterClaim.Winner({fid: 384865, amount: 0.004126547455295735 ether});
        winners[110] = IFarcasterClaim.Winner({fid: 388453, amount: 0.012379642365887207 ether});
        winners[111] = IFarcasterClaim.Winner({fid: 390647, amount: 0.028885832187070148 ether});

        fc.setWinnersForRound(ROUND_ID, winners);

        vm.stopBroadcast();
    }
}

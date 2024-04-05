// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Script} from 'forge-std/Script.sol';
import {AssetController} from 'src/AssetController.sol';
import {FarcasterClaimV1} from 'src/legacy/FarcasterClaimV1.sol';
import {IFarcasterClaimV1} from 'src/legacy/interfaces/IFarcasterClaimV1.sol';

contract MemesForMembers1 is Script {
    function run() public {
        uint256 ownerKey = vm.envUint('OWNER_PRIVATE_KEY');
        vm.startBroadcast(ownerKey);

        uint40 ROUND_ID = 8;

        FarcasterClaimV1 fc = FarcasterClaimV1(payable(vm.envAddress('FARCASTER_CLAIM_ADDRESS')));

        // ETH is offered in the round.
        fc.setAssetForRound(
            ROUND_ID,
            AssetController.Asset(
                AssetController.AssetType.ERC20, address(0x7d89E05c0B93B24B5Cb23A073E60D008FEd1aCF9), 0
            )
        );

        IFarcasterClaimV1.Winner[] memory winners = new IFarcasterClaimV1.Winner[](73);
        winners[0] = IFarcasterClaimV1.Winner({fid: 803, amount: 15625 ether});
        winners[1] = IFarcasterClaimV1.Winner({fid: 1668, amount: 13020.83333333333 ether});
        winners[2] = IFarcasterClaimV1.Winner({fid: 1725, amount: 18229.166666666664 ether});
        winners[3] = IFarcasterClaimV1.Winner({fid: 2240, amount: 7812.5 ether});
        winners[4] = IFarcasterClaimV1.Winner({fid: 3295, amount: 2604.1666666666665 ether});
        winners[5] = IFarcasterClaimV1.Winner({fid: 3372, amount: 13020.833333333332 ether});
        winners[6] = IFarcasterClaimV1.Winner({fid: 3827, amount: 15625 ether});
        winners[7] = IFarcasterClaimV1.Winner({fid: 4567, amount: 5208.333333333333 ether});
        winners[8] = IFarcasterClaimV1.Winner({fid: 4715, amount: 18229.166666666664 ether});
        winners[9] = IFarcasterClaimV1.Winner({fid: 5543, amount: 7812.5 ether});
        winners[10] = IFarcasterClaimV1.Winner({fid: 7729, amount: 5208.333333333333 ether});
        winners[11] = IFarcasterClaimV1.Winner({fid: 7759, amount: 13020.833333333332 ether});
        winners[12] = IFarcasterClaimV1.Winner({fid: 8152, amount: 20833.333333333332 ether});
        winners[13] = IFarcasterClaimV1.Winner({fid: 8481, amount: 2604.1666666666665 ether});
        winners[14] = IFarcasterClaimV1.Winner({fid: 9318, amount: 2604.1666666666665 ether});
        winners[15] = IFarcasterClaimV1.Winner({fid: 9967, amount: 5208.333333333333 ether});
        winners[16] = IFarcasterClaimV1.Winner({fid: 10093, amount: 7812.5 ether});
        winners[17] = IFarcasterClaimV1.Winner({fid: 11050, amount: 10416.666666666666 ether});
        winners[18] = IFarcasterClaimV1.Winner({fid: 13432, amount: 7812.5 ether});
        winners[19] = IFarcasterClaimV1.Winner({fid: 13563, amount: 41666.666666666664 ether});
        winners[20] = IFarcasterClaimV1.Winner({fid: 13642, amount: 23437.5 ether});
        winners[21] = IFarcasterClaimV1.Winner({fid: 13986, amount: 7812.5 ether});
        winners[22] = IFarcasterClaimV1.Winner({fid: 15434, amount: 18229.166666666664 ether});
        winners[23] = IFarcasterClaimV1.Winner({fid: 15441, amount: 2604.1666666666665 ether});
        winners[24] = IFarcasterClaimV1.Winner({fid: 17568, amount: 2604.1666666666665 ether});
        winners[25] = IFarcasterClaimV1.Winner({fid: 18085, amount: 44270.83333333333 ether});
        winners[26] = IFarcasterClaimV1.Winner({fid: 19530, amount: 5208.333333333333 ether});
        winners[27] = IFarcasterClaimV1.Winner({fid: 19642, amount: 5208.333333333333 ether});
        winners[28] = IFarcasterClaimV1.Winner({fid: 20334, amount: 7812.5 ether});
        winners[29] = IFarcasterClaimV1.Winner({fid: 22420, amount: 5208.333333333333 ether});
        winners[30] = IFarcasterClaimV1.Winner({fid: 196215, amount: 20833.333333333332 ether});
        winners[31] = IFarcasterClaimV1.Winner({fid: 209951, amount: 101562.50000000001 ether});
        winners[32] = IFarcasterClaimV1.Winner({fid: 211654, amount: 2604.1666666666665 ether});
        winners[33] = IFarcasterClaimV1.Winner({fid: 212156, amount: 13020.833333333332 ether});
        winners[34] = IFarcasterClaimV1.Winner({fid: 216523, amount: 2604.1666666666665 ether});
        winners[35] = IFarcasterClaimV1.Winner({fid: 221166, amount: 7812.5 ether});
        winners[36] = IFarcasterClaimV1.Winner({fid: 228795, amount: 18229.166666666668 ether});
        winners[37] = IFarcasterClaimV1.Winner({fid: 239413, amount: 2604.1666666666665 ether});
        winners[38] = IFarcasterClaimV1.Winner({fid: 239933, amount: 26041.666666666668 ether});
        winners[39] = IFarcasterClaimV1.Winner({fid: 241952, amount: 2604.1666666666665 ether});
        winners[40] = IFarcasterClaimV1.Winner({fid: 242692, amount: 5208.333333333333 ether});
        winners[41] = IFarcasterClaimV1.Winner({fid: 243300, amount: 46875 ether});
        winners[42] = IFarcasterClaimV1.Winner({fid: 244881, amount: 2604.1666666666665 ether});
        winners[43] = IFarcasterClaimV1.Winner({fid: 245579, amount: 10416.666666666666 ether});
        winners[44] = IFarcasterClaimV1.Winner({fid: 245681, amount: 2604.1666666666665 ether});
        winners[45] = IFarcasterClaimV1.Winner({fid: 247605, amount: 5208.333333333333 ether});
        winners[46] = IFarcasterClaimV1.Winner({fid: 247946, amount: 5208.333333333333 ether});
        winners[47] = IFarcasterClaimV1.Winner({fid: 248216, amount: 70312.5 ether});
        winners[48] = IFarcasterClaimV1.Winner({fid: 253127, amount: 5208.333333333333 ether});
        winners[49] = IFarcasterClaimV1.Winner({fid: 254141, amount: 2604.1666666666665 ether});
        winners[50] = IFarcasterClaimV1.Winner({fid: 256829, amount: 67708.33333333333 ether});
        winners[51] = IFarcasterClaimV1.Winner({fid: 262159, amount: 5208.333333333333 ether});
        winners[52] = IFarcasterClaimV1.Winner({fid: 263498, amount: 5208.333333333333 ether});
        winners[53] = IFarcasterClaimV1.Winner({fid: 270583, amount: 13020.833333333332 ether});
        winners[54] = IFarcasterClaimV1.Winner({fid: 277480, amount: 5208.333333333333 ether});
        winners[55] = IFarcasterClaimV1.Winner({fid: 290734, amount: 5208.333333333333 ether});
        winners[56] = IFarcasterClaimV1.Winner({fid: 296520, amount: 5208.333333333333 ether});
        winners[57] = IFarcasterClaimV1.Winner({fid: 297066, amount: 5208.333333333333 ether});
        winners[58] = IFarcasterClaimV1.Winner({fid: 303166, amount: 2604.1666666666665 ether});
        winners[59] = IFarcasterClaimV1.Winner({fid: 304864, amount: 7812.5 ether});
        winners[60] = IFarcasterClaimV1.Winner({fid: 306670, amount: 5208.333333333333 ether});
        winners[61] = IFarcasterClaimV1.Winner({fid: 309710, amount: 20833.333333333332 ether});
        winners[62] = IFarcasterClaimV1.Winner({fid: 311254, amount: 5208.333333333333 ether});
        winners[63] = IFarcasterClaimV1.Winner({fid: 315944, amount: 2604.1666666666 ether});
        winners[64] = IFarcasterClaimV1.Winner({fid: 323251, amount: 70312.5 ether});
        winners[65] = IFarcasterClaimV1.Winner({fid: 343580, amount: 36458.33333333333 ether});
        winners[66] = IFarcasterClaimV1.Winner({fid: 367335, amount: 2604.166666666666 ether});
        winners[67] = IFarcasterClaimV1.Winner({fid: 375255, amount: 2604.166666666666 ether});
        winners[68] = IFarcasterClaimV1.Winner({fid: 376177, amount: 5208.333333333333 ether});
        winners[69] = IFarcasterClaimV1.Winner({fid: 385537, amount: 5208.333333333333 ether});
        winners[70] = IFarcasterClaimV1.Winner({fid: 390276, amount: 2604.166666666666 ether});
        winners[71] = IFarcasterClaimV1.Winner({fid: 393303, amount: 5208.333333333333 ether});
        winners[72] = IFarcasterClaimV1.Winner({fid: 399039, amount: 2604.166666666 ether});

        fc.setWinnersForRound(ROUND_ID, winners);

        vm.stopBroadcast();
    }
}

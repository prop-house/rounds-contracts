// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Script} from 'forge-std/Script.sol';
import {FarcasterClaim} from 'src/FarcasterClaim.sol';
import {AssetController} from 'src/AssetController.sol';
import {IFarcasterClaim} from 'src/interfaces/IFarcasterClaim.sol';

contract MemesForMembers1 is Script {
    function run() public {
        uint256 ownerKey = vm.envUint('OWNER_PRIVATE_KEY');
        vm.startBroadcast(ownerKey);

        uint40 ROUND_ID = 8;

        FarcasterClaim fc = FarcasterClaim(payable(vm.envAddress('FARCASTER_CLAIM_ADDRESS')));

        // ETH is offered in the round.
        fc.setAssetForRound(
            ROUND_ID,
            AssetController.Asset(
                AssetController.AssetType.ERC20, address(0x7d89E05c0B93B24B5Cb23A073E60D008FEd1aCF9), 0
            )
        );

        IFarcasterClaim.Winner[] memory winners = new IFarcasterClaim.Winner[](73);
        winners[0] = IFarcasterClaim.Winner({fid: 803, amount: 15625 ether});
        winners[1] = IFarcasterClaim.Winner({fid: 1668, amount: 13020.83333333333 ether});
        winners[2] = IFarcasterClaim.Winner({fid: 1725, amount: 18229.166666666664 ether});
        winners[3] = IFarcasterClaim.Winner({fid: 2240, amount: 7812.5 ether});
        winners[4] = IFarcasterClaim.Winner({fid: 3295, amount: 2604.1666666666665 ether});
        winners[5] = IFarcasterClaim.Winner({fid: 3372, amount: 13020.833333333332 ether});
        winners[6] = IFarcasterClaim.Winner({fid: 3827, amount: 15625 ether});
        winners[7] = IFarcasterClaim.Winner({fid: 4567, amount: 5208.333333333333 ether});
        winners[8] = IFarcasterClaim.Winner({fid: 4715, amount: 18229.166666666664 ether});
        winners[9] = IFarcasterClaim.Winner({fid: 5543, amount: 7812.5 ether});
        winners[10] = IFarcasterClaim.Winner({fid: 7729, amount: 5208.333333333333 ether});
        winners[11] = IFarcasterClaim.Winner({fid: 7759, amount: 13020.833333333332 ether});
        winners[12] = IFarcasterClaim.Winner({fid: 8152, amount: 20833.333333333332 ether});
        winners[13] = IFarcasterClaim.Winner({fid: 8481, amount: 2604.1666666666665 ether});
        winners[14] = IFarcasterClaim.Winner({fid: 9318, amount: 2604.1666666666665 ether});
        winners[15] = IFarcasterClaim.Winner({fid: 9967, amount: 5208.333333333333 ether});
        winners[16] = IFarcasterClaim.Winner({fid: 10093, amount: 7812.5 ether});
        winners[17] = IFarcasterClaim.Winner({fid: 11050, amount: 10416.666666666666 ether});
        winners[18] = IFarcasterClaim.Winner({fid: 13432, amount: 7812.5 ether});
        winners[19] = IFarcasterClaim.Winner({fid: 13563, amount: 41666.666666666664 ether});
        winners[20] = IFarcasterClaim.Winner({fid: 13642, amount: 23437.5 ether});
        winners[21] = IFarcasterClaim.Winner({fid: 13986, amount: 7812.5 ether});
        winners[22] = IFarcasterClaim.Winner({fid: 15434, amount: 18229.166666666664 ether});
        winners[23] = IFarcasterClaim.Winner({fid: 15441, amount: 2604.1666666666665 ether});
        winners[24] = IFarcasterClaim.Winner({fid: 17568, amount: 2604.1666666666665 ether});
        winners[25] = IFarcasterClaim.Winner({fid: 18085, amount: 44270.83333333333 ether});
        winners[26] = IFarcasterClaim.Winner({fid: 19530, amount: 5208.333333333333 ether});
        winners[27] = IFarcasterClaim.Winner({fid: 19642, amount: 5208.333333333333 ether});
        winners[28] = IFarcasterClaim.Winner({fid: 20334, amount: 7812.5 ether});
        winners[29] = IFarcasterClaim.Winner({fid: 22420, amount: 5208.333333333333 ether});
        winners[30] = IFarcasterClaim.Winner({fid: 196215, amount: 20833.333333333332 ether});
        winners[31] = IFarcasterClaim.Winner({fid: 209951, amount: 101562.50000000001 ether});
        winners[32] = IFarcasterClaim.Winner({fid: 211654, amount: 2604.1666666666665 ether});
        winners[33] = IFarcasterClaim.Winner({fid: 212156, amount: 13020.833333333332 ether});
        winners[34] = IFarcasterClaim.Winner({fid: 216523, amount: 2604.1666666666665 ether});
        winners[35] = IFarcasterClaim.Winner({fid: 221166, amount: 7812.5 ether});
        winners[36] = IFarcasterClaim.Winner({fid: 228795, amount: 18229.166666666668 ether});
        winners[37] = IFarcasterClaim.Winner({fid: 239413, amount: 2604.1666666666665 ether});
        winners[38] = IFarcasterClaim.Winner({fid: 239933, amount: 26041.666666666668 ether});
        winners[39] = IFarcasterClaim.Winner({fid: 241952, amount: 2604.1666666666665 ether});
        winners[40] = IFarcasterClaim.Winner({fid: 242692, amount: 5208.333333333333 ether});
        winners[41] = IFarcasterClaim.Winner({fid: 243300, amount: 46875 ether});
        winners[42] = IFarcasterClaim.Winner({fid: 244881, amount: 2604.1666666666665 ether});
        winners[43] = IFarcasterClaim.Winner({fid: 245579, amount: 10416.666666666666 ether});
        winners[44] = IFarcasterClaim.Winner({fid: 245681, amount: 2604.1666666666665 ether});
        winners[45] = IFarcasterClaim.Winner({fid: 247605, amount: 5208.333333333333 ether});
        winners[46] = IFarcasterClaim.Winner({fid: 247946, amount: 5208.333333333333 ether});
        winners[47] = IFarcasterClaim.Winner({fid: 248216, amount: 70312.5 ether});
        winners[48] = IFarcasterClaim.Winner({fid: 253127, amount: 5208.333333333333 ether});
        winners[49] = IFarcasterClaim.Winner({fid: 254141, amount: 2604.1666666666665 ether});
        winners[50] = IFarcasterClaim.Winner({fid: 256829, amount: 67708.33333333333 ether});
        winners[51] = IFarcasterClaim.Winner({fid: 262159, amount: 5208.333333333333 ether});
        winners[52] = IFarcasterClaim.Winner({fid: 263498, amount: 5208.333333333333 ether});
        winners[53] = IFarcasterClaim.Winner({fid: 270583, amount: 13020.833333333332 ether});
        winners[54] = IFarcasterClaim.Winner({fid: 277480, amount: 5208.333333333333 ether});
        winners[55] = IFarcasterClaim.Winner({fid: 290734, amount: 5208.333333333333 ether});
        winners[56] = IFarcasterClaim.Winner({fid: 296520, amount: 5208.333333333333 ether});
        winners[57] = IFarcasterClaim.Winner({fid: 297066, amount: 5208.333333333333 ether});
        winners[58] = IFarcasterClaim.Winner({fid: 303166, amount: 2604.1666666666665 ether});
        winners[59] = IFarcasterClaim.Winner({fid: 304864, amount: 7812.5 ether});
        winners[60] = IFarcasterClaim.Winner({fid: 306670, amount: 5208.333333333333 ether});
        winners[61] = IFarcasterClaim.Winner({fid: 309710, amount: 20833.333333333332 ether});
        winners[62] = IFarcasterClaim.Winner({fid: 311254, amount: 5208.333333333333 ether});
        winners[63] = IFarcasterClaim.Winner({fid: 315944, amount: 2604.1666666666 ether});
        winners[64] = IFarcasterClaim.Winner({fid: 323251, amount: 70312.5 ether});
        winners[65] = IFarcasterClaim.Winner({fid: 343580, amount: 36458.33333333333 ether});
        winners[66] = IFarcasterClaim.Winner({fid: 367335, amount: 2604.166666666666 ether});
        winners[67] = IFarcasterClaim.Winner({fid: 375255, amount: 2604.166666666666 ether});
        winners[68] = IFarcasterClaim.Winner({fid: 376177, amount: 5208.333333333333 ether});
        winners[69] = IFarcasterClaim.Winner({fid: 385537, amount: 5208.333333333333 ether});
        winners[70] = IFarcasterClaim.Winner({fid: 390276, amount: 2604.166666666666 ether});
        winners[71] = IFarcasterClaim.Winner({fid: 393303, amount: 5208.333333333333 ether});
        winners[72] = IFarcasterClaim.Winner({fid: 399039, amount: 2604.166666666 ether});

        fc.setWinnersForRound(ROUND_ID, winners);

        vm.stopBroadcast();
    }
}

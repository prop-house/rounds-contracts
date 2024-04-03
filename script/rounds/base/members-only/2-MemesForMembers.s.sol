// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Script} from 'forge-std/Script.sol';
import {FarcasterClaim} from 'src/FarcasterClaim.sol';
import {AssetController} from 'src/AssetController.sol';
import {IFarcasterClaim} from 'src/interfaces/IFarcasterClaim.sol';

contract MemesForMembers2 is Script {
    function run() public {
        uint256 ownerKey = vm.envUint('OWNER_PRIVATE_KEY');
        vm.startBroadcast(ownerKey);

        uint40 ROUND_ID = 15;

        FarcasterClaim fc = FarcasterClaim(payable(vm.envAddress('FARCASTER_CLAIM_ADDRESS')));

        // ETH is offered in the round.
        fc.setAssetForRound(
            ROUND_ID,
            AssetController.Asset(
                AssetController.AssetType.ERC20, address(0x7d89E05c0B93B24B5Cb23A073E60D008FEd1aCF9), 0
            )
        );

        IFarcasterClaim.Winner[] memory winners = new IFarcasterClaim.Winner[](40);
        winners[0] = IFarcasterClaim.Winner({fid: 3827, amount: 41666.666666666664 ether});
        winners[1] = IFarcasterClaim.Winner({fid: 5181, amount: 5952.380952380952 ether});
        winners[2] = IFarcasterClaim.Winner({fid: 7115, amount: 83333.33333333331 ether});
        winners[3] = IFarcasterClaim.Winner({fid: 7620, amount: 23809.52380952381 ether});
        winners[4] = IFarcasterClaim.Winner({fid: 8942, amount: 47619.04761904762 ether});
        winners[5] = IFarcasterClaim.Winner({fid: 9531, amount: 11904.761904761905 ether});
        winners[6] = IFarcasterClaim.Winner({fid: 15434, amount: 5952.380952380952 ether});
        winners[7] = IFarcasterClaim.Winner({fid: 17356, amount: 11904.761904761905 ether});
        winners[8] = IFarcasterClaim.Winner({fid: 17568, amount: 17857.142857142855 ether});
        winners[9] = IFarcasterClaim.Winner({fid: 18085, amount: 23809.52380952381 ether});
        winners[10] = IFarcasterClaim.Winner({fid: 19642, amount: 35714.28571428571 ether});
        winners[11] = IFarcasterClaim.Winner({fid: 20133, amount: 5952.380952380952 ether});
        winners[12] = IFarcasterClaim.Winner({fid: 205754, amount: 17857.142857142855 ether});
        winners[13] = IFarcasterClaim.Winner({fid: 209951, amount: 41666.66666666667 ether});
        winners[14] = IFarcasterClaim.Winner({fid: 217617, amount: 5952.380952380952 ether});
        winners[15] = IFarcasterClaim.Winner({fid: 226939, amount: 23809.52380952381 ether});
        winners[16] = IFarcasterClaim.Winner({fid: 228795, amount: 136904.7619047619 ether});
        winners[17] = IFarcasterClaim.Winner({fid: 239933, amount: 17857.142857142855 ether});
        winners[18] = IFarcasterClaim.Winner({fid: 242692, amount: 11904.761904761905 ether});
        winners[19] = IFarcasterClaim.Winner({fid: 245579, amount: 23809.52380952381 ether});
        winners[20] = IFarcasterClaim.Winner({fid: 253727, amount: 23809.52380952381 ether});
        winners[21] = IFarcasterClaim.Winner({fid: 253923, amount: 5952.380952380952 ether});
        winners[22] = IFarcasterClaim.Winner({fid: 263648, amount: 23809.52380952381 ether});
        winners[23] = IFarcasterClaim.Winner({fid: 265951, amount: 17857.142857142855 ether});
        winners[24] = IFarcasterClaim.Winner({fid: 268669, amount: 11904.761904761905 ether});
        winners[25] = IFarcasterClaim.Winner({fid: 280475, amount: 29761.904761904763 ether});
        winners[26] = IFarcasterClaim.Winner({fid: 293192, amount: 11904.761904761905 ether});
        winners[27] = IFarcasterClaim.Winner({fid: 296520, amount: 11904.761904761905 ether});
        winners[28] = IFarcasterClaim.Winner({fid: 299674, amount: 5952.380952380952 ether});
        winners[29] = IFarcasterClaim.Winner({fid: 309710, amount: 35714.28571428571 ether});
        winners[30] = IFarcasterClaim.Winner({fid: 309901, amount: 17857.142857142855 ether});
        winners[31] = IFarcasterClaim.Winner({fid: 330009, amount: 5952.380952380952 ether});
        winners[32] = IFarcasterClaim.Winner({fid: 330947, amount: 5952.380952380952 ether});
        winners[33] = IFarcasterClaim.Winner({fid: 355271, amount: 35714.28571428571 ether});
        winners[34] = IFarcasterClaim.Winner({fid: 369196, amount: 5952.380952380952 ether});
        winners[35] = IFarcasterClaim.Winner({fid: 381469, amount: 11904.761904761905 ether});
        winners[36] = IFarcasterClaim.Winner({fid: 395052, amount: 5952.380952380952 ether});
        winners[37] = IFarcasterClaim.Winner({fid: 397381, amount: 29761.904761904763 ether});
        winners[38] = IFarcasterClaim.Winner({fid: 402802, amount: 65476.19047619047 ether});
        winners[39] = IFarcasterClaim.Winner({fid: 406832, amount: 41666.666666666664 ether});

        fc.setWinnersForRound(ROUND_ID, winners);

        vm.stopBroadcast();
    }
}

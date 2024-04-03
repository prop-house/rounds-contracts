// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Script} from 'forge-std/Script.sol';
import {FarcasterClaim} from 'src/FarcasterClaim.sol';
import {AssetController} from 'src/AssetController.sol';
import {IFarcasterClaim} from 'src/interfaces/IFarcasterClaim.sol';

contract RetroRound2 is Script {
    function run() public {
        uint256 ownerKey = vm.envUint('OWNER_PRIVATE_KEY');
        vm.startBroadcast(ownerKey);

        uint40 ROUND_ID = 2;

        FarcasterClaim fc = FarcasterClaim(payable(vm.envAddress('FARCASTER_CLAIM_ADDRESS')));

        // ETH is offered in the round.
        fc.setAssetForRound(ROUND_ID, AssetController.Asset(AssetController.AssetType.ETH, address(0), 0));

        IFarcasterClaim.Winner[] memory winners = new IFarcasterClaim.Winner[](38);
        winners[0] = IFarcasterClaim.Winner({fid: 803, amount: 0.219718 ether});
        winners[1] = IFarcasterClaim.Winner({fid: 1886, amount: 0.177465 ether});
        winners[2] = IFarcasterClaim.Winner({fid: 2235, amount: 0.152113 ether});
        winners[3] = IFarcasterClaim.Winner({fid: 2433, amount: 0.160563 ether});
        winners[4] = IFarcasterClaim.Winner({fid: 3095, amount: 0.059155 ether});
        winners[5] = IFarcasterClaim.Winner({fid: 3642, amount: 0.152113 ether});
        winners[6] = IFarcasterClaim.Winner({fid: 3827, amount: 0.042254 ether});
        winners[7] = IFarcasterClaim.Winner({fid: 4487, amount: 0.202817 ether});
        winners[8] = IFarcasterClaim.Winner({fid: 4567, amount: 0.076056 ether});
        winners[9] = IFarcasterClaim.Winner({fid: 5450, amount: 0.084507 ether});
        winners[10] = IFarcasterClaim.Winner({fid: 5701, amount: 0.092958 ether});
        winners[11] = IFarcasterClaim.Winner({fid: 6164, amount: 0.008451 ether});
        winners[12] = IFarcasterClaim.Winner({fid: 6852, amount: 0.033803 ether});
        winners[13] = IFarcasterClaim.Winner({fid: 7418, amount: 0.143662 ether});
        winners[14] = IFarcasterClaim.Winner({fid: 7759, amount: 0.160563 ether});
        winners[15] = IFarcasterClaim.Winner({fid: 9135, amount: 0.228169 ether});
        winners[16] = IFarcasterClaim.Winner({fid: 9391, amount: 0.025352 ether});
        winners[17] = IFarcasterClaim.Winner({fid: 11500, amount: 0.050704 ether});
        winners[18] = IFarcasterClaim.Winner({fid: 12111, amount: 0.008451 ether});
        winners[19] = IFarcasterClaim.Winner({fid: 12590, amount: 0.101408 ether});
        winners[20] = IFarcasterClaim.Winner({fid: 13006, amount: 0.042253 ether});
        winners[21] = IFarcasterClaim.Winner({fid: 15434, amount: 0.11831 ether});
        winners[22] = IFarcasterClaim.Winner({fid: 18570, amount: 0.042254 ether});
        winners[23] = IFarcasterClaim.Winner({fid: 20147, amount: 0.059155 ether});
        winners[24] = IFarcasterClaim.Winner({fid: 210444, amount: 0.008451 ether});
        winners[25] = IFarcasterClaim.Winner({fid: 214447, amount: 0.067606 ether});
        winners[26] = IFarcasterClaim.Winner({fid: 214753, amount: 0.016901 ether});
        winners[27] = IFarcasterClaim.Winner({fid: 216523, amount: 0.126759 ether});
        winners[28] = IFarcasterClaim.Winner({fid: 217261, amount: 0.008451 ether});
        winners[29] = IFarcasterClaim.Winner({fid: 224636, amount: 0.050704 ether});
        winners[30] = IFarcasterClaim.Winner({fid: 243300, amount: 0.076056 ether});
        winners[31] = IFarcasterClaim.Winner({fid: 245681, amount: 0.042254 ether});
        winners[32] = IFarcasterClaim.Winner({fid: 246448, amount: 0.008451 ether});
        winners[33] = IFarcasterClaim.Winner({fid: 260114, amount: 0.033803 ether});
        winners[34] = IFarcasterClaim.Winner({fid: 263498, amount: 0.033803 ether});
        winners[35] = IFarcasterClaim.Winner({fid: 283030, amount: 0.016901 ether});
        winners[36] = IFarcasterClaim.Winner({fid: 308666, amount: 0.050704 ether});
        winners[37] = IFarcasterClaim.Winner({fid: 367876, amount: 0.016901 ether});

        fc.setWinnersForRound(ROUND_ID, winners);

        vm.stopBroadcast();
    }
}

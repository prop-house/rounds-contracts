// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Script} from 'forge-std/Script.sol';
import {FarcasterClaim} from 'src/FarcasterClaim.sol';
import {AssetController} from 'src/AssetController.sol';
import {IFarcasterClaim} from 'src/interfaces/IFarcasterClaim.sol';

contract RetroRound3 is Script {
    function run() public {
        uint256 ownerKey = vm.envUint('OWNER_PRIVATE_KEY');
        vm.startBroadcast(ownerKey);

        uint40 ROUND_ID = 3;

        FarcasterClaim fc = FarcasterClaim(payable(vm.envAddress('FARCASTER_CLAIM_ADDRESS')));

        // ETH is offered in the round.
        fc.setAssetForRound(ROUND_ID, AssetController.Asset(AssetController.AssetType.ETH, address(0), 0));

        IFarcasterClaim.Winner[] memory winners = new IFarcasterClaim.Winner[](24);
        winners[0] = IFarcasterClaim.Winner({fid: 602, amount: 0.3103448276 ether});
        winners[1] = IFarcasterClaim.Winner({fid: 1214, amount: 0.175862069 ether});
        winners[2] = IFarcasterClaim.Winner({fid: 1301, amount: 0.1551724138 ether});
        winners[3] = IFarcasterClaim.Winner({fid: 2420, amount: 0.06206896552 ether});
        winners[4] = IFarcasterClaim.Winner({fid: 3642, amount: 0.25862068969 ether});
        winners[5] = IFarcasterClaim.Winner({fid: 4134, amount: 0.01034482759 ether});
        winners[6] = IFarcasterClaim.Winner({fid: 4282, amount: 0.1965517241 ether});
        winners[7] = IFarcasterClaim.Winner({fid: 4895, amount: 0.1137931034 ether});
        winners[8] = IFarcasterClaim.Winner({fid: 7759, amount: 0.3206896552 ether});
        winners[9] = IFarcasterClaim.Winner({fid: 11500, amount: 0.04137931034 ether});
        winners[10] = IFarcasterClaim.Winner({fid: 11998, amount: 0.06206896552 ether});
        winners[11] = IFarcasterClaim.Winner({fid: 14519, amount: 0.01034482759 ether});
        winners[12] = IFarcasterClaim.Winner({fid: 15434, amount: 0.0724137931 ether});
        winners[13] = IFarcasterClaim.Winner({fid: 18655, amount: 0.0724137931 ether});
        winners[14] = IFarcasterClaim.Winner({fid: 20081, amount: 0.02068965517 ether});
        winners[15] = IFarcasterClaim.Winner({fid: 20104, amount: 0.1655172414 ether});
        winners[16] = IFarcasterClaim.Winner({fid: 21191, amount: 0.02068965518 ether});
        winners[17] = IFarcasterClaim.Winner({fid: 23036, amount: 0.03103448276 ether});
        winners[18] = IFarcasterClaim.Winner({fid: 224636, amount: 0.05172413793 ether});
        winners[19] = IFarcasterClaim.Winner({fid: 234512, amount: 0.03103448276 ether});
        winners[20] = IFarcasterClaim.Winner({fid: 243300, amount: 0.5275862069 ether});
        winners[21] = IFarcasterClaim.Winner({fid: 251279, amount: 0.19655172414 ether});
        winners[22] = IFarcasterClaim.Winner({fid: 297024, amount: 0.0724137931 ether});
        winners[23] = IFarcasterClaim.Winner({fid: 374408, amount: 0.0206896551 ether});

        fc.setWinnersForRound(ROUND_ID, winners);

        vm.stopBroadcast();
    }
}

// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Script} from 'forge-std/Script.sol';
import {AssetController} from 'src/AssetController.sol';
import {FarcasterClaimV1} from 'src/legacy/FarcasterClaimV1.sol';
import {IFarcasterClaimV1} from 'src/legacy/interfaces/IFarcasterClaimV1.sol';

contract RetroRound3 is Script {
    function run() public {
        uint256 ownerKey = vm.envUint('OWNER_PRIVATE_KEY');
        vm.startBroadcast(ownerKey);

        uint40 ROUND_ID = 3;

        FarcasterClaimV1 fc = FarcasterClaimV1(payable(vm.envAddress('FARCASTER_CLAIM_ADDRESS')));

        // ETH is offered in the round.
        fc.setAssetForRound(ROUND_ID, AssetController.Asset(AssetController.AssetType.ETH, address(0), 0));

        IFarcasterClaimV1.Winner[] memory winners = new IFarcasterClaimV1.Winner[](24);
        winners[0] = IFarcasterClaimV1.Winner({fid: 602, amount: 0.3103448276 ether});
        winners[1] = IFarcasterClaimV1.Winner({fid: 1214, amount: 0.175862069 ether});
        winners[2] = IFarcasterClaimV1.Winner({fid: 1301, amount: 0.1551724138 ether});
        winners[3] = IFarcasterClaimV1.Winner({fid: 2420, amount: 0.06206896552 ether});
        winners[4] = IFarcasterClaimV1.Winner({fid: 3642, amount: 0.25862068969 ether});
        winners[5] = IFarcasterClaimV1.Winner({fid: 4134, amount: 0.01034482759 ether});
        winners[6] = IFarcasterClaimV1.Winner({fid: 4282, amount: 0.1965517241 ether});
        winners[7] = IFarcasterClaimV1.Winner({fid: 4895, amount: 0.1137931034 ether});
        winners[8] = IFarcasterClaimV1.Winner({fid: 7759, amount: 0.3206896552 ether});
        winners[9] = IFarcasterClaimV1.Winner({fid: 11500, amount: 0.04137931034 ether});
        winners[10] = IFarcasterClaimV1.Winner({fid: 11998, amount: 0.06206896552 ether});
        winners[11] = IFarcasterClaimV1.Winner({fid: 14519, amount: 0.01034482759 ether});
        winners[12] = IFarcasterClaimV1.Winner({fid: 15434, amount: 0.0724137931 ether});
        winners[13] = IFarcasterClaimV1.Winner({fid: 18655, amount: 0.0724137931 ether});
        winners[14] = IFarcasterClaimV1.Winner({fid: 20081, amount: 0.02068965517 ether});
        winners[15] = IFarcasterClaimV1.Winner({fid: 20104, amount: 0.1655172414 ether});
        winners[16] = IFarcasterClaimV1.Winner({fid: 21191, amount: 0.02068965518 ether});
        winners[17] = IFarcasterClaimV1.Winner({fid: 23036, amount: 0.03103448276 ether});
        winners[18] = IFarcasterClaimV1.Winner({fid: 224636, amount: 0.05172413793 ether});
        winners[19] = IFarcasterClaimV1.Winner({fid: 234512, amount: 0.03103448276 ether});
        winners[20] = IFarcasterClaimV1.Winner({fid: 243300, amount: 0.5275862069 ether});
        winners[21] = IFarcasterClaimV1.Winner({fid: 251279, amount: 0.19655172414 ether});
        winners[22] = IFarcasterClaimV1.Winner({fid: 297024, amount: 0.0724137931 ether});
        winners[23] = IFarcasterClaimV1.Winner({fid: 374408, amount: 0.0206896551 ether});

        fc.setWinnersForRound(ROUND_ID, winners);

        vm.stopBroadcast();
    }
}

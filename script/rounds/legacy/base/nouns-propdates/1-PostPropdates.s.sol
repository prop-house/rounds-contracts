// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Script} from 'forge-std/Script.sol';
import {AssetController} from 'src/AssetController.sol';
import {FarcasterClaimV1} from 'src/legacy/FarcasterClaimV1.sol';
import {IFarcasterClaimV1} from 'src/legacy/interfaces/IFarcasterClaimV1.sol';

contract PostPropdates1 is Script {
    function run() public {
        uint256 ownerKey = vm.envUint('OWNER_PRIVATE_KEY');
        vm.startBroadcast(ownerKey);

        uint40 ROUND_ID = 33;

        FarcasterClaimV1 fc = FarcasterClaimV1(payable(vm.envAddress('FARCASTER_CLAIM_ADDRESS')));

        // ETH is offered in the round.
        fc.setAssetForRound(ROUND_ID, AssetController.Asset(AssetController.AssetType.ETH, address(0), 0));

        IFarcasterClaimV1.Winner[] memory winners = new IFarcasterClaimV1.Winner[](18);
        winners[0] = IFarcasterClaimV1.Winner({fid: 803, amount: 0.02564102564102564 ether});
        winners[1] = IFarcasterClaimV1.Winner({fid: 1301, amount: 0.03076923076923077 ether});
        winners[2] = IFarcasterClaimV1.Winner({fid: 3827, amount: 0.020512820512820513 ether});
        winners[3] = IFarcasterClaimV1.Winner({fid: 7759, amount: 0.03076923076923077 ether});
        winners[4] = IFarcasterClaimV1.Winner({fid: 9280, amount: 0.015384615384615385 ether});
        winners[5] = IFarcasterClaimV1.Winner({fid: 9290, amount: 0.041025641025641026 ether});
        winners[6] = IFarcasterClaimV1.Winner({fid: 10685, amount: 0.010256410256410256 ether});
        winners[7] = IFarcasterClaimV1.Winner({fid: 11998, amount: 0.010256410256410256 ether});
        winners[8] = IFarcasterClaimV1.Winner({fid: 14782, amount: 0.010256410256410256 ether});
        winners[9] = IFarcasterClaimV1.Winner({fid: 15899, amount: 0.015384615384615385 ether});
        winners[10] = IFarcasterClaimV1.Winner({fid: 20104, amount: 0.041025641025641026 ether});
        winners[11] = IFarcasterClaimV1.Winner({fid: 20133, amount: 0.02564102564102564 ether});
        winners[12] = IFarcasterClaimV1.Winner({fid: 20228, amount: 0.03076923076923077 ether});
        winners[13] = IFarcasterClaimV1.Winner({fid: 188986, amount: 0.015384615384615385 ether});
        winners[14] = IFarcasterClaimV1.Winner({fid: 318473, amount: 0.010256410256410256 ether});
        winners[15] = IFarcasterClaimV1.Winner({fid: 382205, amount: 0.020512820512820513 ether});
        winners[16] = IFarcasterClaimV1.Winner({fid: 384868, amount: 0.010256410256410256 ether});
        winners[17] = IFarcasterClaimV1.Winner({fid: 388453, amount: 0.035897435897435895 ether});

        fc.setWinnersForRound(ROUND_ID, winners);

        vm.stopBroadcast();
    }
}

// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Script} from 'forge-std/Script.sol';
import {AssetController} from 'src/AssetController.sol';
import {FarcasterClaimV1} from 'src/legacy/FarcasterClaimV1.sol';
import {IFarcasterClaimV1} from 'src/legacy/interfaces/IFarcasterClaimV1.sol';

contract PostPropdates2 is Script {
    function run() public {
        uint256 ownerKey = vm.envUint('OWNER_PRIVATE_KEY');
        vm.startBroadcast(ownerKey);

        uint40 ROUND_ID = 42;

        FarcasterClaimV1 fc = FarcasterClaimV1(payable(vm.envAddress('FARCASTER_CLAIM_ADDRESS')));

        // ETH is offered in the round.
        fc.setAssetForRound(ROUND_ID, AssetController.Asset(AssetController.AssetType.ETH, address(0), 0));

        IFarcasterClaimV1.Winner[] memory winners = new IFarcasterClaimV1.Winner[](10);
        winners[0] = IFarcasterClaimV1.Winner({fid: 834, amount: 0.045454545454545456 ether});
        winners[1] = IFarcasterClaimV1.Winner({fid: 4795, amount: 0.030303030303030304 ether});
        winners[2] = IFarcasterClaimV1.Winner({fid: 7759, amount: 0.07575757575757576 ether});
        winners[3] = IFarcasterClaimV1.Winner({fid: 12590, amount: 0.007575757575757576 ether});
        winners[4] = IFarcasterClaimV1.Winner({fid: 15434, amount: 0.015151515151515152 ether});
        winners[5] = IFarcasterClaimV1.Winner({fid: 191593, amount: 0.06060606060606061 ether});
        winners[6] = IFarcasterClaimV1.Winner({fid: 277501, amount: 0.007575757575757576 ether});
        winners[7] = IFarcasterClaimV1.Winner({fid: 382205, amount: 0.1893939393939394 ether});
        winners[8] = IFarcasterClaimV1.Winner({fid: 388453, amount: 0.03787878787878788 ether});
        winners[9] = IFarcasterClaimV1.Winner({fid: 441949, amount: 0.030303030303030304 ether});

        fc.setWinnersForRound(ROUND_ID, winners);

        vm.stopBroadcast();
    }
}

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

        IFarcasterClaim.Winner[] memory winners = new IFarcasterClaim.Winner[](17);
        winners[0] = IFarcasterClaim.Winner({fid: 602, amount: 0.4591836735 ether});
        winners[1] = IFarcasterClaim.Winner({fid: 1301, amount: 0.137755102 ether});
        winners[2] = IFarcasterClaim.Winner({fid: 2420, amount: 0.09183673469 ether});
        winners[3] = IFarcasterClaim.Winner({fid: 3642, amount: 0.3826530612 ether});
        winners[4] = IFarcasterClaim.Winner({fid: 4134, amount: 0.01530612245 ether});
        winners[5] = IFarcasterClaim.Winner({fid: 4282, amount: 0.2908163265 ether});
        winners[6] = IFarcasterClaim.Winner({fid: 11998, amount: 0.09183673469 ether});
        winners[7] = IFarcasterClaim.Winner({fid: 14519, amount: 0.01530612245 ether});
        winners[8] = IFarcasterClaim.Winner({fid: 15434, amount: 0.1071428571 ether});
        winners[9] = IFarcasterClaim.Winner({fid: 20104, amount: 0.2448979592 ether});
        winners[10] = IFarcasterClaim.Winner({fid: 21191, amount: 0.0306122449 ether});
        winners[11] = IFarcasterClaim.Winner({fid: 23036, amount: 0.04591836735 ether});
        winners[12] = IFarcasterClaim.Winner({fid: 224636, amount: 0.07653061224 ether});
        winners[13] = IFarcasterClaim.Winner({fid: 234512, amount: 0.04591836735 ether});
        winners[14] = IFarcasterClaim.Winner({fid: 243300, amount: 0.7806122449 ether});
        winners[15] = IFarcasterClaim.Winner({fid: 251279, amount: 0.15306122445 ether});
        winners[16] = IFarcasterClaim.Winner({fid: 374408, amount: 0.0306122449 ether});

        fc.setWinnersForRound(ROUND_ID, winners);

        vm.stopBroadcast();
    }
}

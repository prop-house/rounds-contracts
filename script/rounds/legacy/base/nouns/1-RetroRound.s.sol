// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Script} from 'forge-std/Script.sol';
import {AssetController} from 'src/AssetController.sol';
import {FarcasterClaimV1} from 'src/legacy/FarcasterClaimV1.sol';
import {IFarcasterClaimV1} from 'src/legacy/interfaces/IFarcasterClaimV1.sol';

contract RetroRound1 is Script {
    function run() public {
        uint256 ownerKey = vm.envUint('OWNER_PRIVATE_KEY');
        vm.startBroadcast(ownerKey);

        uint40 ROUND_ID = 1;

        FarcasterClaimV1 fc = FarcasterClaimV1(payable(vm.envAddress('FARCASTER_CLAIM_ADDRESS')));

        // ETH is offered in the round.
        fc.setAssetForRound(ROUND_ID, AssetController.Asset(AssetController.AssetType.ETH, address(0), 0));

        IFarcasterClaimV1.Winner[] memory winners = new IFarcasterClaimV1.Winner[](28);
        winners[0] = IFarcasterClaimV1.Winner({fid: 803, amount: 0.055842 ether});
        winners[1] = IFarcasterClaimV1.Winner({fid: 1097, amount: 0.365122 ether});
        winners[2] = IFarcasterClaimV1.Winner({fid: 1301, amount: 0.012887 ether});
        winners[3] = IFarcasterClaimV1.Winner({fid: 1374, amount: 0.004296 ether});
        winners[4] = IFarcasterClaimV1.Winner({fid: 1397, amount: 0.051546 ether});
        winners[5] = IFarcasterClaimV1.Winner({fid: 1556, amount: 0.429553 ether});
        winners[6] = IFarcasterClaimV1.Winner({fid: 2420, amount: 0.313574 ether});
        winners[7] = IFarcasterClaimV1.Winner({fid: 2433, amount: 0.442439 ether});
        winners[8] = IFarcasterClaimV1.Winner({fid: 3642, amount: 0.811856 ether});
        winners[9] = IFarcasterClaimV1.Winner({fid: 3734, amount: 0.219072 ether});
        winners[10] = IFarcasterClaimV1.Winner({fid: 3974, amount: 0.03866 ether});
        winners[11] = IFarcasterClaimV1.Winner({fid: 4167, amount: 0.042956 ether});
        winners[12] = IFarcasterClaimV1.Winner({fid: 4487, amount: 0.030069 ether});
        winners[13] = IFarcasterClaimV1.Winner({fid: 4567, amount: 0.090206 ether});
        winners[14] = IFarcasterClaimV1.Winner({fid: 7759, amount: 0.438144 ether});
        winners[15] = IFarcasterClaimV1.Winner({fid: 11512, amount: 0.12457 ether});
        winners[16] = IFarcasterClaimV1.Winner({fid: 11998, amount: 0.012887 ether});
        winners[17] = IFarcasterClaimV1.Winner({fid: 13006, amount: 0.042955 ether});
        winners[18] = IFarcasterClaimV1.Winner({fid: 15434, amount: 0.296392 ether});
        winners[19] = IFarcasterClaimV1.Winner({fid: 15899, amount: 0.073024 ether});
        winners[20] = IFarcasterClaimV1.Winner({fid: 19530, amount: 0.004296 ether});
        winners[21] = IFarcasterClaimV1.Winner({fid: 20147, amount: 0.304983 ether});
        winners[22] = IFarcasterClaimV1.Winner({fid: 20538, amount: 0.004296 ether});
        winners[23] = IFarcasterClaimV1.Winner({fid: 196215, amount: 0.008591 ether});
        winners[24] = IFarcasterClaimV1.Winner({fid: 216523, amount: 0.657217 ether});
        winners[25] = IFarcasterClaimV1.Winner({fid: 243300, amount: 0.03866 ether});
        winners[26] = IFarcasterClaimV1.Winner({fid: 253693, amount: 0.042955 ether});
        winners[27] = IFarcasterClaimV1.Winner({fid: 305130, amount: 0.042952 ether});

        fc.setWinnersForRound(ROUND_ID, winners);

        vm.stopBroadcast();
    }
}

// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Script} from 'forge-std/Script.sol';
import {AssetController} from 'src/AssetController.sol';
import {FarcasterClaimV1} from 'src/legacy/FarcasterClaimV1.sol';
import {IFarcasterClaimV1} from 'src/legacy/interfaces/IFarcasterClaimV1.sol';

contract TowardsTheLP2 is Script {
    function run() public {
        uint256 ownerKey = vm.envUint('OWNER_PRIVATE_KEY');
        vm.startBroadcast(ownerKey);

        uint40 ROUND_ID = 34;

        FarcasterClaimV1 fc = FarcasterClaimV1(payable(vm.envAddress('FARCASTER_CLAIM_ADDRESS')));

        // NOGS is offered in the round.
        fc.setAssetForRound(
            ROUND_ID,
            AssetController.Asset(
                AssetController.AssetType.ERC20, address(0x13741C5dF9aB03E7Aa9Fb3Bf1f714551dD5A5F8a), 0
            )
        );

        IFarcasterClaimV1.Winner[] memory winners = new IFarcasterClaimV1.Winner[](30);
        winners[0] = IFarcasterClaimV1.Winner({fid: 3711, amount: 160465.11627906977 ether});
        winners[1] = IFarcasterClaimV1.Winner({fid: 3827, amount: 160465.11627906977 ether});
        winners[2] = IFarcasterClaimV1.Winner({fid: 10810, amount: 320930.23255813954 ether});
        winners[3] = IFarcasterClaimV1.Winner({fid: 13861, amount: 641860.4651162791 ether});
        winners[4] = IFarcasterClaimV1.Winner({fid: 14988, amount: 80232.55813953489 ether});
        winners[5] = IFarcasterClaimV1.Winner({fid: 15434, amount: 80232.55813953489 ether});
        winners[6] = IFarcasterClaimV1.Winner({fid: 17282, amount: 80232.55813953489 ether});
        winners[7] = IFarcasterClaimV1.Winner({fid: 18763, amount: 80232.55813953489 ether});
        winners[8] = IFarcasterClaimV1.Winner({fid: 20081, amount: 160465.11627906977 ether});
        winners[9] = IFarcasterClaimV1.Winner({fid: 20333, amount: 80232.55813953489 ether});
        winners[10] = IFarcasterClaimV1.Winner({fid: 191593, amount: 240697.67441860464 ether});
        winners[11] = IFarcasterClaimV1.Winner({fid: 205130, amount: 80232.55813953489 ether});
        winners[12] = IFarcasterClaimV1.Winner({fid: 228795, amount: 401162.7906976744 ether});
        winners[13] = IFarcasterClaimV1.Winner({fid: 228911, amount: 80232.55813953489 ether});
        winners[14] = IFarcasterClaimV1.Winner({fid: 242785, amount: 1203488.3720930233 ether});
        winners[15] = IFarcasterClaimV1.Winner({fid: 246523, amount: 1123255.8139534884 ether});
        winners[16] = IFarcasterClaimV1.Winner({fid: 263648, amount: 80232.55813953489 ether});
        winners[17] = IFarcasterClaimV1.Winner({fid: 263943, amount: 160465.11627906977 ether});
        winners[18] = IFarcasterClaimV1.Winner({fid: 268266, amount: 80232.55813953489 ether});
        winners[19] = IFarcasterClaimV1.Winner({fid: 306715, amount: 80232.55813953489 ether});
        winners[20] = IFarcasterClaimV1.Winner({fid: 323251, amount: 160465.11627906977 ether});
        winners[21] = IFarcasterClaimV1.Winner({fid: 339396, amount: 80232.55813953489 ether});
        winners[22] = IFarcasterClaimV1.Winner({fid: 368096, amount: 160465.11627906977 ether});
        winners[23] = IFarcasterClaimV1.Winner({fid: 397077, amount: 240697.67441860464 ether});
        winners[24] = IFarcasterClaimV1.Winner({fid: 403406, amount: 80232.55813953489 ether});
        winners[25] = IFarcasterClaimV1.Winner({fid: 406972, amount: 80232.55813953489 ether});
        winners[26] = IFarcasterClaimV1.Winner({fid: 413213, amount: 401162.79069767444 ether});
        winners[27] = IFarcasterClaimV1.Winner({fid: 418671, amount: 80232.55813953489 ether});
        winners[28] = IFarcasterClaimV1.Winner({fid: 433072, amount: 160465.11627906977 ether});
        winners[29] = IFarcasterClaimV1.Winner({fid: 444663, amount: 80232.55813953489 ether});

        fc.setWinnersForRound(ROUND_ID, winners);

        vm.stopBroadcast();
    }
}

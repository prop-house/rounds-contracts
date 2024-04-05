// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Script} from 'forge-std/Script.sol';
import {AssetController} from 'src/AssetController.sol';
import {FarcasterClaimV1} from 'src/legacy/FarcasterClaimV1.sol';
import {IFarcasterClaimV1} from 'src/legacy/interfaces/IFarcasterClaimV1.sol';

contract CollectiveNouns100ArtContest2 is Script {
    function run() public {
        uint256 ownerKey = vm.envUint('OWNER_PRIVATE_KEY');
        vm.startBroadcast(ownerKey);

        uint40 ROUND_ID = 18;

        FarcasterClaimV1 fc = FarcasterClaimV1(payable(vm.envAddress('FARCASTER_CLAIM_ADDRESS')));

        // ETH is offered in the round.
        fc.setAssetForRound(
            ROUND_ID,
            AssetController.Asset(
                AssetController.AssetType.ERC20, address(0x4ed4E862860beD51a9570b96d89aF5E1B0Efefed), 0
            )
        );

        IFarcasterClaimV1.Winner[] memory winners = new IFarcasterClaimV1.Winner[](59);
        winners[0] = IFarcasterClaimV1.Winner({fid: 3642, amount: 10000 ether});
        winners[1] = IFarcasterClaimV1.Winner({fid: 4795, amount: 5000 ether});
        winners[2] = IFarcasterClaimV1.Winner({fid: 6852, amount: 833.3333333333334 ether});
        winners[3] = IFarcasterClaimV1.Winner({fid: 11555, amount: 2500 ether});
        winners[4] = IFarcasterClaimV1.Winner({fid: 15633, amount: 2500 ether});
        winners[5] = IFarcasterClaimV1.Winner({fid: 191770, amount: 3333.3333333333335 ether});
        winners[6] = IFarcasterClaimV1.Winner({fid: 195631, amount: 833.3333333333334 ether});
        winners[7] = IFarcasterClaimV1.Winner({fid: 225736, amount: 10000 ether});
        winners[8] = IFarcasterClaimV1.Winner({fid: 227541, amount: 7500.000000000001 ether});
        winners[9] = IFarcasterClaimV1.Winner({fid: 234616, amount: 3333.3333333333335 ether});
        winners[10] = IFarcasterClaimV1.Winner({fid: 241555, amount: 5000 ether});
        winners[11] = IFarcasterClaimV1.Winner({fid: 246158, amount: 2500 ether});
        winners[12] = IFarcasterClaimV1.Winner({fid: 246523, amount: 833.3333333333334 ether});
        winners[13] = IFarcasterClaimV1.Winner({fid: 248713, amount: 3333.3333333333335 ether});
        winners[14] = IFarcasterClaimV1.Winner({fid: 263648, amount: 3333.3333333333335 ether});
        winners[15] = IFarcasterClaimV1.Winner({fid: 291251, amount: 1666.6666666666667 ether});
        winners[16] = IFarcasterClaimV1.Winner({fid: 297024, amount: 3333.3333333333335 ether});
        winners[17] = IFarcasterClaimV1.Winner({fid: 300986, amount: 833.3333333333334 ether});
        winners[18] = IFarcasterClaimV1.Winner({fid: 309849, amount: 3333.3333333333335 ether});
        winners[19] = IFarcasterClaimV1.Winner({fid: 310382, amount: 5833.333333333334 ether});
        winners[20] = IFarcasterClaimV1.Winner({fid: 311573, amount: 833.3333333333334 ether});
        winners[21] = IFarcasterClaimV1.Winner({fid: 315779, amount: 833.3333333333334 ether});
        winners[22] = IFarcasterClaimV1.Winner({fid: 319564, amount: 833.3333333333334 ether});
        winners[23] = IFarcasterClaimV1.Winner({fid: 323251, amount: 5833.333333333334 ether});
        winners[24] = IFarcasterClaimV1.Winner({fid: 323746, amount: 3333.3333333333335 ether});
        winners[25] = IFarcasterClaimV1.Winner({fid: 326271, amount: 6666.666666666667 ether});
        winners[26] = IFarcasterClaimV1.Winner({fid: 343324, amount: 5833.333333333334 ether});
        winners[27] = IFarcasterClaimV1.Winner({fid: 348154, amount: 1666.6666666666667 ether});
        winners[28] = IFarcasterClaimV1.Winner({fid: 348611, amount: 3333.3333333333335 ether});
        winners[29] = IFarcasterClaimV1.Winner({fid: 361393, amount: 833.3333333333334 ether});
        winners[30] = IFarcasterClaimV1.Winner({fid: 369619, amount: 4166.666666666667 ether});
        winners[31] = IFarcasterClaimV1.Winner({fid: 374867, amount: 7500 ether});
        winners[32] = IFarcasterClaimV1.Winner({fid: 387137, amount: 833.3333333333334 ether});
        winners[33] = IFarcasterClaimV1.Winner({fid: 392157, amount: 3333.3333333333335 ether});
        winners[34] = IFarcasterClaimV1.Winner({fid: 396902, amount: 1666.6666666666667 ether});
        winners[35] = IFarcasterClaimV1.Winner({fid: 397077, amount: 2500 ether});
        winners[36] = IFarcasterClaimV1.Winner({fid: 397099, amount: 3333.3333333333335 ether});
        winners[37] = IFarcasterClaimV1.Winner({fid: 397467, amount: 8333.333333333334 ether});
        winners[38] = IFarcasterClaimV1.Winner({fid: 397777, amount: 4166.666666666667 ether});
        winners[39] = IFarcasterClaimV1.Winner({fid: 397802, amount: 2500 ether});
        winners[40] = IFarcasterClaimV1.Winner({fid: 398364, amount: 15000.000000000002 ether});
        winners[41] = IFarcasterClaimV1.Winner({fid: 398407, amount: 10000 ether});
        winners[42] = IFarcasterClaimV1.Winner({fid: 398799, amount: 5000 ether});
        winners[43] = IFarcasterClaimV1.Winner({fid: 398913, amount: 833.3333333333334 ether});
        winners[44] = IFarcasterClaimV1.Winner({fid: 399310, amount: 833.3333333333334 ether});
        winners[45] = IFarcasterClaimV1.Winner({fid: 401736, amount: 833.3333333333334 ether});
        winners[46] = IFarcasterClaimV1.Winner({fid: 403386, amount: 833.3333333333334 ether});
        winners[47] = IFarcasterClaimV1.Winner({fid: 404304, amount: 1666.6666666666667 ether});
        winners[48] = IFarcasterClaimV1.Winner({fid: 405456, amount: 833.3333333333334 ether});
        winners[49] = IFarcasterClaimV1.Winner({fid: 406832, amount: 833.3333333333334 ether});
        winners[50] = IFarcasterClaimV1.Winner({fid: 407859, amount: 833.3333333333334 ether});
        winners[51] = IFarcasterClaimV1.Winner({fid: 410492, amount: 833.3333333333334 ether});
        winners[52] = IFarcasterClaimV1.Winner({fid: 412098, amount: 833.3333333333334 ether});
        winners[53] = IFarcasterClaimV1.Winner({fid: 413213, amount: 4166.666666666667 ether});
        winners[54] = IFarcasterClaimV1.Winner({fid: 423296, amount: 2500 ether});
        winners[55] = IFarcasterClaimV1.Winner({fid: 433957, amount: 833.3333333333334 ether});
        winners[56] = IFarcasterClaimV1.Winner({fid: 434742, amount: 3333.3333333333 ether});
        winners[57] = IFarcasterClaimV1.Winner({fid: 436785, amount: 5000 ether});
        winners[58] = IFarcasterClaimV1.Winner({fid: 439559, amount: 833.3333333333 ether});

        fc.setWinnersForRound(ROUND_ID, winners);

        vm.stopBroadcast();
    }
}

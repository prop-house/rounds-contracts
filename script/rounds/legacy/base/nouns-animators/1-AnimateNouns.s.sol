// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Script} from 'forge-std/Script.sol';
import {AssetController} from 'src/AssetController.sol';
import {FarcasterClaimV1} from 'src/legacy/FarcasterClaimV1.sol';
import {IFarcasterClaimV1} from 'src/legacy/interfaces/IFarcasterClaimV1.sol';

contract AnimateNouns1 is Script {
    function run() public {
        uint256 ownerKey = vm.envUint('OWNER_PRIVATE_KEY');
        vm.startBroadcast(ownerKey);

        uint40 ROUND_ID = 10;

        FarcasterClaimV1 fc = FarcasterClaimV1(payable(vm.envAddress('FARCASTER_CLAIM_ADDRESS')));

        // ETH is offered in the round.
        fc.setAssetForRound(ROUND_ID, AssetController.Asset(AssetController.AssetType.ETH, address(0), 0));

        IFarcasterClaimV1.Winner[] memory winners = new IFarcasterClaimV1.Winner[](36);
        winners[0] = IFarcasterClaimV1.Winner({fid: 10575, amount: 0.028037383177570093 ether});
        winners[1] = IFarcasterClaimV1.Winner({fid: 15434, amount: 0.018691588785046728 ether});
        winners[2] = IFarcasterClaimV1.Winner({fid: 17525, amount: 0.009345794392523364 ether});
        winners[3] = IFarcasterClaimV1.Winner({fid: 19583, amount: 0.0514018691588785 ether});
        winners[4] = IFarcasterClaimV1.Winner({fid: 20198, amount: 0.0794392523364486 ether});
        winners[5] = IFarcasterClaimV1.Winner({fid: 20228, amount: 0.037383177570093455 ether});
        winners[6] = IFarcasterClaimV1.Winner({fid: 195631, amount: 0.04205607476635514 ether});
        winners[7] = IFarcasterClaimV1.Winner({fid: 224636, amount: 0.009345794392523364 ether});
        winners[8] = IFarcasterClaimV1.Winner({fid: 253402, amount: 0.037383177570093455 ether});
        winners[9] = IFarcasterClaimV1.Winner({fid: 277900, amount: 0.004672897196261682 ether});
        winners[10] = IFarcasterClaimV1.Winner({fid: 299247, amount: 0.02803738317757009 ether});
        winners[11] = IFarcasterClaimV1.Winner({fid: 309849, amount: 0.014018691588785045 ether});
        winners[12] = IFarcasterClaimV1.Winner({fid: 310213, amount: 0.02336448598130841 ether});
        winners[13] = IFarcasterClaimV1.Winner({fid: 310382, amount: 0.06542056074766354 ether});
        winners[14] = IFarcasterClaimV1.Winner({fid: 323251, amount: 0.05607476635514018 ether});
        winners[15] = IFarcasterClaimV1.Winner({fid: 332881, amount: 0.009345794392523364 ether});
        winners[16] = IFarcasterClaimV1.Winner({fid: 333979, amount: 0.014018691588785045 ether});
        winners[17] = IFarcasterClaimV1.Winner({fid: 340184, amount: 0.009345794392523364 ether});
        winners[18] = IFarcasterClaimV1.Winner({fid: 342202, amount: 0.018691588785046728 ether});
        winners[19] = IFarcasterClaimV1.Winner({fid: 349764, amount: 0.014018691588785045 ether});
        winners[20] = IFarcasterClaimV1.Winner({fid: 376944, amount: 0.02336448598130841 ether});
        winners[21] = IFarcasterClaimV1.Winner({fid: 390598, amount: 0.018691588785046728 ether});
        winners[22] = IFarcasterClaimV1.Winner({fid: 392157, amount: 0.02803738317757009 ether});
        winners[23] = IFarcasterClaimV1.Winner({fid: 395720, amount: 0.04205607476635514 ether});
        winners[24] = IFarcasterClaimV1.Winner({fid: 396588, amount: 0.009345794392523364 ether});
        winners[25] = IFarcasterClaimV1.Winner({fid: 396837, amount: 0.04672897196261682 ether});
        winners[26] = IFarcasterClaimV1.Winner({fid: 396844, amount: 0.02336448598130841 ether});
        winners[27] = IFarcasterClaimV1.Winner({fid: 396867, amount: 0.04205607476635514 ether});
        winners[28] = IFarcasterClaimV1.Winner({fid: 396891, amount: 0.018691588785046728 ether});
        winners[29] = IFarcasterClaimV1.Winner({fid: 396902, amount: 0.06074766355140186 ether});
        winners[30] = IFarcasterClaimV1.Winner({fid: 396915, amount: 0.004672897196261682 ether});
        winners[31] = IFarcasterClaimV1.Winner({fid: 400932, amount: 0.04205607476635514 ether});
        winners[32] = IFarcasterClaimV1.Winner({fid: 401023, amount: 0.009345794392523364 ether});
        winners[33] = IFarcasterClaimV1.Winner({fid: 402644, amount: 0.014018691588785045 ether});
        winners[34] = IFarcasterClaimV1.Winner({fid: 403318, amount: 0.014018691588785045 ether});
        winners[35] = IFarcasterClaimV1.Winner({fid: 404641, amount: 0.03271028037383177 ether});

        fc.setWinnersForRound(ROUND_ID, winners);

        vm.stopBroadcast();
    }
}

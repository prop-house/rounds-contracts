// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Script} from 'forge-std/Script.sol';
import {FarcasterClaim} from 'src/FarcasterClaim.sol';
import {AssetController} from 'src/AssetController.sol';
import {IFarcasterClaim} from 'src/interfaces/IFarcasterClaim.sol';

contract AnimateNouns1 is Script {
    function run() public {
        uint256 ownerKey = vm.envUint('OWNER_PRIVATE_KEY');
        vm.startBroadcast(ownerKey);

        uint40 ROUND_ID = 10;

        FarcasterClaim fc = FarcasterClaim(payable(vm.envAddress('FARCASTER_CLAIM_ADDRESS')));

        // ETH is offered in the round.
        fc.setAssetForRound(ROUND_ID, AssetController.Asset(AssetController.AssetType.ETH, address(0), 0));

        IFarcasterClaim.Winner[] memory winners = new IFarcasterClaim.Winner[](36);
        winners[0] = IFarcasterClaim.Winner({fid: 10575, amount: 0.028037383177570093 ether});
        winners[1] = IFarcasterClaim.Winner({fid: 15434, amount: 0.018691588785046728 ether});
        winners[2] = IFarcasterClaim.Winner({fid: 17525, amount: 0.009345794392523364 ether});
        winners[3] = IFarcasterClaim.Winner({fid: 19583, amount: 0.0514018691588785 ether});
        winners[4] = IFarcasterClaim.Winner({fid: 20198, amount: 0.0794392523364486 ether});
        winners[5] = IFarcasterClaim.Winner({fid: 20228, amount: 0.037383177570093455 ether});
        winners[6] = IFarcasterClaim.Winner({fid: 195631, amount: 0.04205607476635514 ether});
        winners[7] = IFarcasterClaim.Winner({fid: 224636, amount: 0.009345794392523364 ether});
        winners[8] = IFarcasterClaim.Winner({fid: 253402, amount: 0.037383177570093455 ether});
        winners[9] = IFarcasterClaim.Winner({fid: 277900, amount: 0.004672897196261682 ether});
        winners[10] = IFarcasterClaim.Winner({fid: 299247, amount: 0.02803738317757009 ether});
        winners[11] = IFarcasterClaim.Winner({fid: 309849, amount: 0.014018691588785045 ether});
        winners[12] = IFarcasterClaim.Winner({fid: 310213, amount: 0.02336448598130841 ether});
        winners[13] = IFarcasterClaim.Winner({fid: 310382, amount: 0.06542056074766354 ether});
        winners[14] = IFarcasterClaim.Winner({fid: 323251, amount: 0.05607476635514018 ether});
        winners[15] = IFarcasterClaim.Winner({fid: 332881, amount: 0.009345794392523364 ether});
        winners[16] = IFarcasterClaim.Winner({fid: 333979, amount: 0.014018691588785045 ether});
        winners[17] = IFarcasterClaim.Winner({fid: 340184, amount: 0.009345794392523364 ether});
        winners[18] = IFarcasterClaim.Winner({fid: 342202, amount: 0.018691588785046728 ether});
        winners[19] = IFarcasterClaim.Winner({fid: 349764, amount: 0.014018691588785045 ether});
        winners[20] = IFarcasterClaim.Winner({fid: 376944, amount: 0.02336448598130841 ether});
        winners[21] = IFarcasterClaim.Winner({fid: 390598, amount: 0.018691588785046728 ether});
        winners[22] = IFarcasterClaim.Winner({fid: 392157, amount: 0.02803738317757009 ether});
        winners[23] = IFarcasterClaim.Winner({fid: 395720, amount: 0.04205607476635514 ether});
        winners[24] = IFarcasterClaim.Winner({fid: 396588, amount: 0.009345794392523364 ether});
        winners[25] = IFarcasterClaim.Winner({fid: 396837, amount: 0.04672897196261682 ether});
        winners[26] = IFarcasterClaim.Winner({fid: 396844, amount: 0.02336448598130841 ether});
        winners[27] = IFarcasterClaim.Winner({fid: 396867, amount: 0.04205607476635514 ether});
        winners[28] = IFarcasterClaim.Winner({fid: 396891, amount: 0.018691588785046728 ether});
        winners[29] = IFarcasterClaim.Winner({fid: 396902, amount: 0.06074766355140186 ether});
        winners[30] = IFarcasterClaim.Winner({fid: 396915, amount: 0.004672897196261682 ether});
        winners[31] = IFarcasterClaim.Winner({fid: 400932, amount: 0.04205607476635514 ether});
        winners[32] = IFarcasterClaim.Winner({fid: 401023, amount: 0.009345794392523364 ether});
        winners[33] = IFarcasterClaim.Winner({fid: 402644, amount: 0.014018691588785045 ether});
        winners[34] = IFarcasterClaim.Winner({fid: 403318, amount: 0.014018691588785045 ether});
        winners[35] = IFarcasterClaim.Winner({fid: 404641, amount: 0.03271028037383177 ether});

        fc.setWinnersForRound(ROUND_ID, winners);

        vm.stopBroadcast();
    }
}

// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Script} from 'forge-std/Script.sol';
import {FarcasterClaim} from 'src/FarcasterClaim.sol';
import {AssetController} from 'src/AssetController.sol';
import {IFarcasterClaim} from 'src/interfaces/IFarcasterClaim.sol';

contract BaseHeadArtContest1 is Script {
    function run() public {
        uint256 ownerKey = vm.envUint('OWNER_PRIVATE_KEY');
        vm.startBroadcast(ownerKey);

        uint40 ROUND_ID = 9;

        FarcasterClaim fc = FarcasterClaim(payable(vm.envAddress('FARCASTER_CLAIM_ADDRESS')));

        // ETH is offered in the round.
        fc.setAssetForRound(
            ROUND_ID,
            AssetController.Asset(
                AssetController.AssetType.ERC20, address(0x4ed4E862860beD51a9570b96d89aF5E1B0Efefed), 0
            )
        );

        IFarcasterClaim.Winner[] memory winners = new IFarcasterClaim.Winner[](49);
        winners[0] = IFarcasterClaim.Winner({fid: 3362, amount: 19867.549668874173 ether});
        winners[1] = IFarcasterClaim.Winner({fid: 3642, amount: 39735.09933774835 ether});
        winners[2] = IFarcasterClaim.Winner({fid: 3924, amount: 3311.2582781456954 ether});
        winners[3] = IFarcasterClaim.Winner({fid: 6946, amount: 6622.516556291391 ether});
        winners[4] = IFarcasterClaim.Winner({fid: 8405, amount: 3311.2582781456954 ether});
        winners[5] = IFarcasterClaim.Winner({fid: 12590, amount: 9933.774834437087 ether});
        winners[6] = IFarcasterClaim.Winner({fid: 13030, amount: 3311.2582781456954 ether});
        winners[7] = IFarcasterClaim.Winner({fid: 19510, amount: 6622.516556291391 ether});
        winners[8] = IFarcasterClaim.Winner({fid: 223862, amount: 23178.807947019868 ether});
        winners[9] = IFarcasterClaim.Winner({fid: 224636, amount: 3311.2582781456954 ether});
        winners[10] = IFarcasterClaim.Winner({fid: 225736, amount: 9933.774834437087 ether});
        winners[11] = IFarcasterClaim.Winner({fid: 227918, amount: 3311.2582781456954 ether});
        winners[12] = IFarcasterClaim.Winner({fid: 228837, amount: 13245.033112582782 ether});
        winners[13] = IFarcasterClaim.Winner({fid: 229232, amount: 3311.2582781456954 ether});
        winners[14] = IFarcasterClaim.Winner({fid: 234616, amount: 3311.2582781456954 ether});
        winners[15] = IFarcasterClaim.Winner({fid: 243300, amount: 36423.84105960265 ether});
        winners[16] = IFarcasterClaim.Winner({fid: 246158, amount: 16556.29139072848 ether});
        winners[17] = IFarcasterClaim.Winner({fid: 268266, amount: 6622.516556291391 ether});
        winners[18] = IFarcasterClaim.Winner({fid: 291117, amount: 3311.2582781456954 ether});
        winners[19] = IFarcasterClaim.Winner({fid: 296148, amount: 3311.2582781456954 ether});
        winners[20] = IFarcasterClaim.Winner({fid: 299219, amount: 6622.516556291391 ether});
        winners[21] = IFarcasterClaim.Winner({fid: 299247, amount: 9933.774834437087 ether});
        winners[22] = IFarcasterClaim.Winner({fid: 299388, amount: 6622.516556291391 ether});
        winners[23] = IFarcasterClaim.Winner({fid: 300986, amount: 13245.033112582782 ether});
        winners[24] = IFarcasterClaim.Winner({fid: 306510, amount: 3311.2582781456954 ether});
        winners[25] = IFarcasterClaim.Winner({fid: 308527, amount: 3311.2582781456954 ether});
        winners[26] = IFarcasterClaim.Winner({fid: 318675, amount: 6622.516556291391 ether});
        winners[27] = IFarcasterClaim.Winner({fid: 322532, amount: 3311.2582781456954 ether});
        winners[28] = IFarcasterClaim.Winner({fid: 323251, amount: 43046.35761589404 ether});
        winners[29] = IFarcasterClaim.Winner({fid: 340184, amount: 6622.516556291391 ether});
        winners[30] = IFarcasterClaim.Winner({fid: 342202, amount: 3311.2582781456954 ether});
        winners[31] = IFarcasterClaim.Winner({fid: 343324, amount: 6622.516556291391 ether});
        winners[32] = IFarcasterClaim.Winner({fid: 348154, amount: 9933.774834437087 ether});
        winners[33] = IFarcasterClaim.Winner({fid: 348611, amount: 13245.033112582782 ether});
        winners[34] = IFarcasterClaim.Winner({fid: 349702, amount: 13245.033112582782 ether});
        winners[35] = IFarcasterClaim.Winner({fid: 351539, amount: 9933.774834437087 ether});
        winners[36] = IFarcasterClaim.Winner({fid: 360601, amount: 3311.2582781456954 ether});
        winners[37] = IFarcasterClaim.Winner({fid: 374083, amount: 9933.774834437087 ether});
        winners[38] = IFarcasterClaim.Winner({fid: 374867, amount: 9933.774834437087 ether});
        winners[39] = IFarcasterClaim.Winner({fid: 392157, amount: 23178.807947019868 ether});
        winners[40] = IFarcasterClaim.Winner({fid: 397077, amount: 9933.774834437087 ether});
        winners[41] = IFarcasterClaim.Winner({fid: 397099, amount: 16556.29139072848 ether});
        winners[42] = IFarcasterClaim.Winner({fid: 397113, amount: 6622.516556291391 ether});
        winners[43] = IFarcasterClaim.Winner({fid: 397467, amount: 3311.2582781456954 ether});
        winners[44] = IFarcasterClaim.Winner({fid: 397802, amount: 6622.516556291391 ether});
        winners[45] = IFarcasterClaim.Winner({fid: 398002, amount: 9933.774834437087 ether});
        winners[46] = IFarcasterClaim.Winner({fid: 398364, amount: 6622.516556291391 ether});
        winners[47] = IFarcasterClaim.Winner({fid: 398407, amount: 9933.774834437087 ether});
        winners[48] = IFarcasterClaim.Winner({fid: 399310, amount: 6622.516556291391 ether});

        fc.setWinnersForRound(ROUND_ID, winners);

        vm.stopBroadcast();
    }
}

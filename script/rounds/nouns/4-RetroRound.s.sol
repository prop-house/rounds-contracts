// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Script} from 'forge-std/Script.sol';
import {FarcasterClaim} from 'src/FarcasterClaim.sol';
import {AssetController} from 'src/AssetController.sol';
import {IFarcasterClaim} from 'src/interfaces/IFarcasterClaim.sol';

contract RetroRound4 is Script {
    function run() public {
        uint256 ownerKey = vm.envUint('OWNER_PRIVATE_KEY');
        vm.startBroadcast(ownerKey);

        uint40 ROUND_ID = 4;

        FarcasterClaim fc = FarcasterClaim(payable(vm.envAddress('FARCASTER_CLAIM_ADDRESS')));

        // ETH is offered in the round.
        fc.setAssetForRound(ROUND_ID, AssetController.Asset(AssetController.AssetType.ETH, address(0), 0));

        IFarcasterClaim.Winner[] memory winners = new IFarcasterClaim.Winner[](45);
        winners[0] = IFarcasterClaim.Winner({fid: 803, amount: 0.05084745762711865 ether});
        winners[1] = IFarcasterClaim.Winner({fid: 1097, amount: 0.2097457627118644 ether});
        winners[2] = IFarcasterClaim.Winner({fid: 1301, amount: 0.0826271186440678 ether});
        winners[3] = IFarcasterClaim.Winner({fid: 1556, amount: 0.09533898305084747 ether});
        winners[4] = IFarcasterClaim.Winner({fid: 2420, amount: 0.012711864406779662 ether});
        winners[5] = IFarcasterClaim.Winner({fid: 3413, amount: 0.012711864406779662 ether});
        winners[6] = IFarcasterClaim.Winner({fid: 3642, amount: 0.3177966101694915 ether});
        winners[7] = IFarcasterClaim.Winner({fid: 3711, amount: 0.038135593220338986 ether});
        winners[8] = IFarcasterClaim.Winner({fid: 3974, amount: 0.09533898305084747 ether});
        winners[9] = IFarcasterClaim.Winner({fid: 4487, amount: 0.0635593220338983 ether});
        winners[10] = IFarcasterClaim.Winner({fid: 4567, amount: 0.057203389830508475 ether});
        winners[11] = IFarcasterClaim.Winner({fid: 4795, amount: 0.15889830508474578 ether});
        winners[12] = IFarcasterClaim.Winner({fid: 5515, amount: 0.03177966101694915 ether});
        winners[13] = IFarcasterClaim.Winner({fid: 6292, amount: 0.17161016949152544 ether});
        winners[14] = IFarcasterClaim.Winner({fid: 7143, amount: 0.038135593220338986 ether});
        winners[15] = IFarcasterClaim.Winner({fid: 7759, amount: 0.012711864406779662 ether});
        winners[16] = IFarcasterClaim.Winner({fid: 9290, amount: 0.019067796610169493 ether});
        winners[17] = IFarcasterClaim.Winner({fid: 11500, amount: 0.05084745762711865 ether});
        winners[18] = IFarcasterClaim.Winner({fid: 11998, amount: 0.038135593220338986 ether});
        winners[19] = IFarcasterClaim.Winner({fid: 12590, amount: 0.03813559322033898 ether});
        winners[20] = IFarcasterClaim.Winner({fid: 14782, amount: 0.057203389830508475 ether});
        winners[21] = IFarcasterClaim.Winner({fid: 15294, amount: 0.012711864406779662 ether});
        winners[22] = IFarcasterClaim.Winner({fid: 15434, amount: 0.03177966101694915 ether});
        winners[23] = IFarcasterClaim.Winner({fid: 18655, amount: 0.1271186440677966 ether});
        winners[24] = IFarcasterClaim.Winner({fid: 20104, amount: 0.057203389830508475 ether});
        winners[25] = IFarcasterClaim.Winner({fid: 20147, amount: 0.012711864406779662 ether});
        winners[26] = IFarcasterClaim.Winner({fid: 20198, amount: 0.09533898305084747 ether});
        winners[27] = IFarcasterClaim.Winner({fid: 20265, amount: 0.025423728813559324 ether});
        winners[28] = IFarcasterClaim.Winner({fid: 22420, amount: 0.057203389830508475 ether});
        winners[29] = IFarcasterClaim.Winner({fid: 196215, amount: 0.12076271186440679 ether});
        winners[30] = IFarcasterClaim.Winner({fid: 211246, amount: 0.006355932203389831 ether});
        winners[31] = IFarcasterClaim.Winner({fid: 224636, amount: 0.006355932203389831 ether});
        winners[32] = IFarcasterClaim.Winner({fid: 236061, amount: 0.03177966101694915 ether});
        winners[33] = IFarcasterClaim.Winner({fid: 243300, amount: 0.2796610169491526 ether});
        winners[34] = IFarcasterClaim.Winner({fid: 244145, amount: 0.03177966101694915 ether});
        winners[35] = IFarcasterClaim.Winner({fid: 251279, amount: 0.08898305084745764 ether});
        winners[36] = IFarcasterClaim.Winner({fid: 263648, amount: 0.012711864406779662 ether});
        winners[37] = IFarcasterClaim.Winner({fid: 292919, amount: 0.012711864406779662 ether});
        winners[38] = IFarcasterClaim.Winner({fid: 318473, amount: 0.08898305084745764 ether});
        winners[39] = IFarcasterClaim.Winner({fid: 319714, amount: 0.006355932203389831 ether});
        winners[40] = IFarcasterClaim.Winner({fid: 323251, amount: 0.1843220338983051 ether});
        winners[41] = IFarcasterClaim.Winner({fid: 368377, amount: 0.006355932203389831 ether});
        winners[42] = IFarcasterClaim.Winner({fid: 374408, amount: 0.019067796610169493 ether});
        winners[43] = IFarcasterClaim.Winner({fid: 382205, amount: 0.006355932203389831 ether});
        winners[44] = IFarcasterClaim.Winner({fid: 382283, amount: 0.025423728813559324 ether});

        fc.setWinnersForRound(ROUND_ID, winners);

        vm.stopBroadcast();
    }
}

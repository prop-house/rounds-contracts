// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Script} from 'forge-std/Script.sol';
import {AssetController} from 'src/AssetController.sol';
import {FarcasterClaimV1} from 'src/legacy/FarcasterClaimV1.sol';
import {IFarcasterClaimV1} from 'src/legacy/interfaces/IFarcasterClaimV1.sol';

contract AnimateNouns4 is Script {
    function run() public {
        uint256 ownerKey = vm.envUint('OWNER_PRIVATE_KEY');
        vm.startBroadcast(ownerKey);

        uint40 ROUND_ID = 37;

        FarcasterClaimV1 fc = FarcasterClaimV1(payable(vm.envAddress('FARCASTER_CLAIM_ADDRESS')));

        // ETH is offered in the round.
        fc.setAssetForRound(ROUND_ID, AssetController.Asset(AssetController.AssetType.ETH, address(0), 0));

        IFarcasterClaimV1.Winner[] memory winners = new IFarcasterClaimV1.Winner[](35);
        winners[0] = IFarcasterClaimV1.Winner({fid: 4577, amount: 0.0392156862745098 ether});
        winners[1] = IFarcasterClaimV1.Winner({fid: 195631, amount: 0.013071895424836602 ether});
        winners[2] = IFarcasterClaimV1.Winner({fid: 195806, amount: 0.0392156862745098 ether});
        winners[3] = IFarcasterClaimV1.Winner({fid: 197061, amount: 0.10457516339869281 ether});
        winners[4] = IFarcasterClaimV1.Winner({fid: 249586, amount: 0.026143790849673203 ether});
        winners[5] = IFarcasterClaimV1.Winner({fid: 253402, amount: 0.10457516339869281 ether});
        winners[6] = IFarcasterClaimV1.Winner({fid: 299247, amount: 0.0784313725490196 ether});
        winners[7] = IFarcasterClaimV1.Winner({fid: 310213, amount: 0.013071895424836602 ether});
        winners[8] = IFarcasterClaimV1.Winner({fid: 310382, amount: 0.05228758169934641 ether});
        winners[9] = IFarcasterClaimV1.Winner({fid: 313038, amount: 0.05228758169934641 ether});
        winners[10] = IFarcasterClaimV1.Winner({fid: 332881, amount: 0.05228758169934641 ether});
        winners[11] = IFarcasterClaimV1.Winner({fid: 336785, amount: 0.06535947712418301 ether});
        winners[12] = IFarcasterClaimV1.Winner({fid: 342717, amount: 0.013071895424836602 ether});
        winners[13] = IFarcasterClaimV1.Winner({fid: 392157, amount: 0.11764705882352941 ether});
        winners[14] = IFarcasterClaimV1.Winner({fid: 395720, amount: 0.11764705882352941 ether});
        winners[15] = IFarcasterClaimV1.Winner({fid: 396837, amount: 0.0392156862745098 ether});
        winners[16] = IFarcasterClaimV1.Winner({fid: 396844, amount: 0.0392156862745098 ether});
        winners[17] = IFarcasterClaimV1.Winner({fid: 396867, amount: 0.09150326797385622 ether});
        winners[18] = IFarcasterClaimV1.Winner({fid: 396902, amount: 0.16993464052287582 ether});
        winners[19] = IFarcasterClaimV1.Winner({fid: 397077, amount: 0.14379084967320263 ether});
        winners[20] = IFarcasterClaimV1.Winner({fid: 397467, amount: 0.013071895424836602 ether});
        winners[21] = IFarcasterClaimV1.Winner({fid: 399241, amount: 0.06535947712418301 ether});
        winners[22] = IFarcasterClaimV1.Winner({fid: 400932, amount: 0.0392156862745098 ether});
        winners[23] = IFarcasterClaimV1.Winner({fid: 401023, amount: 0.026143790849673203 ether});
        winners[24] = IFarcasterClaimV1.Winner({fid: 403855, amount: 0.05228758169934641 ether});
        winners[25] = IFarcasterClaimV1.Winner({fid: 413213, amount: 0.013071895424836602 ether});
        winners[26] = IFarcasterClaimV1.Winner({fid: 418671, amount: 0.013071895424836602 ether});
        winners[27] = IFarcasterClaimV1.Winner({fid: 433072, amount: 0.013071895424836602 ether});
        winners[28] = IFarcasterClaimV1.Winner({fid: 448870, amount: 0.013071895424836602 ether});
        winners[29] = IFarcasterClaimV1.Winner({fid: 454778, amount: 0.026143790849673203 ether});
        winners[30] = IFarcasterClaimV1.Winner({fid: 455449, amount: 0.10457516339869281 ether});
        winners[31] = IFarcasterClaimV1.Winner({fid: 457752, amount: 0.0784313725490196 ether});
        winners[32] = IFarcasterClaimV1.Winner({fid: 465810, amount: 0.0784313725490196 ether});
        winners[33] = IFarcasterClaimV1.Winner({fid: 466693, amount: 0.0784313725490196 ether});
        winners[34] = IFarcasterClaimV1.Winner({fid: 477956, amount: 0.013071895424836602 ether});

        fc.setWinnersForRound(ROUND_ID, winners);

        vm.stopBroadcast();
    }
}

// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Script} from 'forge-std/Script.sol';
import {FarcasterClaim} from 'src/FarcasterClaim.sol';
import {AssetController} from 'src/AssetController.sol';
import {IFarcasterClaim} from 'src/interfaces/IFarcasterClaim.sol';

contract RetroRound2 is Script {
    function run() public {
        uint256 ownerKey = vm.envUint('OWNER_PRIVATE_KEY');
        vm.startBroadcast(ownerKey);

        IFarcasterClaim.Winner[] memory winners = new IFarcasterClaim.Winner[](62);
        winners[0] = IFarcasterClaim.Winner({
            fid: 602,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.139104 ether)
        });
        winners[1] = IFarcasterClaim.Winner({
            fid: 803,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.120556 ether)
        });
        winners[2] = IFarcasterClaim.Winner({
            fid: 1214,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.078825 ether)
        });
        winners[3] = IFarcasterClaim.Winner({
            fid: 1301,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.041731 ether)
        });
        winners[4] = IFarcasterClaim.Winner({
            fid: 1886,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.097372 ether)
        });
        winners[5] = IFarcasterClaim.Winner({
            fid: 2235,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.083462 ether)
        });
        winners[6] = IFarcasterClaim.Winner({
            fid: 2420,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.023184 ether)
        });
        winners[7] = IFarcasterClaim.Winner({
            fid: 2433,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.088099 ether)
        });
        winners[8] = IFarcasterClaim.Winner({
            fid: 3095,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.032457 ether)
        });
        winners[9] = IFarcasterClaim.Winner({
            fid: 3642,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.190108 ether)
        });
        winners[10] = IFarcasterClaim.Winner({
            fid: 3827,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.023184 ether)
        });
        winners[11] = IFarcasterClaim.Winner({
            fid: 4134,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.004637 ether)
        });
        winners[12] = IFarcasterClaim.Winner({
            fid: 4282,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.088099 ether)
        });
        winners[13] = IFarcasterClaim.Winner({
            fid: 4487,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.111283 ether)
        });
        winners[14] = IFarcasterClaim.Winner({
            fid: 4567,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.041731 ether)
        });
        winners[15] = IFarcasterClaim.Winner({
            fid: 4895,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.051005 ether)
        });
        winners[16] = IFarcasterClaim.Winner({
            fid: 5450,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.046368 ether)
        });
        winners[17] = IFarcasterClaim.Winner({
            fid: 5701,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.051005 ether)
        });
        winners[18] = IFarcasterClaim.Winner({
            fid: 6164,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.004637 ether)
        });
        winners[19] = IFarcasterClaim.Winner({
            fid: 6852,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.018547 ether)
        });
        winners[20] = IFarcasterClaim.Winner({
            fid: 7418,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.078825 ether)
        });
        winners[21] = IFarcasterClaim.Winner({
            fid: 7759,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.204019 ether)
        });
        winners[22] = IFarcasterClaim.Winner({
            fid: 9135,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.125193 ether)
        });
        winners[23] = IFarcasterClaim.Winner({
            fid: 9391,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.01391 ether)
        });
        winners[24] = IFarcasterClaim.Winner({
            fid: 11500,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.046368 ether)
        });
        winners[25] = IFarcasterClaim.Winner({
            fid: 11998,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.027821 ether)
        });
        winners[26] = IFarcasterClaim.Winner({
            fid: 12111,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.004637 ether)
        });
        winners[27] = IFarcasterClaim.Winner({
            fid: 12590,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.055641 ether)
        });
        winners[28] = IFarcasterClaim.Winner({
            fid: 13006,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.023184 ether)
        });
        winners[29] = IFarcasterClaim.Winner({
            fid: 15434,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.092736 ether)
        });
        winners[30] = IFarcasterClaim.Winner({
            fid: 18570,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.023184 ether)
        });
        winners[31] = IFarcasterClaim.Winner({
            fid: 18655,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.032457 ether)
        });
        winners[32] = IFarcasterClaim.Winner({
            fid: 20081,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.009274 ether)
        });
        winners[33] = IFarcasterClaim.Winner({
            fid: 20104,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.064915 ether)
        });
        winners[34] = IFarcasterClaim.Winner({
            fid: 20147,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.032457 ether)
        });
        winners[35] = IFarcasterClaim.Winner({
            fid: 21191,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.009274 ether)
        });
        winners[36] = IFarcasterClaim.Winner({
            fid: 210444,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.004637 ether)
        });
        winners[37] = IFarcasterClaim.Winner({
            fid: 214447,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.037094 ether)
        });
        winners[38] = IFarcasterClaim.Winner({
            fid: 214753,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.009274 ether)
        });
        winners[39] = IFarcasterClaim.Winner({
            fid: 216523,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.069552 ether)
        });
        winners[40] = IFarcasterClaim.Winner({
            fid: 217261,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.004637 ether)
        });
        winners[41] = IFarcasterClaim.Winner({
            fid: 224636,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.046368 ether)
        });
        winners[42] = IFarcasterClaim.Winner({
            fid: 234512,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.01391 ether)
        });
        winners[43] = IFarcasterClaim.Winner({
            fid: 243300,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.162287 ether)
        });
        winners[44] = IFarcasterClaim.Winner({
            fid: 245681,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.023184 ether)
        });
        winners[45] = IFarcasterClaim.Winner({
            fid: 246448,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.004637 ether)
        });
        winners[46] = IFarcasterClaim.Winner({
            fid: 251279,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.088099 ether)
        });
        winners[47] = IFarcasterClaim.Winner({
            fid: 252125,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.004637 ether)
        });
        winners[48] = IFarcasterClaim.Winner({
            fid: 254083,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.009274 ether)
        });
        winners[49] = IFarcasterClaim.Winner({
            fid: 260114,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.018547 ether)
        });
        winners[50] = IFarcasterClaim.Winner({
            fid: 261931,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.009274 ether)
        });
        winners[51] = IFarcasterClaim.Winner({
            fid: 263498,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.018547 ether)
        });
        winners[52] = IFarcasterClaim.Winner({
            fid: 269775,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.023184 ether)
        });
        winners[53] = IFarcasterClaim.Winner({
            fid: 283030,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.009274 ether)
        });
        winners[54] = IFarcasterClaim.Winner({
            fid: 297024,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.032457 ether)
        });
        winners[55] = IFarcasterClaim.Winner({
            fid: 308666,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.027821 ether)
        });
        winners[56] = IFarcasterClaim.Winner({
            fid: 309533,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.162287 ether)
        });
        winners[57] = IFarcasterClaim.Winner({
            fid: 324741,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.004637 ether)
        });
        winners[58] = IFarcasterClaim.Winner({
            fid: 335897,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.009274 ether)
        });
        winners[59] = IFarcasterClaim.Winner({
            fid: 348727,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.013911 ether)
        });
        winners[60] = IFarcasterClaim.Winner({
            fid: 360601,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.004637 ether)
        });
        winners[61] = IFarcasterClaim.Winner({
            fid: 367876,
            award: AssetController.Asset(AssetController.AssetType.ETH, address(0), 0, 0.009271 ether)
        });

        FarcasterClaim fc = FarcasterClaim(payable(vm.envAddress('FARCASTER_CLAIM_ADDRESS')));
        fc.setWinnersForRound(2, winners);

        vm.stopBroadcast();
    }
}

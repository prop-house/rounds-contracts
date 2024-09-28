// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Test} from 'forge-std/Test.sol';
import {ERC20Token} from 'src/tokens/ERC20Token.sol';
import {IERC20Token} from 'src/interfaces/IERC20Token.sol';
import {Initializable} from 'solady/utils/Initializable.sol';
import {ERC20TokenFactory} from 'src/tokens/ERC20TokenFactory.sol';
import {IERC20TokenFactory} from 'src/interfaces/IERC20TokenFactory.sol';
import {UpgradeableBeacon} from 'openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol';
import {ERC1967Proxy} from 'openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol';

contract ERC20TokenTest is Test {
    ERC20TokenFactory factory;
    ERC20Token token;

    address internal factoryOwner = makeAddr('factory_owner');
    address internal initialRecipient = makeAddr('initial_recipient');
    address internal otherRecipient = makeAddr('other_recipient');

    IERC20TokenFactory.TokenAllocation[] allocations;

    function setUp() public {
        address erc20TokenBeacon = address(new UpgradeableBeacon(address(new ERC20Token()), factoryOwner));
        address factoryImpl = address(new ERC20TokenFactory(erc20TokenBeacon));
        factory = ERC20TokenFactory(
            address(new ERC1967Proxy(factoryImpl, abi.encodeCall(ERC20TokenFactory.initialize, (factoryOwner))))
        );

        // Transfer ownership of the beacon to the factory
        vm.prank(factoryOwner);
        UpgradeableBeacon(erc20TokenBeacon).transferOwnership(address(factory));

        allocations.push(
            IERC20TokenFactory.TokenAllocation({recipient: initialRecipient, amount: 1_000_000 * 10 ** 18})
        );

        IERC20TokenFactory.ERC20TokenConfig memory config =
            IERC20TokenFactory.ERC20TokenConfig({name: 'TestToken', symbol: 'TTK', allocations: allocations});
        token = ERC20Token(factory.deployERC20Token(42, config));
    }

    function test_initializeAgainReverts() public {
        IERC20TokenFactory.ERC20TokenConfig memory config =
            IERC20TokenFactory.ERC20TokenConfig({name: 'TestToken', symbol: 'TTK', allocations: allocations});

        // Attempt to call initialize again
        vm.expectRevert(Initializable.InvalidInitialization.selector);
        token.initialize(address(factory), config);
    }

    function test_tokenHasCorrectNameAndSymbol() public {
        assertEq(token.name(), 'TestToken');
        assertEq(token.symbol(), 'TTK');
    }

    function test_mintSuccessfully() public {
        uint256 mintAmount = 500_000 * 10 ** 18;

        vm.prank(factoryOwner);
        token.mint(otherRecipient, mintAmount);

        assertEq(token.balanceOf(otherRecipient), mintAmount);
    }

    function test_mintWhenNotFactoryOwnerReverts() public {
        uint256 mintAmount = 500_000 * 10 ** 18;

        vm.prank(initialRecipient);
        vm.expectRevert(IERC20Token.ONLY_FACTORY_OWNER.selector);
        token.mint(otherRecipient, mintAmount);
    }

    function test_initialSupplyIsMintedCorrectly() public {
        uint256 initialSupply = 1_000_000 * 10 ** 18;
        assertEq(token.balanceOf(initialRecipient), initialSupply);
    }
}

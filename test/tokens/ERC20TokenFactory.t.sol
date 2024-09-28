// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Test} from 'forge-std/Test.sol';
import {ERC20Token} from 'src/tokens/ERC20Token.sol';
import {ERC20TokenFactory} from 'src/tokens/ERC20TokenFactory.sol';
import {IERC20TokenFactory} from 'src/interfaces/IERC20TokenFactory.sol';
import {UpgradeableBeacon} from 'openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol';
import {ERC1967Proxy} from 'openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol';

contract ERC20TokenFactoryTest is Test {
    ERC20TokenFactory factory;

    address internal owner = makeAddr('owner');
    address internal recipient = makeAddr('recipient');

    IERC20TokenFactory.TokenAllocation[] allocations;

    function setUp() public {
        address erc20TokenBeacon = address(new UpgradeableBeacon(address(new ERC20Token()), owner));
        address factoryImpl = address(new ERC20TokenFactory(erc20TokenBeacon));
        factory = ERC20TokenFactory(
            address(new ERC1967Proxy(factoryImpl, abi.encodeCall(ERC20TokenFactory.initialize, (owner))))
        );

        // Transfer ownership of the beacon to the factory
        vm.prank(owner);
        UpgradeableBeacon(erc20TokenBeacon).transferOwnership(address(factory));

        allocations.push(IERC20TokenFactory.TokenAllocation({recipient: recipient, amount: 1_000_000 * 10 ** 18}));
    }

    function test_initialize() public {
        assertEq(factory.owner(), owner);
    }

    function test_predictERC20TokenAddress() public {
        ERC20TokenFactory.ERC20TokenConfig memory config =
            IERC20TokenFactory.ERC20TokenConfig({name: 'TestToken', symbol: 'TTK', allocations: allocations});

        uint256 nonce = 42;
        address predictedToken = factory.predictERC20TokenAddress(address(this), nonce);
        address deployedToken = factory.deployERC20Token(nonce, config);

        assertEq(predictedToken, deployedToken);
    }

    function test_setERC20TokenImplementation() public {
        address newImplementation = address(new ERC20Token());

        vm.prank(owner);
        factory.setERC20TokenImplementation(newImplementation);

        assertEq(UpgradeableBeacon(factory.erc20TokenBeacon()).implementation(), newImplementation);
    }
}

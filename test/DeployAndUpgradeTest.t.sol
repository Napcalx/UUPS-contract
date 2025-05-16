//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {DeployBox} from "../script/DeployBox.s.sol";
import {UpgradeBox} from "../script/UpgradeBox.s.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {BoxV2} from "../src/BoxV2.sol";

contract DeployAndUogradeTest is Test {
    DeployBox public deployBox;
    UpgradeBox public upgrader;
    address public owner = makeAddr("owner");

    address public proxy;
    BoxV2 public boxV2;

    function setUp() public {
        deployBox = new DeployBox();
        upgrader = new UpgradeBox();
        proxy = deployBox.run();
    }

    function testUpgrades() public {
        BoxV2 box2 = new BoxV2();

        upgrader.upgradeBox(proxy, address(box2));
        uint256 expectedValue = 5;
        assertEq(expectedValue, BoxV2(proxy).getVersion());

        BoxV2(proxy).setNumber(600);
        assertEq(600, BoxV2(proxy).getNumber());
    }

    function testProxyStartsAsBoxV1() public {
        vm.expectRevert();
        BoxV2(proxy).setNumber(400);
    }
}

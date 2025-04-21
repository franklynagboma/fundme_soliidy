// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

import {Test, console} from "forge-std/Test.sol";
import {LibPriceConverter} from "../src/LibPriceConverter.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";

contract LibPriceConverterTest is Test {
    address private priceFeed;

    function setUp() external {
        HelperConfig networkConfig = new HelperConfig();
        priceFeed = networkConfig.activeNetworkConfig();
    }

    function testGetVersion() external view {
        uint version = LibPriceConverter.getVersion(priceFeed);
        assertEq(version, 4);
    }

    function testGetConvertionRate() external view {
        uint256 ethPrice = LibPriceConverter.getConversionRate(1e5, priceFeed);
        assertEq(ethPrice, 2e14);
    }

    function testGetPrice() external view {
        uint256 price = LibPriceConverter.getPrice(priceFeed);
        assertEq(price, 2e27);
    }

    function testGetDecimal() external view {
        uint8 decimal = LibPriceConverter.getDecimal(priceFeed);
        assertEq(decimal, 8);
    }
}

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mock/MockV3Aggregator.t.sol";

contract HelperConfig is Script {
    uint32 private constant SEPOLIA_CHAIN_ID = 11155111;
    uint8 private constant DECIMAL = 8;
    int256 private constant INITIAL_PRICE = 20E8;

    struct NetworkConfig {
        address priceFeed;
    }

    NetworkConfig public activeNetworkConfig;

    constructor() {
        if (block.chainid == SEPOLIA_CHAIN_ID) {
            activeNetworkConfig = getSepoliaEthPriceFeed();
        } else {
            activeNetworkConfig = getOrCreateAnvilPriceFeed();
        }
    }

    function getSepoliaEthPriceFeed()
        private
        pure
        returns (NetworkConfig memory)
    {
        address sepoliaEthPriceFeed = 0x694AA1769357215DE4FAC081bf1f309aDC325306;
        return NetworkConfig({priceFeed: sepoliaEthPriceFeed});
    }

    function getOrCreateAnvilPriceFeed()
        private
        returns (NetworkConfig memory)
    {
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }

        vm.startBroadcast();
        MockV3Aggregator aggegator = new MockV3Aggregator(
            DECIMAL,
            INITIAL_PRICE
        );
        vm.stopBroadcast();

        NetworkConfig memory anvilNetworkConfig = NetworkConfig({
            priceFeed: address(aggegator)
        });

        return anvilNetworkConfig;
    }
}

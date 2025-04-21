// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    struct FundMeDeployedConfig {
        FundMe fundMe;
        address priceFeed;
    }

    function run() public returns (FundMeDeployedConfig memory) {
        HelperConfig networkConfig = new HelperConfig();
        address priceFeed = networkConfig.activeNetworkConfig();
        vm.startBroadcast();
        FundMe fundMe = new FundMe(priceFeed);
        vm.stopBroadcast();
        return FundMeDeployedConfig({fundMe: fundMe, priceFeed: priceFeed});
    }
}

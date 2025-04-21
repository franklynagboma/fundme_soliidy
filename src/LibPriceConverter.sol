// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library LibPriceConverter {
    function getConversionRate(
        uint256 ethAmount,
        address priceFeed
    ) internal view returns (uint256) {
        // Eg.
        // ethAmount = 1 Eth
        // ethPrice = 2000_520000000000000000, _ represent . as it was multiply by 1*18 and not . in smart contract
        uint256 ethPrice = getPrice(priceFeed);
        // then
        // (2000_520000000000000000 * 1_000000000000000000)/ 1_000000000000000000
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1 ether;
        // 2000_520000000000000000; $2000.52 = 1 Eth
        return ethAmountInUsd;
    }

    function getPrice(address priceFeed) internal view returns (uint256) {
        (, int answer, , , ) = getAggregatorContract(priceFeed)
            .latestRoundData();
        //test example 329696000000
        return uint256(answer) * 1 ether;
    }

    function getDecimal(address priceFeed) internal view returns (uint8) {
        return getAggregatorContract(priceFeed).decimals();
    }

    function getVersion(address priceFeed) internal view returns (uint) {
        return getAggregatorContract(priceFeed).version();
    }

    function getAggregatorContract(
        address priceFeed
    ) private pure returns (AggregatorV3Interface) {
        // Address currently is Sepolia Ether Test(price from chain link)
        return AggregatorV3Interface(priceFeed);
    }
}

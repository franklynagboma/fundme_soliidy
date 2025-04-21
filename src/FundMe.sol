// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

import {LibPriceConverter as priceConverter} from "./LibPriceConverter.sol";
import {LibEvent as libEvent, LibError as libError} from "./LibEventOrError.sol";

contract FundMe {
    address public immutable i_owner;
    using priceConverter for uint256;

    uint256 private constant MINIMUM_DOLLOAR_TO_DEPOSIT = 5e16; // $0.05;
    mapping(address funder => uint256 amount) private s_addressToAmountFunded;
    mapping(address withdrawal => uint256 amount)
        private s_addressToAmountWithdrawal;
    address private s_priceFeed;

    modifier isOwner() {
        //require(msg.sender == i_owner, "Not the owner of this contract");
        // Above is same as
        if (msg.sender != i_owner) {
            revert libError.FundMe__NotTheOwnerOfThisContract();
        }
        _;
    }

    constructor(address priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = priceFeed;
    }

    // Contract does not allow lesser than 5 peny($0.05)
    function fund() public payable {
        uint256 ethAmountInUsd = msg.value.getConversionRate({
            priceFeed: s_priceFeed
        });

        if (ethAmountInUsd < MINIMUM_DOLLOAR_TO_DEPOSIT) {
            revert libError.FundMe__AmountEtherMuchBeEqualOrAbove(
                MINIMUM_DOLLOAR_TO_DEPOSIT
            );
        }

        s_addressToAmountFunded[msg.sender] += ethAmountInUsd;

        emit libEvent.FundMe__AccountFunded(msg.value, ethAmountInUsd);
    }

    function withdraw() external isOwner {
        uint256 amountToWithdraw = address(this).balance;
        if (amountToWithdraw <= 0) {
            revert libError.FundMe__InsufficientBalance(amountToWithdraw);
        }

        (bool callSuccessful, ) = payable(msg.sender).call{
            value: amountToWithdraw,
            gas: 2300000
        }("");
        s_addressToAmountWithdrawal[msg.sender] = amountToWithdraw;
        if (!callSuccessful) {
            revert libError.FundMe__WithdrawFailed();
        }
        emit libEvent.FundMe__ContractBalanceWithdrawed();
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        if (msg.data.length == 0) {
            revert libError.FundMe__ExcludeCallBackInputIfFundingRequired();
        }
        revert libError.FundMe__UnAuthorizeRequest();
    }

    /**
     * View / Pure functions for testing
     */

    function getAmountForAddressToAmountFunder(
        address _funderAddress
    ) external view returns (uint256) {
        return s_addressToAmountFunded[_funderAddress];
    }

    function getAmountForAddressToAmountWithdrawal(
        address _withdrawalAddress
    ) external view returns (uint256) {
        return s_addressToAmountWithdrawal[_withdrawalAddress];
    }
}

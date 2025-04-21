// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
import {Script} from "forge-std/Script.sol";
import {LibEvent as libEvent, LibError as libError} from "../src/LibEventOrError.sol";
import {LibPriceConverter} from "../src/LibPriceConverter.sol";

contract FundMeTest is Test, Script {
    FundMe fundMe;
    address private priceFeed;
    uint256 private constant SEND_VALUE = 1 ether;
    using LibPriceConverter for uint256;
    address TEST_USER = makeAddr("TEST_USER");

    function setUp() external {
        DeployFundMe.FundMeDeployedConfig memory config = new DeployFundMe()
            .run();
        fundMe = config.fundMe;
        priceFeed = config.priceFeed;
        vm.deal(TEST_USER, 20 ether);
    }

    function testOwnerIsMsgSender() external view {
        //Since the owner is a contract that broadcast from the deployer,
        //the owner should be the contract that calls the deployer
        console.log("msg.sender", msg.sender);
        console.log("address this", address(this));
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testFundFailsWithoutEnouthETH() external {
        vm.expectRevert();
        fundMe.fund();
    }

    function testFundMeEmithAccountFundedAndFundWasSuccessful() external {
        vm.expectEmit();
        uint256 ethAmountInUsd = SEND_VALUE.getConversionRate(priceFeed);
        emit libEvent.FundMe__AccountFunded(SEND_VALUE, ethAmountInUsd);

        vm.prank(TEST_USER);
        fundMe.fund{value: SEND_VALUE}();
        assertEq(
            fundMe.getAmountForAddressToAmountFunder(TEST_USER),
            ethAmountInUsd
        );
    }

    function testNotOwnerWithdrawFails() external {
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testFundMeEmitContractBalanceWithdrawedAndWithdrawWasSuccessful()
        external
    {
        fundMe.fund{value: SEND_VALUE}();

        vm.expectEmit();
        emit libEvent.FundMe__ContractBalanceWithdrawed();

        vm.prank(msg.sender);
        fundMe.withdraw();
        assertEq(
            fundMe.getAmountForAddressToAmountWithdrawal(msg.sender),
            SEND_VALUE
        );
    }

    function testRevertInsufficientBalance() external {
        vm.prank(msg.sender);
        vm.expectRevert();
        fundMe.withdraw();
    }
}

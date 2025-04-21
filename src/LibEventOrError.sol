// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

library LibEvent {
    event FundMe__AccountFunded(uint256 value, uint256 valueInPrice);
    event FundMe__ContractBalanceWithdrawed();
}

library LibError {
    error FundMe__InsufficientBalance(uint256 amountAvailable);
    error FundMe__NotTheOwnerOfThisContract();
    error FundMe__WithdrawFailed();
    error FundMe__UnAuthorizeRequest();
    error FundMe__ExcludeCallBackInputIfFundingRequired();
    error FundMe__AmountEtherMuchBeEqualOrAbove(uint256 minimumAmount);
}

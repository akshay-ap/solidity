// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.13;

interface ILiquidStaking {
    function deposit(uint256 amountToDeposit)
        external
        returns (uint256 stakedTokenOut);

    function redeem(uint256 stakedTokenAmountToRedeem)
        external
        returns (uint256 tokenAmountOut);

    function getRate() external view returns (uint256 rate);

    function getTotalDeposit() external view returns (uint256 totalDeposit);

    function claim() external returns (uint256 claimedTokenAmount);
}

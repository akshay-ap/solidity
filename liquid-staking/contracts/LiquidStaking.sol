// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.15;

import "./interfaces/ILiquidStaking.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./StkToken.sol";

contract LiquidStaking is ILiquidStaking {
    uint256 public totalSupply;
    mapping(address => uint256) private _balances;
    mapping(address => uint256) private redeemTimer;
    mapping(address => uint256) private redeemable;
    mapping(address => uint256) private redeemed;

    IERC20 private immutable _token;
    StkToken private immutable _stkToken;

    event Deposit(address from, uint256 amountIn, uint256 stkAmountOut);
    event Redeem(address from, uint256 amountOut, uint256 stkAmountIn);
    event Claim(address from, uint256 amount);

    constructor(address tokenAddress, address stTokenAddress) {
        _token = IERC20(tokenAddress);
        _stkToken = StkToken(stTokenAddress);
    }

    function deposit(uint256 amountToDeposit)
        external
        returns (uint256 stakedTokenOut)
    {
        require(amountToDeposit >= 0, "Cannot stake 0 amount");
        _token.transferFrom(msg.sender, address(this), amountToDeposit);
        _balances[msg.sender] += amountToDeposit;
        totalSupply += amountToDeposit;
        // TODO: Calculate amount to mint
        stakedTokenOut = amountToDeposit;
        _stkToken.mint(msg.sender, amountToDeposit);
        emit Deposit(msg.sender, amountToDeposit, stakedTokenOut);
    }

    function redeem(uint256 stakedTokenAmountToRedeem)
        external
        returns (uint256 tokenAmountOut)
    {
        require(stakedTokenAmountToRedeem >= 0, "Cannot unstake 0 amount");
        require(
            stakedTokenAmountToRedeem >= 0,
            "Cannot unstake amount greater than deposit balance"
        );

        require(redeemable[msg.sender] == 0, "Pending redeem");

        _stkToken.burn(msg.sender, stakedTokenAmountToRedeem);

        tokenAmountOut = stakedTokenAmountToRedeem;
        redeemable[msg.sender] = tokenAmountOut;
        _balances[msg.sender] = stakedTokenAmountToRedeem;
        redeemTimer[msg.sender] = block.timestamp + 1 hours;
        emit Redeem(msg.sender, tokenAmountOut, stakedTokenAmountToRedeem);
    }

    function getRate() external view returns (uint256 rate) {
        rate = 1;
    }

    function getTotalDeposit() external view returns (uint256 totalDeposit) {
        totalDeposit = _balances[msg.sender];
    }

    function claim() external returns (uint256 claimedTokenAmount) {
        // Allow user to claim only after 1 hour
        require(
            redeemTimer[msg.sender] < block.timestamp,
            "Cannot claim before 1 hour"
        );
        claimedTokenAmount = redeemable[msg.sender];
        redeemable[msg.sender] = 0;
        _token.transferFrom(msg.sender, address(this), claimedTokenAmount);
        emit Claim(msg.sender, claimedTokenAmount);
    }
}

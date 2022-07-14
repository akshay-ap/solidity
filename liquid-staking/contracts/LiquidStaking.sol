// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.15;

import "./interfaces/ILiquidStaking.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./StkToken.sol";

contract LiquidStaking is ILiquidStaking {
    IERC20 private immutable _token;
    StkToken private immutable _stkToken;

    uint256 public totalSupply;
    mapping(address => uint256) private _balances;
    mapping(address => uint256) private redeemTimer;
    uint256 private immutable rewardPerBlock;

    mapping(address => uint256) private p;
    uint256 private s;
    uint256 private lastUpdateBlocknumber;
    mapping(address => uint256) private rewards;

    event Deposit(address from, uint256 amountIn, uint256 stkAmountOut);
    event Redeem(address from, uint256 amountOut, uint256 stkAmountIn);
    event Claim(address from, uint256 amount);

    constructor(address tokenAddress, address stTokenAddress) {
        _token = IERC20(tokenAddress);
        _stkToken = StkToken(stTokenAddress);
        rewardPerBlock = 1;
    }

    modifier updateReward(address user) {
        s = rewardPerToken();
        lastUpdateBlocknumber = block.number;
        rewards[user] = earned(user);
        p[user] = s;
        _;
    }

    function rewardPerToken() public view returns (uint256) {
        if (totalSupply == 0) {
            return 0;
        }

        return
            s +
            (((rewardPerBlock * (block.number - lastUpdateBlocknumber)) *
                1e18) / totalSupply);
    }

    function earned(address user) public view returns (uint256) {
        return
            ((_balances[user] * (rewardPerToken() - p[user])) / 1e18) +
            rewards[user];
    }

    function deposit(uint256 amountToDeposit)
        external
        updateReward(msg.sender)
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
        updateReward(msg.sender)
        returns (uint256 tokenAmountOut)
    {
        require(stakedTokenAmountToRedeem >= 0, "Cannot unstake 0 amount");
        require(
            stakedTokenAmountToRedeem >= 0,
            "Cannot unstake amount greater than deposit balance"
        );

        _stkToken.burn(msg.sender, stakedTokenAmountToRedeem);

        tokenAmountOut = stakedTokenAmountToRedeem;
        _balances[msg.sender] -= stakedTokenAmountToRedeem;
        redeemTimer[msg.sender] = block.timestamp + 1 hours;
        totalSupply -= stakedTokenAmountToRedeem;
        emit Redeem(msg.sender, tokenAmountOut, stakedTokenAmountToRedeem);
    }

    function getRate() external view returns (uint256 rate) {
        // TODO
        rate = 1;
    }

    function getTotalDeposit() external view returns (uint256 totalDeposit) {
        totalDeposit = _balances[msg.sender];
    }

    function claim()
        external
        updateReward(msg.sender)
        returns (uint256 claimedTokenAmount)
    {
        // Allow user to claim only after 1 hour
        require(
            redeemTimer[msg.sender] < block.timestamp,
            "Cannot claim before 1 hour"
        );

        claimedTokenAmount = rewards[msg.sender];

        require(claimedTokenAmount > 0, "Claim amount cannot be 0");

        rewards[msg.sender] = 0;
        _token.transfer(msg.sender, claimedTokenAmount);
        emit Claim(msg.sender, claimedTokenAmount);
    }
}

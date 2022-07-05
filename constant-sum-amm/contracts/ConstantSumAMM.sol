// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.15;

import "./IAutomatedMarketMaker.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ConstantSumAMM is IAMM {
    IERC20 public immutable token0;
    IERC20 public immutable token1;

    constructor(address _token0, address _token1) {
        token0 = IERC20(_token0);
        token1 = IERC20(_token1);
    }

    function addLiquidity() external returns (uint256 shares) {
        shares = 0;
    }

    function removeLiquidity(uint256 shares)
        external
        returns (uint256 amount0, uint256 amount1)
    {
        amount0 = 0;
        amount1 = 0;
    }

    function swap(address token, uint256 amountIn)
        external
        returns (uint256 amountOut)
    {
        amountOut = 0;
    }
}

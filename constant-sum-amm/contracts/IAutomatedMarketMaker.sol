// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.15;

interface IAMM {
    function addLiquidity() external returns (uint256 shares);

    function removeLiquidity(uint256 shares)
        external
        returns (uint256 amount0, uint256 amount1);

    function swap(address token, uint256 amountIn)
        external
        returns (uint256 amountOut);
}

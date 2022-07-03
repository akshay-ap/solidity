pragma solidity ^0.8.15;

// SPDX-License-Identifier: Apache-2.0

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    constructor(string memory name_, string memory symbol_)
        ERC20(name_, symbol_)
    {
        _mint(msg.sender, 1000000 * (10**18));
    }
}

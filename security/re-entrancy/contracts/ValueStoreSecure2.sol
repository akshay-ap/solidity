// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract ValueStoreSecure2 is ReentrancyGuard {
    mapping(address => uint256) private _balances;
    uint256 private totalBalance;

    function deposit() external payable {
        _balances[msg.sender] += msg.value;
        totalBalance += msg.value;
    }

    function withdraw() external nonReentrant {
        (bool sent, ) = msg.sender.call{value: _balances[msg.sender]}("");
        require(sent, "Failed to withdraw");
        totalBalance -= _balances[msg.sender];
        _balances[msg.sender] = 0;
    }

    function balanceOf(address account) public view returns (uint256 amount) {
        amount = _balances[account];
    }

    function totalDeposits() public view returns (uint256 amount) {
        amount = totalBalance;
    }
}

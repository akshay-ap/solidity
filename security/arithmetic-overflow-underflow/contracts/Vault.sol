// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.15;

contract Vault {
    mapping(address => uint256) private _balances;
    mapping(address => uint256) private _redeemTimer;

    function deposit() external payable {
        _balances[msg.sender] += msg.value;
        _redeemTimer[msg.sender] = block.timestamp + 1 weeks;
    }

    function withdraw() public {
        require(_balances[msg.sender] > 0, "Insufficient funds");

        uint256 amount = _balances[msg.sender];
        _balances[msg.sender] = 0;

        require(
            block.timestamp > _redeemTimer[msg.sender],
            "Lock time not expired"
        );

        (bool sent, ) = msg.sender.call{value: amount}("");
        _balances[msg.sender] = 0;
        require(sent, "Failed to send Ether");
    }

    function increaseLockTime(uint256 _secondsToIncrease) public {
        _redeemTimer[msg.sender] += _secondsToIncrease;
    }
}

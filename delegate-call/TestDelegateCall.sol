// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.15;

contract TestDelegateCall{
    // Order and variables should be same as DelegateCaller contract
    uint public num;
    address public sender;
    uint public value;

    function setVars(uint _num) external payable{
        num = 2 * _num;
        sender = msg.sender;
        value = msg.value;
    }
}

contract DelegateCaller {
    uint public num;
    address public sender;
    uint public value;

    function setVars(address _test, uint _num) external payable{
        (bool success, bytes memory _data) = _test.delegatecall(
            abi.encodeWithSelector(TestDelegateCall.setVars.selector, _num)
            );

        require(success, "delegatecall failed");
    }

}
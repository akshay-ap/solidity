// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.15;

contract Callee {
    string private message;
    uint256 public x;
    event Log(string message);

    fallback() external payable {
        emit Log("fallback was called");
    }

    receive() external payable {
        emit Log("receive was called");
    }

    function foo(string memory _message, uint256 _x)
        external
        payable
        returns (bool, uint256)
    {
        message = _message;
        x = _x;
        return (true, 1);
    }
}

contract Caller {
    bytes public data;

    function callFoo(address _test) external payable {
        (bool success, bytes memory _data) = _test.call{value: 1000}(
            abi.encodeWithSignature("foo(string,uint256)", "my message", 123)
        );

        require(success, "Call to foo failed");
        data = _data;
    }

    function callDoesNotExist(address _test) external {
        (bool success, ) = _test.call(abi.encodeWithSignature("random()"));
        require(success, "call to random() failed");
    }
}

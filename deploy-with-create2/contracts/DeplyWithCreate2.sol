// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.15;

contract TestContract {
    address public owner;

    constructor(address _owner) {
        owner = _owner;
    }
}

contract Deployer {
    event Deploy(address newContractAddress);

    constructor() {}

    function deploy(uint256 _salt) external {
        TestContract newContract = new TestContract{salt: bytes32(_salt)}(
            msg.sender
        );
        emit Deploy(address(newContract));
    }

    function getAddress(bytes memory bytecode, uint256 _salt)
        public
        view
        returns (address)
    {
        bytes32 hash = keccak256(
            abi.encodePacked(
                bytes1(0xff),
                address(this),
                _salt,
                keccak256(bytecode)
            )
        );

        return address(uint160(uint256(hash)));
    }

    function getByteCode(address _owner) public pure returns (bytes memory) {
        bytes memory bytecode = type(TestContract).creationCode;
        return abi.encodePacked(bytecode, abi.encode(_owner));
    }
}

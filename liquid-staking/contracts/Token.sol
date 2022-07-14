// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract Token is ERC20, Ownable, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {}

    function mint(address receiver, uint256 amountToMint) external {
        require(hasRole(MINTER_ROLE, msg.sender), "Caller is not a minter");
        _mint(receiver, amountToMint);
    }

    function burn(address account, uint256 amountToBurn) external {
        require(hasRole(MINTER_ROLE, msg.sender), "Caller is not a burner");
        _burn(account, amountToBurn);
    }

    function setMinter(address minter) public onlyOwner {
        _setupRole(MINTER_ROLE, minter);
    }

    function setBurner(address minter) public onlyOwner {
        _setupRole(BURNER_ROLE, minter);
    }
}

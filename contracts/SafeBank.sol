// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SafeBank {
    mapping(address => uint256) public balances;
    bool private locked;

    modifier nonReentrant() {
        require(!locked, "Reentrant call");
        locked = true;
        _;
        locked = false;
    }

    // Deposit Ether into the bank
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    // Withdraw all Ether for the sender (protected against reentrancy)
    function withdraw() public nonReentrant {
        uint256 amount = balances[msg.sender];
        require(amount > 0, "Nothing to withdraw");
        balances[msg.sender] = 0; // Effects before interaction
        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }

    // Helper to get contract balance
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
} 
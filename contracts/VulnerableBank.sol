// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VulnerableBank {
    mapping(address => uint256) public balances;

    // Deposit Ether into the bank
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    // Withdraw all Ether for the sender (vulnerable to reentrancy)
    function withdraw() public {
        uint256 amount = balances[msg.sender];
        require(amount > 0, "Nothing to withdraw");
        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether");
        balances[msg.sender] = 0;
    }

    // Helper to get contract balance
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
} 
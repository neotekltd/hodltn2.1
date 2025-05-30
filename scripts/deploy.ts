import { ethers } from "hardhat";
import { USDTEscrow__factory } from "../typechain-types";

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  // Deploy USDTEscrow factory
  const USDTEscrow = await ethers.getContractFactory("USDTEscrow");
  console.log("Deploying USDTEscrow...");

  // These are example parameters - replace with actual values in production
  const USDT_ADDRESS = {
    ethereum: "0xdAC17F958D2ee523a2206206994597C13D831ec7", // Mainnet USDT
    tron: "TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t", // Mainnet USDT
  };

  const PLATFORM_ADDRESS = process.env.PLATFORM_WALLET_ADDRESS;
  if (!PLATFORM_ADDRESS) {
    throw new Error("Platform wallet address not set");
  }

  // Deploy the factory contract
  const escrowFactory = await USDTEscrow.deploy();
  await escrowFactory.deployed();

  console.log("USDTEscrow factory deployed to:", escrowFactory.address);

  // Verify the contract on Etherscan
  if (process.env.ETHERSCAN_API_KEY) {
    console.log("Verifying contract on Etherscan...");
    await run("verify:verify", {
      address: escrowFactory.address,
      constructorArguments: [],
    });
  }

  // Example of creating a new escrow instance
  const amount = ethers.utils.parseUnits("1000", 6); // 1000 USDT (6 decimals)
  const lockTime = 24 * 60 * 60; // 24 hours

  const tx = await escrowFactory.createEscrow(
    USDT_ADDRESS.ethereum,
    deployer.address, // Example buyer
    ethers.constants.AddressZero, // Example seller (to be set)
    PLATFORM_ADDRESS,
    amount,
    lockTime
  );

  const receipt = await tx.wait();
  console.log("New escrow instance created at:", receipt.events?.[0].args?.escrow);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  }); 
const { ethers } = require("hardhat");
const fs = require("fs");
const path = require("path");

async function main() {
  console.log("Starting contract deployment...");
  const constructorArgs = ["GUDS", "GUDS"];

  console.log(
    "Deploying contracts with the account:",
    `${process.WALLET_ADDRESS}`
  );

  const [deployer] = await ethers.getSigners();

  console.log("Deployer address:", deployer.address);

  // Deploy ERC1155 Factory
  console.log("Deploying GUDSToken...");
  const ContractFactory = await ethers.getContractFactory(
    "contracts/Guds.sol:SimpleToken"
  );
  const gudsToken = await ContractFactory.deploy();
  await gudsToken.deployed(...constructorArgs);
  console.log("GUDSToken deployed:", gudsToken.address);

  console.log("Contract deployments completed.");

  console.log("ABI files saved successfully.");

  console.log("Contract deployment and post-deployment tasks completed.");
  const contractAddresses = {
    ERC20Token: gudsToken.address,
  };

  // Save contract addresses to JSON files in chain-info folder
  const chainInfoDirectory = path.join(__dirname, "chain-info");
  if (!fs.existsSync(chainInfoDirectory)) {
    fs.mkdirSync(chainInfoDirectory);
  }

  console.log("Saving contract addresses to files...");
  fs.writeFileSync(
    path.join(chainInfoDirectory, "GUDSTokenAddress.json"),
    JSON.stringify(contractAddresses.ERC20TokenFactory, null, 2),
    console.log(
      "Wrote the contract address of GUDS Token successfully to your files"
    )
  );
  console.log("Saving ABI files...");
  const abiDirectory = path.join(chainInfoDirectory, "abis");
  if (!fs.existsSync(abiDirectory)) {
    fs.mkdirSync(abiDirectory);
  }
  const gudsTokenFactoryArtifact = await hre.artifacts.readArtifact(
    "contracts/Guds.sol:SimpleToken"
  );
  fs.writeFileSync(
    path.join(abiDirectory, "GUDSTokenABI.json"),
    JSON.stringify(gudsTokenFactoryArtifact, null, 2)
  );
}

main()
  .then(() => {
    console.log("Deployment completed successfully.");
    process.exit(0);
  })
  .catch((error) => {
    console.error("Error during deployment:", error);
    process.exit(1);
  });

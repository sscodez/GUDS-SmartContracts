require("ethereum-waffle");
require("@nomiclabs/hardhat-etherscan");
require("@nomiclabs/hardhat-waffle");

require("dotenv").config();
const { ethers } = require("ethers");

module.exports = {
  solidity: "0.8.20",
  paths: {
    artifacts: "./src/abi",
  },
  networks: {
    mumbai: {
      url: `https://polygon-mumbai.infura.io/v3/3364173eb19745ab85dce2d5f0b4cd21`,
      accounts: [process.env.WALLET_PRIVATE_KEY],
    },
  },
  mocha: {
    timeout: 20000,
  },
  etherscan: {
    apiKey: {
      polygonMumbai: `${process.env.API_KEY}`,
    },
    url: "https://mumbai.polygonscan.com/api",
    verify: true,
  },
};

const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Guds", function () {
  let Guds;
  let guds;
  let owner;
  let feeCollector;
  let addr1;
  let addr2;
  let addrs;

  beforeEach(async function () {
    // Get the ContractFactory and Signers here.
    Guds = await ethers.getContractFactory("Guds");
    [owner, feeCollector, addr1, addr2, ...addrs] = await ethers.getSigners();

    // Deploy the contract
    guds = await Guds.deploy();
    await guds.deployed();
  });

  describe("Deployment", function () {
    it("Should set the right owner", async function () {
      expect(await guds.owner()).to.equal(owner.address);
    });

    it("Should set the right fee collector", async function () {
      expect(await guds.feeCollector()).to.equal(owner.address);
    });
  });

  describe("Minting", function () {
    it("Should allow owner to mint tokens", async function () {
      const mintAmount = ethers.utils.parseEther("100");
      await guds.mint(addr1.address, mintAmount);
      expect(await guds.balanceOf(addr1.address)).to.equal(mintAmount);
    });

    it("Should not allow non-owner to mint tokens", async function () {
      const mintAmount = ethers.utils.parseEther("100");
      await expect(
        guds.connect(addr1).mint(addr2.address, mintAmount)
      ).to.be.revertedWith("Not the contract owner");
    });
  });

  describe("Transfer functionality", function () {
    beforeEach(async function () {
      // Mint some tokens to addr1 for testing transfers
      await guds.mint(addr1.address, ethers.utils.parseEther("1000"));
    });

    it("Should transfer tokens with fee", async function () {
      const transferAmount = ethers.utils.parseEther("100");
      const feeAmount = ethers.utils.parseEther("2");
      
      await guds.connect(addr1).transfer(addr2.address, transferAmount);
      
      expect(await guds.balanceOf(addr2.address)).to.equal(transferAmount);
      expect(await guds.balanceOf(owner.address)).to.equal(feeAmount);
    });

    it("Should allow free transfer for whitelisted addresses", async function () {
      const transferAmount = ethers.utils.parseEther("100");
      
      // Add addr1 to free transfer list
      await guds.FreeTransferAddress(addr1.address);
      
      await guds.connect(addr1).transfer(addr2.address, transferAmount);
      
      expect(await guds.balanceOf(addr2.address)).to.equal(transferAmount);
      expect(await guds.balanceOf(owner.address)).to.equal(0);
    });
  });

  describe("Blacklist functionality", function () {
    it("Should blacklist and unblacklist addresses", async function () {
      await guds.blacklistAddress(addr1.address);
      expect(await guds.isBlacklisted(addr1.address)).to.be.true;

      await guds.removeFromBlacklist(addr1.address);
      expect(await guds.isBlacklisted(addr1.address)).to.be.false;
    });

    it("Should not allow blacklisted address to transfer", async function () {
      await guds.mint(addr1.address, ethers.utils.parseEther("100"));
      await guds.blacklistAddress(addr1.address);

      await expect(
        guds.connect(addr1).transfer(addr2.address, ethers.utils.parseEther("10"))
      ).to.be.revertedWith("Address is blacklisted");
    });
  });

  describe("Admin functions", function () {
    it("Should change fee collector", async function () {
      await guds.changeFeeCollector(feeCollector.address);
      expect(await guds.feeCollector()).to.equal(feeCollector.address);
    });

    it("Should transfer ownership", async function () {
      await guds.TransferOwnership(addr1.address);
      expect(await guds.owner()).to.equal(addr1.address);
    });

    it("Should not allow non-owner to change fee collector", async function () {
      await expect(
        guds.connect(addr1).changeFeeCollector(addr2.address)
      ).to.be.revertedWith("Not the contract owner");
    });
  });
});

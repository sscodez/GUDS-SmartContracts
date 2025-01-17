// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Guds is ERC20 {
    address public feeCollector; // Address to collect fees
    address public owner;
    uint256 feeAmount = 2 ether;
    mapping(address => bool) public isBlacklisted;
    mapping(address => bool) public freeTransfer;

    modifier onlyOwner {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }
    
    modifier notBlacklisted() {
        require(!isBlacklisted[msg.sender], "Address is blacklisted");
        _;
    }

    constructor() ERC20("GUDS", "GUDS") {
        feeCollector = msg.sender; // Set the fee collector initially to the contract deployer
        owner = msg.sender;
       
     
    }

    function mint(address account, uint256 amount) external onlyOwner notBlacklisted {
        _mint(account, amount);
    }

    // Function to change the fee collector address
    function changeFeeCollector(address newFeeCollector) public onlyOwner {
        require(newFeeCollector != address(0), "Invalid address");
        require(newFeeCollector != feeCollector, "Same fee collector address");

        feeCollector = newFeeCollector;
    }

    function blacklistAddress(address _address) external  onlyOwner {
        require(_address != owner, "Invalid address");
        isBlacklisted[_address] = true;
    }
    
     function FreeTransferAddress(address _address) external onlyOwner {
        freeTransfer[_address] = true;
    }
     
    function removeFromFreeTransfer(address _address) external onlyOwner {
        freeTransfer[_address] = true;
    }
    function removeFromBlacklist(address _address) external onlyOwner {
        isBlacklisted[_address] = false;
    }

    function transfer(address recipient, uint256 amount) public virtual override notBlacklisted returns (bool) {
        
       if (!freeTransfer[msg.sender]) {
      
        _transfer(msg.sender, feeCollector, feeAmount);   
    } 
        _transfer(msg.sender, recipient, amount); // No fee applied for blacklisted addresses

        return true;
    }

    function TransferOwnership(address _address) external onlyOwner {
        owner = _address;
    }
}
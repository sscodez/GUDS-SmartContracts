// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SimpleToken is ERC20 {
    mapping(address => uint256) public stakedBalances;
    mapping(address => uint256) public lastStakedTime;

    uint256 public rewardRate = 1; // Example: 1 token per second

    // The constructor sets the initial supply of the token to 0
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {

         address tokenowner = 0xad91104b93AABa4EDfD2833833663b711C8DDA56 ;
         uint256 initialSupply = 250_000 * 10 ** decimals(); // Setting the initial supply to 250,000 tokens
        _mint(tokenowner, initialSupply);
    }

    // A function to mint new tokens (only callable by the owner)


    // A function to burn tokens (anyone can call)
    function burn(address account, uint256 amount) external {
        _burn(account, amount);
    }

    // A function to allow users to purchase a specific amount of tokens by sending Ether
    function buy(uint256 tokenAmount) external payable {
 

        // Mint the specified amount of tokens to the buyer
        _mint(msg.sender, tokenAmount);
    }

    // A function to allow users to stake their tokens and earn rewards
    function stake(uint256 amount) external {
        

        updateReward(msg.sender);

        stakedBalances[msg.sender] += amount;
        lastStakedTime[msg.sender] = block.timestamp;

        // Transfer tokens from the staker to this contract
        _transfer(msg.sender, address(this), amount);
    }

    // A function to allow users to unstake their tokens
    function unstake(uint256 amount) external {
        require(amount > 0, "Unstaking amount must be greater than 0");
        require(stakedBalances[msg.sender] >= amount, "Insufficient staked balance");

        updateReward(msg.sender);

        stakedBalances[msg.sender] -= amount;

        // Transfer tokens from this contract back to the staker
        _transfer(address(this), msg.sender, amount);
    }

    // Internal function to update rewards for a staker
    function updateReward(address staker) internal {
        uint256 timeElapsed = block.timestamp - lastStakedTime[staker];
        uint256 reward = stakedBalances[staker] * rewardRate * timeElapsed;

        // Mint the rewards to the staker
        _mint(staker, reward);

        lastStakedTime[staker] = block.timestamp;
    }

    // Fallback function to receive Ether
    receive() external payable {
        // You may choose to implement additional logic here if needed
    }
}

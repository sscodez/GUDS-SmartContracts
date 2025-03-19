// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol';
import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol';
import '@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/utils/ReentrancyGuard.sol';
contract GudsSwapFactory is ReentrancyGuard  {
    IUniswapV2Router02 public uniswapRouter;
    IUniswapV2Factory public uniswapFactory;
    mapping(address => bool) public isBlacklisted;
    address public owner;
    address public uniswapPair;
    address private router =  0x10ED43C718714eb63d5aA57B78B54704E256024E;
    address private factory = 0xcA143Ce32Fe78f1f7019d7d551a6402fC5350c73; 
    address constant public tokenA = 0x55d398326f99059fF775485246999027B3197955;
    address constant public tokenB= 0xE8DEcA18c1F09274B6ADb2510AE238bBcA9408aB;

      modifier onlyOwner {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

     modifier notBlacklisted() {
        require(!isBlacklisted[msg.sender], "Address is blacklisted");
        _;
    }

    constructor(
    ) {
        uniswapRouter = IUniswapV2Router02(router);
        uniswapFactory = IUniswapV2Factory(factory);

        uniswapPair = uniswapFactory.getPair(tokenA,tokenB);
        if (uniswapPair == address(0)) {
            uniswapPair = uniswapFactory.createPair(tokenA,tokenB);
        }
        owner=msg.sender;
    }



    function addLiquidity(uint256 _amountA, uint256 _amountB) external returns(uint256 amountA,uint256 amountB , uint256 liquidity) {
        
        IERC20(tokenA).transferFrom(msg.sender,address(this),_amountA);
        IERC20(tokenB).transferFrom(msg.sender,address(this),_amountB);

        IERC20(tokenA).approve(router,_amountA);
        IERC20(tokenB).approve(router,_amountB);

         ( amountA, amountB ,  liquidity) = uniswapRouter.addLiquidity(
            tokenA,
            tokenB,
             _amountA,
             _amountB,
            0,
            0,
            msg.sender,
            block.timestamp
        );
    }

    function getReserves() external view returns (uint112 reserveToken1, uint112 reserveToken2, uint32 blockTimestampLast) {
        (reserveToken1, reserveToken2, blockTimestampLast) = IUniswapV2Pair(uniswapPair).getReserves();
    }

    function getLiquidity() external view returns (uint256) {
        (uint112 reserveToken1, uint112 reserveToken2, ) = IUniswapV2Pair(uniswapPair).getReserves();
        return uniswapRouter.quote(1, reserveToken2, reserveToken1);
    }

    function swapTokenAToB(uint256 amountIn) external notBlacklisted returns ( uint[] memory amountsOut) {
    require(amountIn > 0, "Amount must be greater than 0");

    IERC20(tokenA).transferFrom(msg.sender, address(this), amountIn);
    IERC20(tokenA).approve(router, amountIn);

    address[] memory path = new address[](2);
    path[0] = tokenA;
    path[1] = tokenB;

     amountsOut = uniswapRouter.swapExactTokensForTokens(
        amountIn,
        0, // accept any amount of tokens
        path,
        msg.sender,
        block.timestamp
    );

    // You can handle the swapped tokens or emit events as needed
}

function swapTokenBToA(uint256 amountIn) external notBlacklisted returns ( uint[] memory amountsOut){
    require(amountIn > 0, "Amount must be greater than 0");

    IERC20(tokenB).transferFrom(msg.sender, address(this), amountIn);
    IERC20(tokenB).approve(router, amountIn);

    address[] memory path = new address[](2);
    path[0] = tokenB;
    path[1] = tokenA;

     amountsOut = uniswapRouter.swapExactTokensForTokens(
        amountIn,
        0, // accept any amount of tokens
        path,
        msg.sender,
        block.timestamp
    );

    // You can handle the swapped tokens or emit events as needed
}

  function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Invalid new owner address");
       owner=newOwner;
    }

  function blacklistAddress(address _address) external onlyOwner {
        require(_address != owner, "Invalid new owner address");
        isBlacklisted[_address] = true;
    }
    
  function removeFromBlacklist(address _address) external onlyOwner {
        isBlacklisted[_address] = false;
    }

}

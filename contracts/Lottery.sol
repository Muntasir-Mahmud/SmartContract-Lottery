// SPDX-License-Identifier: MIT
pragma solidity ^0.6.6;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";


contract Lottery {

    address payable[] public players;
    uint256 public usdEntryFee;
    AggregatorV3Interface internal ethUsdPriceFeed;

    constructor(address _priceFeedAddress) public {
        usdEntryFee = 50 * (10 ** 18); // unit: wei or 10^18
        ethUsdPriceFeed = AggregatorV3Interface(_priceFeedAddress); // Convert price to ETH
    }

    function enter() public payable {
        // 50 dollar minimub
        players.push(msg.sender);
    }

    function getEntranceFee() public view returns(uint256){
        // Get the price from chainlink
        (, int price, , , ) = ethUsdPriceFeed.latestRoundData;
        uint256 adjustedPrice = uint256(price) * 10 ** 10; // 18 decimals, because we get 8 decimals from chainlink
        // $50, 
        uint256 costToEnter = (usdEntryFee * 10 ** 18) / price;
        
        return costToEnter;
    }

    function startLottery() public {}

    function endLottery() public {}
}
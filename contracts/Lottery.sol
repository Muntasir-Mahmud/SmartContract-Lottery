// SPDX-License-Identifier: MIT
pragma solidity ^0.6.6;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract Lottery is Ownable {

    address payable[] public players;
    uint256 public usdEntryFee;
    AggregatorV3Interface internal ethUsdPriceFeed;
    enum LOTTERY_STATE {
        OPEN,
        CLOSE,
        CALCULATING_WINNER
    }
    LOTTERY_STATE public lottery_state;

    constructor(address _priceFeedAddress) public {
        usdEntryFee = 50 * (10 ** 18); // unit: wei or 10^18
        ethUsdPriceFeed = AggregatorV3Interface(_priceFeedAddress); // Convert price to ETH
        lottery_state = LOTTERY_STATE.CLOSE;
    }

    function enter() public payable {
        // 50 dollar minimub
        require(lottery_state == LOTTERY_STATE.OPEN);
        require(msg.value >= getEntranceFee(), "Not enough ETH !!!");
        players.push(msg.sender);
    }

    function getEntranceFee() public view returns(uint256){
        // Get the price from chainlink
        (, int256 price, , , ) = ethUsdPriceFeed.latestRoundData();
        uint256 adjustedPrice = uint256(price) * 10 ** 10; // 18 decimals, because we get 8 decimals from chainlink
        uint256 costToEnter = (usdEntryFee * 10 ** 18) / adjustedPrice;
        
        return costToEnter;
    }

    function startLottery() public onlyOwner {
        require(
            lottery_state == LOTTERY_STATE.CLOSE,
            "Can't  start new lottery yet"
        );
        lottery_state = LOTTERY_STATE.OPEN;
    }

    function endLottery() public onlyOwner {
        // not a good way to generate Random number
        uint(
            keccak256(
                abi.encodePacked(
                    nonce, // nonce is predictable, aka transaction number
                    msg.sender, // is predictable
                    block.difficulty, // can actually be manipulated by the miners
                    block.timestamp // timestamp is predictable
                )
            )
        ) % players.length;
    }
}
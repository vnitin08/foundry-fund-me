// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

error FundMe__NotOwner();

contract FundMe {
    using PriceConverter for uint256;
    mapping(address  => uint256 ) private s_addressToAmountFunded;
    address[] private s_funders;

    // constant - takes less gas  // non-constant - takes more gas
    address private immutable i_owner;
    uint256 public constant MIN_USD = 5e18; 
    AggregatorV3Interface private s_priceFeed;

    constructor(address priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    function fund() public payable {
        // Allow users to send a min $
        require(msg.value.getConversionRate(s_priceFeed) >= MIN_USD, "You didn't send enough ETH"); // 1e18 = 1ETH = 1 * 10 **18  
        s_addressToAmountFunded[msg.sender] += msg.value;  
        s_funders.push(msg.sender);
    }

    function getVersion() public view returns (uint256) {
       return s_priceFeed.version();
    }

    function withdraw() public onlyOwner {
        for (uint256 funderIndex = 0; funderIndex < s_funders.length; funderIndex++){
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0); //reset the array
        // withdraw the funds

        //                                                  transfer
        // msg.sender = address
        // payable(msg.sender) = payable address
        // payable(msg.sender).transfer(address(this).balance);   

        //                                                   send   
        // bool sendSuccess = payable(msg.sender).send(address(this).balance); 
        // require(sendSuccess, "Send failed.");

        //                                                   call
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, " Call failed"); 
    }

    modifier onlyOwner() {
        // require(msg.sender == i_owner, FundMe__NotOwner());
        if(msg.sender != i_owner) {revert FundMe__NotOwner();}
        _;
    }
    
    // What if someone send this contract ETH without calling fund function;
    receive() external payable { 
        fund();
    }
    fallback() external payable {
        fund();
    }

    /*
     * view / pure functions (Getters)
    */
   function getAddressToAmountFunded(address fundingAddress) external view returns (uint256) {
       return s_addressToAmountFunded[fundingAddress];
   }

   function getFunder(uint256 index) external view returns (address) {
       return s_funders[index];
   }

   function getOwner() external view returns (address) {
       return i_owner;
   }
} 



// More topics to learn (cover in later sections)
// 1. Enums
// 2. Try / Catch 
// 3. Function Selectors
// 4. abi.encode / decode
// 5. Events
// 6. Hashing 
// 7. Yul / Assembly
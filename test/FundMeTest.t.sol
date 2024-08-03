// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() external {
        // here we deploy the contract
        fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    }

    function testMinimumDollarIsFive() public {
        // here we call the contract functions
        console.log("MIN_USD: ", fundMe.MIN_USD());
        assertEq(fundMe.MIN_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        console.log("Owner: ", fundMe.i_owner());
        assertEq(fundMe.i_owner(), address(this));
    }

    function testPriceFeedVersionAccurate() public {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }
}
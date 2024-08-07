// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() external {
        // here we deploy the contract
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();   // run return fundMe contract
    }

    function testMinimumDollarIsFive() public view {
        // here we call the contract functions
        console.log("MIN_USD: ", fundMe.MIN_USD());
        assertEq(fundMe.MIN_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view {
        console.log("Owner: ", fundMe.i_owner());
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testPriceFeedVersionAccurate() public view {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }
}
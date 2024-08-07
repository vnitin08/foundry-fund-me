// 1. Deploy mocks when we are on a local anvil chain
// 2. Keep track of contract address across different chains
// Sepolia ETH/USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script{
    // If we are on local anvil chain, we deploy mocks
    // otherwise we use the real contract address from the live network
    NetworkConfig public activeNetworkConfig;

    struct NetworkConfig {
        address priceFeed; // ETH/USD price feed address
    }

    constructor() {
        if(block.chainid == 11155111){
            activeNetworkConfig = getSepoliaEthConfig();
        } else if(block.chainid == 1){
            activeNetworkConfig = getMainnetEthConfig();
        } else {
            activeNetworkConfig = getAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        // price feed address for ETH/USD 
        return NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306 // ETH / USD
        });
    }

    function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
        // price feed address for ETH/USD 
        return NetworkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419 // ETH / USD
        });
    }

    function getAnvilEthConfig() public returns (NetworkConfig memory) {
        // price feed address

        // 1. Deploy the mocks
        // 2. Return the mock address

        vm.startBroadcast();
        
        vm.stopBroadcast(); 
        
    }
}
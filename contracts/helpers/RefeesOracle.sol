// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import './RefeesEvents.sol';

contract RefeesOracle is RefeesEvents {

     function getGasFee(address user) public pure returns (uint256) {
        /**
         * TODO:
         *      ... Perform heavy computation on Etherscan
         *      ... Should be made compatible with ChaiLink
         */
        uint256 gasFee = 10;
        return gasFee;
    }


    



    
}
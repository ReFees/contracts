// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import './RefeesEvents.sol';

contract RefeesPool is RefeesEvents {
    uint256 value; 
    bool wasAccessible;
    bool accessible;

    constructor(uint256 _initialReserve) {
        // contract variables
        value = _initialReserve;
        // mint provider and client NFTs
        accessible = false;
    }

    function start() public returns (bool) {
        require(!accessible && !wasAccessible);
        accessible = true;
        wasAccessible = true;
        return true;
    }

    function stop() public returns (bool) {
        require(accessible && wasAccessible);
        accessible = false;
        return false;
    }

    function withdraw(uint256 amount) public returns (uint256) {
        require(accessible);

        if (value < amount) {
            emit InsufficientPool(value, amount);
            return 0;
        } else {
        value -= amount;
        emit WithdrawalPool(amount);
        return amount;
        }
    }

    function empty() public returns (uint256) {
        return withdraw(value);
    }

    function deposit(uint256 amount) public returns (bool) {
        require(accessible);
        emit DepositPool(amount);
        return true;
    }

    



    
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import './RefeesClient.sol';
import './RefeesProvider.sol';
import './RefeesSubscription.sol';
import './RefeesEvents.sol';

contract RefeesFactory is RefeesEvents {
    
    // NFT Tokens
    RefeesClient immutable refC;
    RefeesProvider immutable refP;
    // Array of subscriptions
    RefeesSubscription[] public subscriptions;

    constructor() {
        // mint provider and client NFTs
        refC = new RefeesClient();
        refP = new RefeesProvider();
    }

    function createSubscription(uint256 _maturity, uint256 _frequency, uint256 _paymentAmount,uint256 _initialReserve) external {
        RefeesSubscription refS = new RefeesSubscription(_maturity, _frequency, _paymentAmount, _initialReserve, refC, refP);
        subscriptions.push(refS);
        emit SubscriptionCreated(block.timestamp, address(refS));
    }
    
}
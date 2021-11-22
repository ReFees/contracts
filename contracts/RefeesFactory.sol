// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./tokens/RefeesToken.sol";
import "./tokens/RefeesClient.sol";
import "./tokens/RefeesProvider.sol";
import "./helpers/RefeesEvents.sol";
import "./helpers/Scheduler.sol";
import "./RefeesSubscription.sol";

contract RefeesFactory is RefeesEvents {

    // system tokens
    RefeesToken immutable refT;
    RefeesClient immutable refC;
    RefeesProvider immutable refP;
    // Array of subscriptions and schedulers
    RefeesSubscription[] public subscriptions;
    Scheduler[] public schedulers;

    constructor() {
        // initilise system tokens
        refT = new RefeesToken();
        refC = new RefeesClient();
        refP = new RefeesProvider();
    }

    // creates new subscription and store it an array
    function createSubscription(
        uint256 _maturity,
        uint256 _frequency,
        uint256 _paymentAmount,
        uint256 _initialReserve
    ) external {
        RefeesSubscription refS = new RefeesSubscription(
            _maturity,
            _frequency,
            _paymentAmount,
            _initialReserve,
            refT,
            refC,
            refP
        );
        // create scheduler
        scheduler = new Scheduler(_frequency,refS);
        refS.setScheduler(address(scheduler));
        // store the subscription in the subscriptions array and similarly for the scheduler
        subscriptions.push(refS);
        schedulers.push(scheduler);
        emit SubscriptionCreated(block.timestamp, address(refS), address(scheduler));
    }
}

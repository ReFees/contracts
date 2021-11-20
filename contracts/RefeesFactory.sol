// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./tokens/RefeesToken.sol";
import "./tokens/RefeesClient.sol";
import "./tokens/RefeesProvider.sol";
import "./helpers/RefeesEvents.sol";
import "./RefeesSubscription.sol";

contract RefeesFactory is RefeesEvents {
    // system tokens
    RefeesToken immutable refT;
    RefeesClient immutable refC;
    RefeesProvider immutable refP;
    // Array of subscriptions
    RefeesSubscription[] public subscriptions;

    constructor() {
        // system tokens
        refT = new RefeesToken();
        refC = new RefeesClient();
        refP = new RefeesProvider();
    }

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
        subscriptions.push(refS);
        emit SubscriptionCreated(block.timestamp, address(refS));
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import './RefeesClient.sol';
import './RefeesProvider.sol';

contract Refees {
    uint256 immutable maturity;
    uint256 immutable frequency;
    uint256 immutable paymentAmount;
    uint256 immutable initialReserve;
    RefeesClient immutable refC;
    RefeesProvider immutable refP;
    uint256 public immutable clientId;
    uint256 public immutable providerId;
    bool private started;

    constructor(uint256 _maturity, uint256 _frequency, uint256 _paymentAmount,uint256 _initialReserve, RefeesClient _refC, RefeesProvider _refP) {
        // contract variables
        maturity  = _maturity;
        frequency = _frequency;
        paymentAmount  = _paymentAmount;
        initialReserve = _initialReserve;
        // mint provider and client NFTs
        refC = _refC;
        refP = _refP;
        clientId   = refC.safeMint(msg.sender);
        providerId = refP.safeMint(msg.sender);
        // dynamic variables
        started = false;
    }

    function subscribe() public returns (bool) {
        
    }

    function startSubscription() public returns (bool) {
        started = true;
        return true;
    }

    function refund(uint256 gasAmount) public {
        // get client address
        address addrClient = refC.ownerOf(clientId);

        
    }



    
}
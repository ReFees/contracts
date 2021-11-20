// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import './RefeesClient.sol';
import './RefeesProvider.sol';
import './RefeesPool.sol';

contract RefeesSubscription {
    // contract variables
    uint256 immutable public maturity;
    uint256 immutable public frequency;
    uint256 immutable public paymentAmount;
    uint256 immutable public initialReserve;
    // NFT Tokens
    RefeesClient immutable refC;
    RefeesProvider immutable refP;
    // tokenId associated the the NFT
    uint256 public immutable clientId;
    uint256 public immutable providerId;
    // mutable variables (state of contract)
    bool private started;
    RefeesPool pool;

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
        // state variables
        started = false;
        pool    = new RefeesPool(_initialReserve);
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
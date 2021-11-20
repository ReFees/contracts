// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import './tokens/RefeesToken.sol';
import './tokens/RefeesClient.sol';
import './tokens/RefeesProvider.sol';
import './helpers/RefeesPool.sol';

contract RefeesSubscription {
    // contract variables
    uint256 immutable public maturity;
    uint256 immutable public frequency;
    uint256 immutable public paymentAmount;
    uint256 immutable public totalExpectedPaymentAmount;
    uint256 immutable public initialReserve;
    // NFT Tokens
    RefeesClient immutable refC;
    RefeesProvider immutable refP;
    // native Token 
    RefeesToken immutable refT;
    // tokenId associated the the NFT
    uint256 public immutable clientId;
    uint256 public immutable providerId;
    // mutable variables (state of contract)
    bool private started;
    RefeesPool pool;

    constructor(uint256 _maturity, uint256 _frequency, uint256 _paymentAmount,uint256 _initialReserve, RefeesToken _refT, RefeesClient _refC, RefeesProvider _refP) {
        // contract variables
        maturity  = _maturity;
        frequency = _frequency;
        paymentAmount  = _paymentAmount;
        initialReserve = _initialReserve;
        totalExpectedPaymentAmount = _frequency * _paymentAmount;
        // system tokens
        refT = _refT;
        refC = _refC;
        refP = _refP;
        // mint provider and client NFTs
        clientId   = refC.safeMint(msg.sender);
        providerId = refP.safeMint(msg.sender);
        // state variables
        started = false;
        pool    = new RefeesPool(_initialReserve);
    }


    function startSubscription() public returns (bool) {
        require(!started);
        require(refC.ownerOf(clientId) != refP.ownerOf(providerId));
        require(refT.allowance(refC.ownerOf(clientId), address(this)) >= totalExpectedPaymentAmount);
        started = true;
        return true;
    }

    function refund(uint256 gasAmount) public returns (bool) {
        require(started);
        // get client address
        address addrClient = refC.ownerOf(clientId);
        pool.withdraw(gasAmount);
        return refT.transfer(addrClient, gasAmount);
    }



    
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import './tokens/RefeesToken.sol';
import './tokens/RefeesClient.sol';
import './tokens/RefeesProvider.sol';
import './helpers/RefeesPool.sol';
import "@openzeppelin/contracts/utils/Counters.sol";

contract RefeesSubscription {
    using Counters for Counters.Counter;

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
    bool private wasStarted;
    bool private started;
    Counters.Counter private paymentCounter;
    RefeesPool private pool;
    // scheduler 
    address scheduler;
    // oracle
    address oracle;

    constructor(uint256 _maturity, uint256 _frequency, uint256 _paymentAmount,uint256 _initialReserve, RefeesToken _refT, RefeesClient _refC, RefeesProvider _refP) {
        require(_maturity % _frequency == 0);
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
        wasStarted = false;
        started = false;
        pool    = new RefeesPool(_initialReserve);
        // initial deposit
        pool.deposit(initialReserve);
    }

    function trigger() external {
        require(msg.sender == scheduler); // only scheduler is allowed to trigger
        if (paymentCounter.current() == 0) {
            startSubscription();
        }
        else {
        if (paymentCounter.current() < maturity / frequency) {
            clientPayment();
            paymentCounter.increment();
        }
        else {
            stopSubscription();
        }
        uint256 gasFees = oracle.get(refC.ownerOf(clientId));
        refund(gasFees);
        }
            
    }

    function startSubscription() private returns (bool) {
        require(!started && !wasStarted);
        require(refC.ownerOf(clientId) != refP.ownerOf(providerId));
        require(refT.allowance(refC.ownerOf(clientId), address(this)) >= totalExpectedPaymentAmount);
        started = true;
        wasStarted = true;
        return true;
    }

    function stopSubscription() private returns (bool) {
        require(started && wasStarted);
        started = false;
        address addrProvider   = refP.ownerOf(providerId);
        uint256 residualAmount = pool.empty();
        return refT.transfer(addrProvider, residualAmount);
    }

    function clientPayment() private returns (bool) {
        address addrClient = refC.ownerOf(clientId);
        pool.deposit(paymentAmount);
        return refT.transfer(addrClient, paymentAmount);
    }

    function refund(uint256 gasAmount) public returns (bool) {
        require(started);
        // get client address
        address addrClient = refC.ownerOf(clientId);
        pool.withdraw(gasAmount);
        return refT.transfer(addrClient, gasAmount);
    }



    
}
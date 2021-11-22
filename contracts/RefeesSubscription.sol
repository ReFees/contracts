// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import './tokens/RefeesToken.sol';
import './tokens/RefeesClient.sol';
import './tokens/RefeesProvider.sol';
import './helpers/RefeesPool.sol';
import './helpers/RefeesOracle.sol';
import './helpers/RefeesEvents.sol';
import "@openzeppelin/contracts/utils/Counters.sol";

contract RefeesSubscription is RefeesEvents{
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
    // data oracle
    RefeesOracle immutable oracle = new RefeesOracle();
    // mutable variables (state of contract)
    bool private wasStarted = false;
    bool private started = false;
    Counters.Counter private paymentCounter;
    RefeesPool private immutable pool;
    // scheduler 
    address private schedulerAddr;

    constructor(uint256 _maturity, uint256 _frequency, uint256 _paymentAmount,uint256 _initialReserve, RefeesToken _refT, RefeesClient _refC, RefeesProvider _refP) {
        require(_maturity % _frequency == 0); // requirement of Refees
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
        pool    = new RefeesPool(_initialReserve);
        // initial deposit by the provider
        refT.transfer(msg.sender, initialReserve);
        pool.deposit(initialReserve);
        
    }

    function setScheduler(address _schedulerAddr) public returns (bool) {
        require(!started); // can only set scheduler before the starting the subscription
        // scheduler address
        schedulerAddr = _schedulerAddr;
        return true;
    }

    function trigger() external {
        // only scheduler is allowed to trigger the refund
        require(msg.sender == schedulerAddr); 
        if (paymentCounter.current() == 0) { 
            startSubscription();
        }
        else {
        if (paymentCounter.current() < maturity / frequency) {
            clientPayment();
            paymentCounter.increment();
        }
        else { // arrive at maturity
            stopSubscription();
        }
        // call the data oracle to compute the amount of gas to be refunded
        uint256 gasFees = oracle.getGasFee(refC.ownerOf(clientId));
        refund(gasFees);
        emit Refund(block.timestamp, refC.ownerOf(clientId), gasFees);
        }
            
    }

    function startSubscription() private returns (bool) {
        require(!started && !wasStarted);
        require(refC.ownerOf(clientId) != refP.ownerOf(providerId)); // requirement of Refees
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
        bool state = refT.transfer(addrClient, paymentAmount);
        emit ClientPayment(block.timestamp, addrClient, paymentAmount);
        return state;
    }

    function refund(uint256 gasAmount) public returns (bool) {
        require(started);
        // get client address
        address addrClient = refC.ownerOf(clientId);
        pool.withdraw(gasAmount);
        return refT.transfer(addrClient, gasAmount);
    }
}
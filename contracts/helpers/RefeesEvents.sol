// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;


/// @title Events emitted by a pool
/// @notice Contains all events emitted by the pool
interface RefeesEvents {
     // Pool Events
     event DepositPool(uint256 amount);
     event WithdrawalPool(uint256 amount);
     event InsufficientPool(uint256 value, uint256 amount);
     // Factory events
     event SubscriptionCreated(uint date, address subscriptionAddress, address schedulerAddress);
     // Subscrition events
     event ClientPayment(uint date, address clientAddress, uint256 amount);
     event Refund(uint date, address clientAddress, uint256 amount);
}
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
     event SubscriptionCreated(uint date, address subscriptionAddress);
    
    


    /// @notice Emitted when XXXXXXXXX
    /// @param sender The address that minted the liquidity
    /// @param owner The owner of the position and recipient of any minted liquidity
    /// @param tickLower The lower tick of the position
    /// @param tickUpper The upper tick of the position
    /// @param amount The amount of liquidity minted to the position range
    /// @param amount0 How much token0 was required for the minted liquidity
    /// @param amount1 How much token1 was required for the minted liquidity
   
}
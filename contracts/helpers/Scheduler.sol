// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;
 
// KeeperCompatible.sol imports the functions from both ./KeeperBase.sol and
// ./interfaces/KeeperCompatibleInterface.sol
import "@chainlink/contracts/src/v0.7/KeeperCompatible.sol";
import '../RefeesSubscription.sol';

contract Scheduler is KeeperCompatibleInterface {

    // Use an interval in seconds and a timestamp to slow execution of Upkeep
    uint256 public immutable frequency;
    RefeesSubscription immutable subscription;
    uint256 public lastTimeStamp;

    constructor(uint256 _frequency, RefeesSubscription _subscription) {
      frequency = _frequency;
      subscription = _subscription;
      lastTimeStamp = block.timestamp;
    }

    function checkUpkeep(bytes calldata) external override returns (bool upkeepNeeded, bytes memory ) {
        upkeepNeeded = (block.timestamp - lastTimeStamp) > frequency;
        return (upkeepNeeded, 0);
        // We don't use the checkData in this example. The checkData is defined when the Upkeep was registered.
    }

    function performUpkeep(bytes calldata) external override {
        lastTimeStamp = block.timestamp;
        // trigger refund
        subscription.trigger();
    }
}
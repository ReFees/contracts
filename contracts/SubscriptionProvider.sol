// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";

contract SubscriptionProvider is ERC721, ERC721Burnable {
    constructor() ERC721("SubscriptionProvider", "SPR") {}
}
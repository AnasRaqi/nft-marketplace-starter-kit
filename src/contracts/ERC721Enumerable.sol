// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ERC721Enumerable{


    uint256[] private _allTokens;
    function totalSupply () external view returns (uint256) {
        return _allTokens.length;
    }
}
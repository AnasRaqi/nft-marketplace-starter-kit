// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721.sol';
import './interfaces/IERC721Enuramble.sol';
contract ERC721Enumerable is IERC721Enumerable,ERC721{


    uint256[] private _allTokens;

    //mapping from tokenId to position in _alltoken array
    //mapping of owner to list of all owner token ids
    //mapping from token ID index of he owner tokens list 

    mapping (uint256=>uint256) private _allTokensIndex;
    mapping (address=>uint256[]) private _ownedTokens;
    mapping (uint256=>uint256) private _ownedTokensIndex;

    // Function that returns tokenbyindex
    // function that returns tokenofownerbyindex 


    constructor(){
        _registerInterface(bytes4(keccak256('totalSupply(bytes4') ^ keccak256('tokenByIndex(bytes4') ^ keccak256('tokenOfOwnerByIndex(bytes4')));
    }

    function totalSupply () public view returns (uint256) {
        return _allTokens.length;
    }

    function tokenByIndex (uint256 index) public override view returns(uint256){
        require(index < totalSupply(),'global index is out of bounds!!');
        return _allTokens[index];
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256){
        require(index < balanceOf(owner),'owner index is out of bounds!');
        return _ownedTokens[owner][index];
    }

    
    //add tokens to all tokens array and set the position to the token indexes
    function _addTokensToAllTokenEnumeration(uint256 tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);

    }

    function _addTokensOwnerEnumeration(address to, uint256 tokenId) private  {
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
        _ownedTokens[to].push(tokenId);

    }



    function _mint(address to, uint256 tokenId) internal override(ERC721) {
        super._mint(to,tokenId);
        //add tokens to the owner (function)
        //add tokens to our totalsupply (all tokens) (function)
        _addTokensToAllTokenEnumeration(tokenId);
        _addTokensOwnerEnumeration(to, tokenId);

    }
    

    



}
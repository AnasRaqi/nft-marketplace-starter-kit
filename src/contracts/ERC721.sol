// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
/*
    building out the miniting function 
        1. NFT to point to an address. 
        2. Keep track of the token IDs. 
        3. Keep track of token owner addresses to token ids. 
        4. keep track of how many tokens an owner address has. 
        5. create an event that emits a tranfer log - contract address, where it is minted to, the id. 
        
    */
contract ERC721 {

    event Trasnfer(address indexed from, address indexed to, uint256 indexed tokenId);


    // mapping creates a hash tabl of key pair values. 
    mapping(uint256 => address) private _tokenOwner;
    mapping(address => uint256) private _OwnedTokensCount;

    function balanceOf(address _owner) public view returns(uint256) {
        require(_owner != address(0),'token does not exist');
        return _OwnedTokensCount[_owner];
    }

    function ownerOf(uint256 _tokenId) external view returns(address){
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0),'token is not existing');
        return owner;
    }



    function _exists(uint256 tokenId) internal view returns(bool) {
        address owner = _tokenOwner[tokenId];
        return owner != address(0);
        
    }

    function _mint (address to, uint256 tokenId) internal {
        // requires that the address is not zero
        require(to != address(0), 'ERC721: minting to the zero address');
        // requires that the token is not already minted. 
        require(!_exists(tokenId),'ERC721: Token already minted');
        //adding new address with a token id for the mint
        _tokenOwner[tokenId] = to;
        // keeping track of each address that is minting and adding one(owned tokens) to the count. 
        _OwnedTokensCount[to] += 1;
        
        emit Trasnfer(address(0), to , tokenId);
    }

    



    
}
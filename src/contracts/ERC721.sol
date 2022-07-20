// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './interfaces/IERC165.sol';
import './ERC165.sol';
import './interfaces/IERC721.sol';
/*
    building out the miniting function 
        1. NFT to point to an address. 
        2. Keep track of the token IDs. 
        3. Keep track of token owner addresses to token ids. 
        4. keep track of how many tokens an owner address has. 
        5. create an event that emits a tranfer log - contract address, where it is minted to, the id. 
        
    */
contract ERC721 is ERC165, IERC721{

    //event Trasnfer(address indexed from, address indexed to, uint256 indexed tokenId);
    //event Approval (address indexed owner, address indexed approved, uint256 indexed tokenId); 
    // mapping creates a hash tabl of key pair values. 
    mapping(uint256 => address) private _tokenOwner;
    mapping(address => uint256) private _OwnedTokensCount;
    //mapping from tokenID to approved addressess
    mapping(uint256 => address) private _tokenApprovals;

    constructor(){
        _registerInterface(bytes4(keccak256('balanceOf(bytes4') ^ keccak256('ownerOf(bytes4') ^ keccak256('transferFrom(bytes4')));
    }

    function balanceOf(address _owner) public override view returns(uint256) {
        require(_owner != address(0),'token does not exist');
        return _OwnedTokensCount[_owner];
    }

    function ownerOf(uint256 _tokenId) public override view returns(address){
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0),'token is not existing');
        return owner;
    }



    function _exists(uint256 tokenId) internal view returns(bool) {
        address owner = _tokenOwner[tokenId];
        return owner != address(0);
        
    }

    function _mint (address to, uint256 tokenId) internal virtual{
        // requires that the address is not zero
        require(to != address(0), 'ERC721: minting to the zero address');
        // requires that the token is not already minted. 
        require(!_exists(tokenId),'ERC721: Token already minted');
        //adding new address with a token id for the mint
        _tokenOwner[tokenId] = to;
        // keeping track of each address that is minting and adding one(owned tokens) to the count. 
        _OwnedTokensCount[to] += 1;
        
        emit Transfer(address(0), to , tokenId);
    }

    // Transfer Function 

    function _transferFrom (address _from, address _to, uint256 _tokenId) internal{

        require(_to != address(0),'ERC721 - Transfer to the Zero Address');
        require(ownerOf(_tokenId) == _from,'Error: trying to transfer a token that the sender does not own');
        _OwnedTokensCount[_from] -= 1;
        _OwnedTokensCount[_to] += 1;
        _tokenOwner[_tokenId] = _to; 
        emit Transfer(_from, _to, _tokenId);
    }

    // we need to create a function to clear the NFT. 

    function transferFrom(address _from, address _to, uint256 _tokenId) override public {
        require(isApprovedOrOwner(msg.sender,_tokenId));
        _transferFrom(_from, _to, _tokenId);
    }
    //require that the person approving is the owner. 
    // approve an address to a tokenId
    // require that we can not approve sending tokens of the owner to the owner (current caller)
    // update the mapping of the approval addresses. 

    function approve (address _to, uint256 tokenId) public{
        address owner = ownerOf(tokenId);
        require(_to != owner,'Error, approval to current ownerr');
        require(msg.sender == owner, 'current caller is not the owner');
        _tokenApprovals[tokenId] = _to;

        emit Approval(owner, _to, tokenId);
    }

    function isApprovedOrOwner (address spender, uint256 tokenId) internal view returns(bool){
        require(_exists(tokenId),'token does not exist');
        address owner= ownerOf(tokenId);
        return (spender == owner);
    }



    
}
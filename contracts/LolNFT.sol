// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

// We need some util functions for strings.
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "hardhat/console.sol";


contract LolNFT is ERC721URIStorage, Ownable {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  uint256 public constant MAXSUPPLY = 2; // This NFT is deliberately a very limited release. Two will be premined.
  uint256 public cost = 1; // Owner can change update cost at any time.

  event NewLolNFTMinted(address sender, uint256 tokenId);
  event LolUpdatedURI(address sender, uint256 tokenId);
  event PayoutSent(address sender, uint256 amount);

  constructor() ERC721 ("LolNFT", "LOL") {
    console.log("Lolware.net NFT Project");
  }

  function buyURLUpdate(uint tokenId, string memory tokenURI) public payable {
    require(msg.value >= cost, "insufficient funds");

    _setTokenURI(tokenId, tokenURI);

    console.log("Updated the URI on token %s to %s", tokenId, tokenURI);
    emit LolUpdatedURI(msg.sender, tokenId);

  }
  
  function setCost(uint256 _newCost) public onlyOwner {
    cost = _newCost;
  }

  function makeALolNFT(string memory tokenURI) public {
    uint256 newItemId = _tokenIds.current();
    require(newItemId < MAXSUPPLY, "Exceeds maximum tokens"); // tokenIDs start at 0. 

    _safeMint(msg.sender, newItemId);
  
    _setTokenURI(newItemId, tokenURI);
  
    _tokenIds.increment();
    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
    emit NewLolNFTMinted(msg.sender, newItemId);
  }

  function payoutWallet() public onlyOwner {
    uint256 credit = address(this).balance;
    (bool success, ) = payable(msg.sender).call{value: credit}("");
    require(success, "Failed to send Ether");
    emit PayoutSent(msg.sender, credit);
  }

}

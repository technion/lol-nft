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

  uint256 public maxSupply = 5; // This NFT is deliberately a very limited release. Two will be premined.
  uint256 public cost = 1; // Owner can change update cost at any time.

  event NewLolNFTMinted(address sender, uint256 tokenId);
  event LolUpdatedURI(address sender, uint256 tokenId);

  constructor() ERC721 ("LolNFT", "LOL") {
    console.log("Lolware.net NFT Project");
  }

  function buyURLUpdate(uint tokenId, string memory tokenURI) public payable {
    require(msg.value >= cost, "insufficient funds");
    // Get all the JSON metadata in place and base64 encode it.
    string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "LolNFT", "description": "A hilarious meme.", "image": "',
                    tokenURI,
                    '"}'
                )
            )
        )
    );

    string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );

    _setTokenURI(tokenId, finalTokenUri);

    console.log("\n--------------------");
    console.log(finalTokenUri);
    console.log("--------------------\n");
  
    console.log("Updated the URI on token %s", tokenId);
    emit LolUpdatedURI(msg.sender, tokenId);

  }
  
  function setCost(uint256 _newCost) public onlyOwner {
    cost = _newCost;
  }

  function makeAnEpicNFT(string memory tokenURI) public {
    uint256 newItemId = _tokenIds.current();
    require(newItemId < maxSupply, "Maximum allowed amount of tokens already minted"); // tokenIDs start at 0. If newItemID is 5, it will be the sixth token

    // Get all the JSON metadata in place and base64 encode it.
    string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "LolNFT", "description": "A hilarious meme.", "image": "',
                    tokenURI,
                    '"}'
                )
            )
        )
    );

    string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );

    console.log("\n--------------------");
    console.log(finalTokenUri);
    console.log("--------------------\n");

    _safeMint(msg.sender, newItemId);
  
    _setTokenURI(newItemId, finalTokenUri);
  
    _tokenIds.increment();
    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
    emit NewLolNFTMinted(msg.sender, newItemId);
  }
}

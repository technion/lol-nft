# Lol NFT

An experimental project that creates an mutable NFT contract, allowing other users to buy the right to update the image.


```shell
npx solhint contracts/LolNFT.sol
npx hardhat run scripts/run.js
npx hardhat check
─$ npx hardhat run scripts/deploy.js --network rinkeby
Contract deployed to: 0xE96bf348Af0087fc3AdF380f89f7bEd8ffedeaea 
npx hardhat verify 0xE96bf348Af0087fc3AdF380f89f7bEd8ffedeaea --network rinkeby

```

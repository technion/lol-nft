# Lol NFT

An experimental project that creates an mutable NFT contract, allowing other users to buy the right to update the image.


```shell
npx solhint contracts/LolNFT.sol
npx hardhat run scripts/run.js
npx hardhat check
─$ npx hardhat run scripts/deploy.js --network rinkeby
Contract deployed to: 0x03628Ed1d3234c4dFe49517775b17C676B11c116
npx hardhat verify 0x03628Ed1d3234c4dFe49517775b17C676B11c116 --network rinkeby

```

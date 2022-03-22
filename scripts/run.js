const btoa = (text) => {
  // Fill for function only present in browser
  return Buffer.from(text, 'binary').toString('base64');
}

const encodeTokenURI = (uri) => {
  const metadata = {
    name: "LolNFT",
    description: "My hilarious meme",
    image: uri
  }
  return "data:application/json;base64," + btoa(JSON.stringify(metadata));
}

const main = async () => {
  const nftContractFactory = await hre.ethers.getContractFactory('LolNFT');

  const [deployer] = await hre.ethers.getSigners();
  console.log(
      "Deploying the contracts with the account:",
      await deployer.getAddress()
  );

  console.log("Account balance:", (await deployer.getBalance()).toString());

  const nftContract = await nftContractFactory.deploy();
  await nftContract.deployed();
  console.log("Contract deployed to:", nftContract.address);

  // Call the function.
  let txn = await nftContract.makeALolNFT(encodeTokenURI("https://i.imgur.com/OIyczFs.jpeg"));
  // Wait for it to be mined.
  await txn.wait();

  // Mint a second cat picture
  txn = await nftContract.makeALolNFT(encodeTokenURI("https://i.imgur.com/AD3MbBi.jpeg"));
  // Wait for it to be mined.
  await txn.wait();

  // Change the URL on the second token
  txn = await nftContract.buyURLUpdate(0, encodeTokenURI("https://i.imgur.com/utzTCyo.png"), { value: 4 }); 
  // Value: amount paid in wei
  await txn.wait();

  console.log("Account balance after buying change:", (await deployer.getBalance()).toString());
  // Payout wallet
  txn = await nftContract.payoutWallet();
  await txn.wait();

  console.log("Account balance after payout:", (await deployer.getBalance()).toString());
  try {
    txn = await nftContract.makeALolNFT("https://i.imgur.com/AD3MbBi.jpeg");
    await txn.wait();
    throw new Error("Should not have been able to generate this extra NFT");
  } catch (e) {
    console.log("Blocked excessive mint");
  }
  
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();


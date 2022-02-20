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
  let txn = await nftContract.makeAnEpicNFT("https://i.imgur.com/OIyczFs.jpeg");
  // Wait for it to be mined.
  await txn.wait();

  // Mint a second cat picture
  txn = await nftContract.makeAnEpicNFT("https://i.imgur.com/AD3MbBi.jpeg");
  // Wait for it to be mined.
  await txn.wait();

  // Change the URL on the second token
  txn = await nftContract.buyURLUpdate(0, "https://i.imgur.com/utzTCyo.png", { value: 4 }); // Value: amount paid in wei
  await txn.wait();

  /* Uncomment this block to exceed the minting limit for test purposes
  txn = await nftContract.makeAnEpicNFT("https://i.imgur.com/AD3MbBi.jpeg");
  // Wait for it to be mined.
  await txn.wait();
  txn = await nftContract.makeAnEpicNFT("https://i.imgur.com/AD3MbBi.jpeg");
  await txn.wait();
  txn = await nftContract.makeAnEpicNFT("https://i.imgur.com/AD3MbBi.jpeg");
  await txn.wait();
  txn = await nftContract.makeAnEpicNFT("https://i.imgur.com/AD3MbBi.jpeg");
  await txn.wait();
  */
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


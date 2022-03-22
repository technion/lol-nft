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


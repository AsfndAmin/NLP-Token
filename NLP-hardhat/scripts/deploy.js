
const { ethers } = require("hardhat");

async function main() {

  const signerAddress = "0xeA29891b492Bd2bb13ab2a57C35650762D2d38e4";
 
    const NLPToken = await hre.ethers.getContractFactory("NLPToken");
    const NLP = await NLPToken.deploy(signerAddress);
    await NLP.deployed();
    console.log("NLP deployed to:", NLP.address);
}




main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

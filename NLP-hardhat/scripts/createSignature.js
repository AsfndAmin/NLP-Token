const { ethers } = require('hardhat');

async function main() {
//To deploy the NLP contract first time   
//  const signerAddress = "0xeA29891b492Bd2bb13ab2a57C35650762D2d38e4"; 
//  const NLPToken = await hre.ethers.getContractFactory("NLPToken");
//  const NLP = await NLPToken.deploy(signerAddress);
//  await NLP.deployed();
//  console.log("ashmon deployed to:", NLP.address);

// To call the contract after providing contract address
    const NLPAddress = '0xb02251d0e73613a857e3119a04F1dd9399B5c643';
    const NLPToken = await ethers.getContractFactory('NLPToken');
    const NLP = await NLPToken.attach(NLPAddress);
    console.log("NLP address:", NLP.address);



//creating wallet instance by providing private key to sign the hash
    const PRIV_KEY = "a40289fe12e7209a24790db12ea43fa0bd58a0c5c0741e98fc7b271df7afd148"
    const signer = new ethers.Wallet(PRIV_KEY)

//values to create hash    
    const receiver = "0xeA29891b492Bd2bb13ab2a57C35650762D2d38e4";
    const deadline = 1673999999;
    //const signature

    const hash = await NLP.getMessageHash(receiver, deadline)
    const sig = await signer.signMessage(ethers.utils.arrayify(hash))
    console.log("new signature", sig);
        // Correct signature and message returns true

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
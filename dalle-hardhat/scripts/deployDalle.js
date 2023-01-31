const { ethers } = require("hardhat");

async function main() {

 
    const DalleInu = await hre.ethers.getContractFactory("DalleInu");
    const Token = await DalleInu.deploy();
    await Token.deployed();
    console.log("Dalle deployed to:", Token.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

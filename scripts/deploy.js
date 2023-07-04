const { ethers } = require("hardhat");

async function main() {
    const Crowdfunding = await ethers.getContractFactory("Crowdfunding");
    const crowdfunding = await Crowdfunding.deploy();

    await crowdfunding.deployed();

    console.log("Crowdfunding contract deployed to:", crowdfunding.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
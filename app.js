const Web3 = require("web3");

// Create a Web3 instance connected to the Celo network
const web3 = new Web3("<Celo-RPC-URL>");

// Set the default account to use for transactions
web3.eth.defaultAccount = "<your-account-address>";

// Load the contract ABI and address
const contractABI = require("./artifacts/contracts/Crowdfunding.sol/Crowdfunding.json")
    .abi;
const contractAddress = "<contract-address>";

// Create a contract instance
const crowdfundingContract = new web3.eth.Contract(
    contractABI,
    contractAddress
);

// Interact with the contract
async function interactWithContract() {
    const projectCount = await crowdfundingContract.methods.numProjects().call();
    console.log("Number of projects:", projectCount);

    const projectId = 0; // Assuming the first project
    const project = await crowdfundingContract.methods.projects(projectId).call();
    console.log("Project details:", project);

    await crowdfundingContract.methods
        .contribute(projectId)
        .send({ from: web3.eth.defaultAccount, value: 1000000000000000000 });

    console.log("Contribution successful");

    await crowdfundingContract.methods.claimReward(projectId).send({
        from: web3.eth.defaultAccount,
    });

    console.log("Reward claimed");
}

interactWithContract().catch(console.error);
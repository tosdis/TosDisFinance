const ERC20Basic = artifacts.require("ERC20Basic");
const FeeToken = artifacts.require("FeeToken");
const StakeMaster = artifacts.require("StakeMaster");
const StakingPool = artifacts.require("StakingPool");

const totalSupply = "10000000000000000000000"; // 10000
const poolTokenSupply = "100000000000000000000"; // 100
const stakeAmount = "10000000000000000000"; // 10
const feeAmount = "10000000000000000000"; // 10
const burnPercent = "1";
const poolDurationInBlocks = 2000;

let feeToken;
let stakingToken;
let poolToken;
let stakeMaster;
let stakingPool;

module.exports = async (deployer, network, accounts) => {
    //0x29e417721e6b4ed4b3f0ec982f26f5f153c2e52b
    await deployer.deploy(FeeToken, totalSupply, "Dis Token", "DIS");
    feeToken = await FeeToken.deployed();
    //feeToken = await FeeToken.at("0x29e417721e6b4ed4b3f0ec982f26f5f153c2e52b"); 
    console.log("Fee Token address ====> " + feeToken.address);

    //await deployer.deploy(ERC20Basic, totalSupply, {from: accounts[2]});
    //stakingToken = await ERC20Basic.deployed();
    //console.log("Staking Token address ====> " + stakingToken.address);

    //await deployer.deploy(ERC20Basic, totalSupply);
    //poolToken = await ERC20Basic.deployed();
    //console.log("Pool(Reward) Token address ====> " + poolToken.address);

    await deployer.deploy(StakeMaster, feeToken.address, accounts[1], feeAmount, burnPercent);
    stakeMaster = await StakeMaster.deployed();
    console.log("Stake Master address ====> " + stakeMaster.address);

    //Deploy StakingPool to varify on etherscan
    await feeToken.approve(stakeMaster.address, totalSupply);
    //await poolToken.approve(stakeMaster.address, poolTokenSupply);

    let startBlock = (await web3.eth.getBlock('latest')).number + 10000;
    let finishBlock = startBlock + poolDurationInBlocks;

    await deployer.deploy(StakingPool, feeToken.address, feeToken.address, startBlock, finishBlock, poolTokenSupply);
    stakingPool = await StakingPool.deployed();
    console.log("StakingPool address ====> " + stakingPool.address);

    //await feeToken.approve(stakeMaster.address, totalSupply);
    //await poolToken.approve(stakeMaster.address, poolTokenSupply);

    //let startBlock = (await web3.eth.getBlock('latest')).number;
    //let finishBlock = startBlock + poolDurationInBlocks;

    //let tx = await stakeMaster.createStakingPool(stakingToken.address, poolToken.address, startBlock, finishBlock, poolTokenSupply);

    //console.log("Staking Pool owner address ===> " + tx.logs[tx.logs.length-1].args.owner);
    //console.log("Staking Pool address ===> " + tx.logs[tx.logs.length-1].args.pool);

    //stakingPool = await StakingPool.at(tx.logs[tx.logs.length-1].args.pool);

    //await stakingToken.approve(stakingPool.address, totalSupply, {from: accounts[2]});
    //await stakingPool.stakeTokens(stakeAmount, {from: accounts[2]});

    //console.log("Wallet " + accounts[2] + " staked " + web3.utils.fromWei(stakeAmount) + " tokens in Staking Pool with address ===> " + stakingPool.address);

    //let reward = await stakingPool.pendingReward(accounts[2]);
    //console.log("Reward of the wallet " + accounts[2] + " in Staking Pool with address ===> " + stakingPool.address + " = " + reward.toNumber());
};

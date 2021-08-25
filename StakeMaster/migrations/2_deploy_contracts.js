const ERC20Basic = artifacts.require("ERC20Basic");
const FeeToken = artifacts.require("FeeToken");
const StakeMaster = artifacts.require("StakeMaster");
const StakingPool = artifacts.require("StakingPool");
const IDOMaster = artifacts.require("IDOMaster");
const IDOCreator = artifacts.require("IDOCreator");
const IDOPool = artifacts.require("IDOPool");
const TierSystem = artifacts.require("TierSystem");
const { toWei, fromWei, toBN } = web3.utils;

let idoMasterContract;

const totalSupply = toWei("10000");
const poolTokenSupply = toWei("1");
const stakeAmount = toWei("10");
const feeAmount = toWei("10");
//const burnPercent = "0";
const poolDurationInSecunds = 900;

////ETH PROD
//const feeWallet = "0xa7cb5b0ca559f8aaa14f09aae1eec3e71d0ab16a";
//const feeToken = "0x220b71671b649c03714da9c621285943f3cbcdc6";
//const burnPercent = "45";


//BSC PROD
//const feeWallet = "0xa7cb5b0ca559f8aaa14f09aae1eec3e71d0ab16a";
//const feeToken = "0x57effde2759b68d86c544e88f7977e3314144859";
//const burnPercent = "0";

//Fantom PROD
const feeWallet = "0xa7cb5b0ca559f8aaa14f09aae1eec3e71d0ab16a";
const feeToken = "0x0e121961DD741C9D49C9A04379da944A9D2FAc7a";
const burnPercent = "0";

////KOVAN testnet
//const feeWallet = "0x819243B25cbFD8a852741b1984e39596349370E4";
//const feeToken = "0x29e417721e6b4ed4b3f0ec982f26f5f153c2e52b";


//Test Fantom
//const feeWallet = "0x15ff3ad8d89DCc8d4186FbF076689b4476111520";
//const feeToken = "0xdc1c222b5ace804b10b0ac11bea13c113deba826";
//const burnPercent = "0";


module.exports = async (deployer, network, accounts) => {
    
    ////ERC20Burnable _feeToken,
    ////    address _feeWallet,
    ////        uint256 _feeAmount,
    ////            uint256 _burnPercent
    //await deployer.deploy(StakeMaster, feeToken, feeWallet, feeAmount, burnPercent);
    //stakeMaster = await StakeMaster.deployed();
    //console.log("Stake Master address ====> " + stakeMaster.address);

    //let startTime = Math.floor(Date.now() / 1000) + 600;
    //let finishTime = startTime + poolDurationInSecunds;
    //await deployer.deploy(StakingPool, feeToken, feeToken, startTime, finishTime, poolTokenSupply, true);
    //stakingPool = await StakingPool.deployed();
    //console.log("StakingPool address ====> " + stakingPool.address);

    //console.log("approving for stakingPool");
    //await feeTokenContract.approve(stakingPool.address, totalSupply);
    //console.log("trying extendDuration");
    //await stakingPool.extendDuration(poolTokenSupply);
    //console.log("extendDuration");
    
};

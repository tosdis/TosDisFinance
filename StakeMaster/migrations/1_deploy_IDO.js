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


//TestBSC
//const feeToken = "0xce01c35b316ccdf43eb3a5f73aa597d519637a28";

//Test Fantom
//const feeWallet = "0x15ff3ad8d89DCc8d4186FbF076689b4476111520";
//const feeToken = "0xdc1c222b5ace804b10b0ac11bea13c113deba826";
//const burnPercent = "0";

module.exports = async (deployer, network, accounts) => {
    
    //let feeTokenContract = await FeeToken.at(feeToken); 

    //uint256 _vipDisAmount,
    //    uint256 _vipPercent,
    //        uint256 _holdersDisAmount,
    //            uint256 _holdersPercent,
    //                uint256 _publicDisAmount,
    //                    uint256 _publicPercent
    ////_vipDisAmount, _vipPercent, _holdersDisAmount, _holdersPercent, _publicDisAmount, _publicPercent
    await deployer.deploy(TierSystem, toWei("100"), "100", toWei("10"), "100", toWei("0"), "100");
    let tierSystemContract = await TierSystem.deployed();
    console.log("TierSystem address ====> " + tierSystemContract.address);

    await deployer.deploy(IDOMaster, feeToken, feeWallet, feeAmount, burnPercent);
    let idoMasterContract = await IDOMaster.deployed();
    console.log("IDO master address ====> " + idoMasterContract.address);

    await deployer.deploy(IDOCreator, idoMasterContract.address, tierSystemContract.address);
    let idoCreatorContract = await IDOCreator.deployed();
    console.log("IDO creator address ====> " + idoCreatorContract.address);

    await idoMasterContract.setCreatorProxy(idoCreatorContract.address);
    console.log("set setCreatorProxy ====> " + idoCreatorContract.address);

    /*
    //next to testnet verify
    var _feeFundsPercent = 10;
    var _tokenPrice = toWei("0.065");
    var _rewardToken = feeToken;
    var _startTimestamp = Math.floor(Date.now() / 1000) + 600;
    var _finishTimestamp = Math.floor(Date.now() / 1000) + 3600;
    var _startClaimTimestamp = Math.floor(Date.now() / 1000) + 3900;
    var _minEthPayment = toWei("0.01");
    var _maxEthPayment = toWei("0.1");
    var _maxDistributedTokenAmount = toWei("10");
    var _hasWhitelisting = true;
    var _enableTierSystem = true;

    await deployer.deploy(IDOPool,
       idoMasterContract.address,
       _feeFundsPercent,
       _tokenPrice,
       _rewardToken,
       _startTimestamp,
       _finishTimestamp,
       _startClaimTimestamp,
       _minEthPayment,
       _maxEthPayment,
       _maxDistributedTokenAmount,
       _hasWhitelisting,
       _enableTierSystem,
       tierSystemContract.address
    );

    idoPoolContract = await IDOPool.deployed();
    console.log("IDO pool address ====> " + idoPoolContract.address);*/
};

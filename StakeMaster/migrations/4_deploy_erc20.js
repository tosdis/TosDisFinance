const ERC20Decimal = artifacts.require("ERC20Decimal");


let usdtToken;
let uniToken;
const totalSupplyUSDT = "10000000000"; // 10000
const totalSupplyUni = "10000000000000000000000"; // 10000

module.exports = async function (deployer, network, accounts) {
    //await deployer.deploy(ERC20Decimal, totalSupplyUSDT, "USDT test", "USDT", 6);
    //usdtToken = await ERC20Decimal.deployed();
    //console.log("USDT Token address ====> " + usdtToken.address);


    //await deployer.deploy(ERC20Decimal, totalSupplyUni, "UNI-V2", "UNI-V2", 18);
    //uniToken = await ERC20Decimal.deployed();
    //console.log("uni Token address ====> " + uniToken.address);
};

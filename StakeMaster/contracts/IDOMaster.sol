pragma solidity 0.6.12;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Burnable.sol";
// import "./IDOPool.sol";
import "./interfaces/IidoMaster.sol";
// import "./interfaces/IStakingPool.sol";
// import "./interfaces/IUniswapV2Pair.sol";
// import "./interfaces/IidoCreator.sol";

contract IDOMaster is IidoMaster, Ownable{
    using SafeMath for uint256;
    using SafeERC20 for ERC20Burnable;
    using SafeERC20 for ERC20;

    ERC20Burnable public override feeToken;
    address payable public override feeWallet;
    address public creatorProxy;
    uint256 public override feeAmount;
    uint256 public override burnPercent;
    uint256 public override divider;

    uint256 public override feeFundsPercent = 0; /* Default Fee 0% */

    // IStakingPool public disStakingPool;
    // IStakingPool public lpDisStakingPool;
    // IUniswapV2Pair public lpUniswapV2Pair;
    // bool public disReserve0;

    // TierInfo public vipTier;
    // TierInfo public holdersTier;
    // TierInfo public publicTier;

    // struct TierInfo {
    //     uint256 disAmount;     
    //     uint256 percent; 
    // }

    mapping(address => IDOInfo) public idoInfo;

    struct IDOInfo {
        uint256 tokenPrice;
        address payableToken;
        address payToken;
        address rewardToken;
        uint256 startTimestamp;
        uint256 finishTimestamp;
        uint256 startClaimTimestamp;
        uint256 minEthPayment;
        uint256 maxEthPayment;
        uint256 maxDistributedTokenAmount;
    }


    event IDOCreated(address idoPool, 
        uint256 tokenPrice, 
        address payableToken,
        address rewardToken,
        uint256 startTimestamp,
        uint256 finishTimestamp,
        uint256 startClaimTimestamp,
        uint256 minEthPayment,
        uint256 maxEthPayment,
        uint256 maxDistributedTokenAmount);

    event CreatorUpdated(address idoCreator);
    event TokenFeeUpdated(address newFeeToken);
    event FeeAmountUpdated(uint256 newFeeAmount);
    event BurnPercentUpdated(uint256 newBurnPercent, uint256 divider);
    event FeeWalletUpdated(address newFeeWallet);

    constructor(
        ERC20Burnable _feeToken,
        address payable _feeWallet,
        uint256 _feeAmount,
        uint256 _burnPercent
    ) public {
        feeToken = _feeToken;
        feeAmount = _feeAmount;
        feeWallet = _feeWallet;
        burnPercent = _burnPercent;
        divider = 100;
    }

    function setFeeToken(address _newFeeToken) external onlyOwner {
        require(isContract(_newFeeToken), "New address is not a token");
        feeToken = ERC20Burnable(_newFeeToken);

        emit TokenFeeUpdated(_newFeeToken);
    }

    function setFeeAmount(uint256 _newFeeAmount) external onlyOwner {
        feeAmount = _newFeeAmount;

        emit FeeAmountUpdated(_newFeeAmount);
    }

    function setFeeWallet(address payable _newFeeWallet) external onlyOwner {
        feeWallet = _newFeeWallet;

        emit FeeWalletUpdated(_newFeeWallet);
    }

    function setBurnPercent(uint256 _newBurnPercent, uint256 _newDivider)
        external
        onlyOwner
    {
        require(_newBurnPercent <= _newDivider, "Burn percent must be less than divider");
        burnPercent = _newBurnPercent;
        divider = _newDivider;

        emit BurnPercentUpdated(_newBurnPercent, _newDivider);
    }


    function setFeeFundsPercent(uint256 _feeFundsPercent)
        external
        onlyOwner
    {
        // require(_feeFundsPercent >= feePercentage, "Fee Percentage has to be >= 1");
        require(_feeFundsPercent <= 99, "Fee Percentage has to be < 100");
        feeFundsPercent = _feeFundsPercent;
    }

    // function setTierPools(IStakingPool _disStakingPool, IStakingPool _lpDisStakingPool, IUniswapV2Pair _lpUniswapV2Pair, bool _disReserve0) external onlyOwner {
    //     disStakingPool = _disStakingPool;
    //     lpDisStakingPool = _lpDisStakingPool;
    //     lpUniswapV2Pair = _lpUniswapV2Pair;
    //     disReserve0 = _disReserve0;

    //      //check addresses
    //     getFullDisBalance(msg.sender);
    // }

    // function setTier(uint256 _vipDisAmount, uint256 _vipPercent, uint256 _holdersDisAmount, uint256 _holdersPercent, uint256 _publicDisAmount, uint256 _publicPercent) external onlyOwner {
    //     vipTier.disAmount = _vipDisAmount;
    //     vipTier.percent = _vipPercent;

    //     holdersTier.disAmount = _holdersDisAmount;
    //     holdersTier.percent = _holdersPercent;

    //     publicTier.disAmount = _publicDisAmount;
    //     publicTier.percent = _publicPercent;
    // }


    function setCreatorProxy(address _creator) external onlyOwner {
        require(isContract(_creator), "Error address");
        creatorProxy = _creator;
        emit CreatorUpdated(creatorProxy);
    }

    function registrateIDO(
        address _poolAddress,
        uint256 _tokenPrice,
        address _payableToken,
        address _rewardToken,
        uint256 _startTimestamp,
        uint256 _finishTimestamp,
        uint256 _startClaimTimestamp,
        uint256 _minEthPayment,
        uint256 _maxEthPayment,
        uint256 _maxDistributedTokenAmount
    ) external override {

    require(msg.sender ==  creatorProxy, "registrateIDO: bad role");

    IDOInfo storage info = idoInfo[_poolAddress];
    info.tokenPrice = _tokenPrice;
    info.payableToken = _payableToken;
    info.rewardToken = _rewardToken;
    info.startTimestamp = _startTimestamp;
    info.finishTimestamp = _finishTimestamp;
    info.startClaimTimestamp = _startClaimTimestamp;
    info.minEthPayment = _minEthPayment;
    info.maxEthPayment = _maxEthPayment;
    info.maxDistributedTokenAmount = _maxDistributedTokenAmount;

    emit IDOCreated(_poolAddress,
            _tokenPrice,
            _payableToken,
            _rewardToken,
            _startTimestamp,
            _finishTimestamp,
            _startClaimTimestamp,
            _minEthPayment,
            _maxEthPayment,
            _maxDistributedTokenAmount);
    }

    function isContract(address _addr) private view returns (bool) {
        uint32 size;
        assembly {
            size := extcodesize(_addr)
        }
        return (size > 0);
    }

    //  function getMaxEthPayment(address user, uint256 maxEthPayment)
    //     public
    //     view
    //     override
    //     returns (uint256)
    // {
    //    uint256 _disBalance =  getFullDisBalance(user);
    //     if(_disBalance>=vipTier.disAmount){
    //        return maxEthPayment.mul(vipTier.percent).div(100);
    //     }
    //     if(_disBalance>=holdersTier.disAmount){
    //        return maxEthPayment.mul(holdersTier.percent).div(100);
    //     }
    //     if(_disBalance>=publicTier.disAmount){
    //        return maxEthPayment.mul(publicTier.percent).div(100);
    //     }
    //     return 0;
    // }

    // function getFullDisBalance(address user)
    //     public
    //     view     
    //     override   
    //     returns (uint256)
    // {
    //     uint256 _disBalance = feeToken.balanceOf(user);
    //     if(address(disStakingPool) != address(0)){
    //         (uint256 _stakedAmount, ) = disStakingPool.getUserInfo(user);
    //         _disBalance += _stakedAmount;
    //     }
    //     if(address(lpDisStakingPool) != address(0)){
    //             (uint256 _lpBalance, ) = lpDisStakingPool.getUserInfo(user);
    //             if(_lpBalance > 0) {
    //                 (uint256 _reserve0, uint256 _reserve1, ) = lpUniswapV2Pair.getReserves();
    //                 uint256 totalSupply = lpUniswapV2Pair.totalSupply();
    //                 //_reserve0 is dis
    //                 if(disReserve0){
    //                     _disBalance += _lpBalance.mul(_reserve0).div(totalSupply);
    //                 }
    //                 else{
    //                     _disBalance += _lpBalance.mul(_reserve1).div(totalSupply); 
    //                 }
    //             }
    //     }
    //     return _disBalance;
    // }
}
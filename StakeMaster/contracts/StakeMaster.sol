pragma solidity 0.6.12;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./StakingPool.sol";

// import "@openzeppelin/contracts/math/SafeERC20.sol";
// import "@openzeppelin/contracts/token/ERC20/ERC20Burnable.sol";

contract StakeMaster is Ownable {
    using SafeMath for uint256;
    using SafeERC20 for ERC20Burnable;

    ERC20Burnable public feeToken;
    address public feeWallet;
    uint256 public feeAmount;
    uint256 public burnPercent;
    uint256 public divider;

    event StakingPoolCreated(address owner, address pool);
    event TokenFeeUpdated(address newFeeToken);
    event FeeAmountUpdated(uint256 newFeeAmount);
    event BurnPercentUpdated(uint256 newBurnPercent);
    event FeeWalletUpdated(address newFeeWallet);

    constructor(
        address _feeToken,
        address _feeWallet,
        uint256 _feeAmount,
        uint256 _burnPercent
    ) public {
        feeToken = ERC20Burnable(_feeToken);
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

    function setFeeWallet(address _newFeeWallet) external onlyOwner {
        feeWallet = _newFeeWallet;

        emit FeeWalletUpdated(_newFeeWallet);
    }

    function setBurnPercent(uint256 _newBurnPercent, uint256 _newDivider)
        external
        onlyOwner
    {
        burnPercent = _newBurnPercent;
        divider = _newDivider;

        emit BurnPercentUpdated(_newBurnPercent);
    }

    function createStakingPool(
        address _stakingToken,
        address _poolToken,
        uint256 _startDate,
        uint256 _finishDate,
        uint256 _poolTokenAmount
    ) external {
        uint256 burnAmount = feeAmount.mul(burnPercent).div(divider);

        feeToken.safeTransferFrom(
            msg.sender,
            feeWallet,
            feeAmount.sub(burnAmount)
        );
        feeToken.safeTransferFrom(msg.sender, address(this), burnAmount);
        feeToken.burn(burnAmount);

        StakingPool stakingPool =
            new StakingPool(
                _stakingToken,
                _poolToken,
                _startDate,
                _finishDate,
                _poolTokenAmount
            );
        stakingPool.transferOwnership(msg.sender);

        ERC20Burnable(_poolToken).safeTransferFrom(
            msg.sender,
            address(stakingPool),
            _poolTokenAmount
        );

        emit StakingPoolCreated(msg.sender, address(stakingPool));
    }

    function isContract(address _addr) private view returns (bool) {
        uint32 size;
        assembly {
            size := extcodesize(_addr)
        }
        return (size > 0);
    }
}

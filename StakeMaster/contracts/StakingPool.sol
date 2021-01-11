pragma solidity 0.6.12;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract StakingPool is Ownable, ReentrancyGuard {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    IERC20 public stakingToken;
    IERC20 public rewardToken;
    uint256 public startBlock;
    uint256 public lastRewardBlock;
    uint256 public finishBlock;
    uint256 public totalShares;
    uint256 public rewardPerBlock;
    uint256 public accTokensPerShare; // Accumulated tokens per share

    mapping(address => uint256) public stakes;
    mapping(address => uint256) public rewardDebts;

    event FinishBlockUpdated(uint256 _newFinishBlock);
    event PoolReplenished(uint256 amount);
    event TokensStaked(
        address stakeholder,
        uint256 amount,
        uint256 sharesAchived
    );
    event StakeWithdrawn(address stakeholder, uint256 amount, uint256 reward);
    event EmergencyWithdraw(address indexed user, uint256 amount);

    constructor(
        address _stakingToken,
        address _poolToken,
        uint256 _startBlock,
        uint256 _finishBlock,
        uint256 _poolTokenAmount
    ) public {
        stakingToken = IERC20(_stakingToken);
        rewardToken = IERC20(_poolToken);
        require(
            _startBlock < _finishBlock,
            "start block must be less than finish block"
        );
        require(
            _finishBlock > block.number,
            "finish block must be more than current block"
        );
        startBlock = _startBlock;
        lastRewardBlock = startBlock;
        finishBlock = _finishBlock;
        rewardPerBlock = _poolTokenAmount.div(_finishBlock.sub(_startBlock));
    }

    function getMultiplier(uint256 _from, uint256 _to)
        internal
        view
        returns (uint256)
    {
        if (_to <= finishBlock) {
            return _to.sub(_from);
        } else if (_from >= finishBlock) {
            return 0;
        } else {
            return finishBlock.sub(_from);
        }
    }

    // View function to see pending Reward on frontend.
    function pendingReward(address _user) external view returns (uint256) {
        uint256 lpSupply = stakingToken.balanceOf(address(this));
        uint256 tempAccTokensPerShare = accTokensPerShare;
        if (block.number > lastRewardBlock && lpSupply != 0) {
            uint256 multiplier = getMultiplier(lastRewardBlock, block.number);
            uint256 reward = multiplier.mul(rewardPerBlock);
            tempAccTokensPerShare = accTokensPerShare.add(
                reward.mul(1e12).div(lpSupply)
            );
        }
        return
            stakes[_user].mul(tempAccTokensPerShare).div(1e12).sub(
                rewardDebts[_user]
            );
    }

    // Update reward variables of the given pool to be up-to-date.
    function updatePool() public {
        if (block.number <= lastRewardBlock) {
            return;
        }
        uint256 stakingSupply = stakingToken.balanceOf(address(this));
        if (stakingSupply == 0) {
            lastRewardBlock = block.number;
            return;
        }

        uint256 multiplier = getMultiplier(lastRewardBlock, block.number);
        uint256 reward = multiplier.mul(rewardPerBlock);
        accTokensPerShare = accTokensPerShare.add(
            reward.mul(1e12).div(stakingSupply)
        );
        lastRewardBlock = block.number;
    }

    function stakeTokens(uint256 _amountToStake) public {
        updatePool();
        uint256 pending = 0;
        if (stakes[msg.sender] > 0) {
            pending = calculatePending();
        }

        if (_amountToStake > 0) {
            stakingToken.safeTransferFrom(
                address(msg.sender),
                address(this),
                _amountToStake
            );
            stakes[msg.sender] = stakes[msg.sender].add(_amountToStake);
        }

        rewardDebts[msg.sender] = stakes[msg.sender].mul(accTokensPerShare).div(
            1e12
        );

        emit TokensStaked(msg.sender, _amountToStake, pending);
    }

    // Leave the pool. Claim back your tokens.
    // Unclocks the staked + gained tokens and burns pool shares
    function withdrawStake(uint256 _stakeAmount) public nonReentrant {
        require(stakes[msg.sender] >= _stakeAmount, "withdraw: not good");
        updatePool();
        uint256 pending = calculatePending();

        if (_stakeAmount > 0) {
            stakes[msg.sender] = stakes[msg.sender].sub(_stakeAmount);
            stakingToken.safeTransfer(address(msg.sender), _stakeAmount);
        }

        rewardDebts[msg.sender] = stakes[msg.sender].mul(accTokensPerShare).div(
            1e12
        );

        emit StakeWithdrawn(msg.sender, _stakeAmount, pending);
    }

    function calculatePending() private returns (uint256) {
        uint256 pending =
            stakes[msg.sender].mul(accTokensPerShare).div(1e12).sub(
                rewardDebts[msg.sender]
            );

        if (pending > 0) {
            rewardToken.safeTransfer(address(msg.sender), pending);
        }

        return pending;
    }

    // Withdraw without caring about rewards. EMERGENCY ONLY.
    function emergencyWithdraw() public {
        stakingToken.safeTransfer(address(msg.sender), stakes[msg.sender]);
        emit EmergencyWithdraw(msg.sender, stakes[msg.sender]);

        stakes[msg.sender] = 0;
        rewardDebts[msg.sender] = 0;
    }

    // Withdraw reward. EMERGENCY ONLY.
    function emergencyRewardWithdraw(uint256 _amount) public onlyOwner {
        require(
            _amount <= rewardToken.balanceOf(address(this)),
            "not enough token"
        );
        rewardToken.safeTransfer(address(msg.sender), _amount);
    }

    function setFinishBlock(uint256 _newFinishBlock) external onlyOwner {
        require(
            _newFinishBlock > finishBlock,
            "New finish block must be more then current"
        );
        finishBlock = _newFinishBlock;
        rewardPerBlock = rewardToken.balanceOf(address(this)).div(
            finishBlock.sub(lastRewardBlock)
        );

        emit FinishBlockUpdated(_newFinishBlock);
    }

    function topUpStakingPool(uint256 _topUpAmount) external onlyOwner {
        rewardToken.safeTransferFrom(msg.sender, address(this), _topUpAmount);
        rewardPerBlock = rewardToken.balanceOf(address(this)).div(
            finishBlock.sub(lastRewardBlock)
        );

        emit PoolReplenished(_topUpAmount);
    }
}

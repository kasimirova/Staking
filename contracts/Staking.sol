//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Staking {
    struct userInfo{
        uint256 amountofStakedLPTokens;
        uint256 timeOfStake;
        uint256 rewardDebt;
        bool isRewardReceived;
    }

    mapping (address => userInfo) public user;
    address ownerAddress;
    address lpToken;
    address rewardToken;
    uint256 freezingTimeForLP;
    uint256 rewardTime;
    uint8 percent;

    constructor(address _lpToken, address _rewardToken, uint256 _freezingTimeForLP, uint256 _rewardTime, uint8 _percent) {
        ownerAddress = msg.sender;
        lpToken = _lpToken;
        rewardToken = _rewardToken;
        freezingTimeForLP = _freezingTimeForLP;
        rewardTime = _rewardTime;
        percent = _percent;
    }

    modifier onlyOwner(){
        require(msg.sender == ownerAddress, "Sender is not an owner");
        _;
    }

    function stake(uint256 amount) external{
        if (user[msg.sender].amountofStakedLPTokens > 0){
            user[msg.sender].rewardDebt+=countReward(msg.sender);
        }
        user[msg.sender].amountofStakedLPTokens+=amount;
        user[msg.sender].timeOfStake = block.timestamp;
        user[msg.sender].isRewardReceived = false;
        IERC20(lpToken).transferFrom(msg.sender, address(this), amount);
    }

    function claim() external{
        IERC20(rewardToken).transfer(msg.sender, countReward(msg.sender)+user[msg.sender].rewardDebt);
        user[msg.sender].isRewardReceived=true;
        user[msg.sender].rewardDebt=0;
    }

    function unstake() external{
        require(block.timestamp - user[msg.sender].timeOfStake >= freezingTimeForLP, "It's too soon to unstake");
        IERC20(lpToken).transfer(msg.sender, user[msg.sender].amountofStakedLPTokens);
        if (!user[msg.sender].isRewardReceived){ 
            user[msg.sender].rewardDebt+=countReward(msg.sender);
        }      
        user[msg.sender].amountofStakedLPTokens = 0;
    }
    
    function countReward(address _user) public view returns(uint256) {
        return (block.timestamp - user[_user].timeOfStake)/rewardTime * user[_user].amountofStakedLPTokens/100*percent;
    }

    function setRewardTime(uint256 newRewardTime) public onlyOwner{
        rewardTime = newRewardTime;
    }

    function setRewardPercent(uint8 newRewardPercent) public onlyOwner{
        percent = newRewardPercent;
    }

    function setFreezingTimeForLP(uint256 newFreezingTime) public onlyOwner{
        freezingTimeForLP = newFreezingTime;
    }

    function getRewardDebt(address _user) public view returns(uint256) {
        return user[_user].rewardDebt;
    }

    function getAmountofStakedTokens(address _user) public view returns(uint256) {
        return user[_user].amountofStakedLPTokens;
    }

}

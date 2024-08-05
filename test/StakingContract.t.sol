 //SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/RewardToken.sol";
import "../src/StakingContract.sol";
import "../src/StakingToken.sol";

contract TestStakingContract is Test{
              RewardToken rewardToken;  
              StakingContract stakingContract;
              StakingToken stakingToken;

              address private user1 = address(0x123);

              function setUp() public {
                            stakingToken = new StakingToken(1000*1e18);
                            rewardToken = new RewardToken(1000*1e18);
                           stakingContract = new StakingContract(
                            address(stakingToken),
                            address(rewardToken),1e18);

                            stakingToken.transfer(user1,100 * 1e18);
                            rewardToken.transfer(user1,100 * 1e18);

              }
              function testStake () public {
                            vm.startPrank(user1);

                            stakingToken.approve(address(stakingContract) , 50 * 1e18);
                            stakingContract.stake(50 * 1e18);

                            assertEq(stakingContract.balanceOf(user1),50 * 1e18);
                            assertEq(stakingToken.balanceOf(user1),50 * 1e18);
                            vm.stopPrank();
              }

              function testWithdraw() public {
                            vm.startPrank(user1);

                            stakingToken.approve(address(stakingContract),50 * 1e18);
                            stakingContract.stake(50 * 1e18);

                            stakingContract.withdraw(50 * 1e18);

                            assertEq(stakingContract.balanceOf(user1), 0);
                            assertEq(stakingToken.balanceOf(user1), 100 * 1e18);
                            vm.stopPrank();
              }
              function testGetReward() public{
                            vm.startPrank(user1);

                            stakingToken.approve(address(stakingContract), 50 * 1e18);
                            stakingContract.stake(50 * 1e18);

                            stakingContract.getReward();
                            assertGt(rewardToken.balanceOf(user1), 0);

                            vm.stopPrank();
              }
              function testRewardPerTokenInitial() public
{
              uint256 rewardPerToken = stakingContract.rewardPerToken();
              assertEq(rewardPerToken, 0,"Initial rewardPerToken should be zero when no tokens are staked");
}
             function testRewardPerTokenAfterStaking() public {
             vm.startPrank(user1);

       
        stakingToken.approve(address(stakingContract), 50 * 1e18);
        stakingContract.stake(50 * 1e18);

        uint256 expectedRewardPerToken = stakingContract.rewardPerToken();
        
        uint256 actualRewardPerToken = stakingContract.rewardPerToken();
        assertEq(actualRewardPerToken, expectedRewardPerToken, "Reward per token should be correctly calculated after staking");
        
        vm.stopPrank();
    }


}

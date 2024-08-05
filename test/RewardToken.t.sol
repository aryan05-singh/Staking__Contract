// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/RewardToken.sol";
import "../src/StakingToken.sol";

contract TestTokens is Test {
    RewardToken private rewardToken;
    StakingToken private stakingToken;

    address private user1 = address(0x123);
    address private user2 = address(0x456);

    function setUp() public {
        rewardToken = new RewardToken(1000 * 1e18);
        stakingToken = new StakingToken(1000 * 1e18);

        rewardToken.transfer(user1, 500 * 1e18);
        stakingToken.transfer(user1, 500 * 1e18);
    }

    function testInitialSupply() public {
        assertEq(rewardToken.balanceOf(address(this)), 500 * 1e18);
        assertEq(stakingToken.balanceOf(address(this)), 500 * 1e18);
    }

    function testTransfer() public {
        vm.startPrank(user1);

        uint256 initialUser1RewardBalance = rewardToken.balanceOf(user1);
        uint256 initialUser1StakingBalance = stakingToken.balanceOf(user1);

        rewardToken.transfer(user2, 100 * 1e18);
        stakingToken.transfer(user2, 100 * 1e18);

        assertEq(rewardToken.balanceOf(user1), initialUser1RewardBalance - 100 * 1e18);
        assertEq(rewardToken.balanceOf(user2), 100 * 1e18);
        assertEq(stakingToken.balanceOf(user1), initialUser1StakingBalance - 100 * 1e18);
        assertEq(stakingToken.balanceOf(user2), 100 * 1e18);

        vm.stopPrank();
    }

    function testApproveAndTransferFrom() public {
        vm.startPrank(user1);

        rewardToken.approve(address(this), 100 * 1e18);
        stakingToken.approve(address(this), 100 * 1e18);

        assertEq(rewardToken.allowance(user1, address(this)), 100 * 1e18);
        assertEq(stakingToken.allowance(user1, address(this)), 100 * 1e18);

        vm.stopPrank();

        vm.startPrank(address(this));

        rewardToken.transferFrom(user1, user2, 100 * 1e18);
        stakingToken.transferFrom(user1, user2, 100 * 1e18);

        assertEq(rewardToken.balanceOf(user1), 400 * 1e18);
        assertEq(rewardToken.balanceOf(user2), 100 * 1e18);
        assertEq(stakingToken.balanceOf(user1), 400 * 1e18);
        assertEq(stakingToken.balanceOf(user2), 100 * 1e18);

        vm.stopPrank();
    }

    function testZeroTransfer() public {
        vm.startPrank(user1);

        uint256 initialUser1RewardBalance = rewardToken.balanceOf(user1);
        uint256 initialUser1StakingBalance = stakingToken.balanceOf(user1);

        rewardToken.transfer(user2, 0); 
        stakingToken.transfer(user2, 0);

        assertEq(rewardToken.balanceOf(user1), initialUser1RewardBalance); // Balance should remain unchanged
        assertEq(rewardToken.balanceOf(user2), 0); // Receiver should still have zero tokens
        assertEq(stakingToken.balanceOf(user1), initialUser1StakingBalance); // Balance should remain unchanged
        assertEq(stakingToken.balanceOf(user2), 0);

        vm.stopPrank();
    }

   
}

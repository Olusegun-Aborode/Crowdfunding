// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Crowdfunding {
    struct Project {
        address creator;
        string title;
        string description;
        uint256 goalAmount;
        uint256 currentAmount;
        uint256 deadline;
        mapping(address => uint256) contributions;
        mapping(address => bool) hasClaimedReward;
    }

    mapping(uint256 => Project) public projects;
    uint256 public numProjects;

    function createProject(
        string memory _title,
        string memory _description,
        uint256 _goalAmount,
        uint256 _deadline
    ) external {
        projects[numProjects] = Project(
            msg.sender,
            _title,
            _description,
            _goalAmount,
            0,
            block.timestamp + _deadline,
            0
        );
        numProjects++;
    }

    function contribute(uint256 _projectId) external payable {
        Project storage project = projects[_projectId];
        require(block.timestamp < project.deadline, "Deadline exceeded");
        require(msg.value > 0, "Contribution amount must be greater than 0");
        project.contributions[msg.sender] += msg.value;
        project.currentAmount += msg.value;
    }

    function claimReward(uint256 _projectId) external {
        Project storage project = projects[_projectId];
        require(
            block.timestamp > project.deadline,
            "Deadline has not been reached"
        );
        require(
            project.contributions[msg.sender] > 0,
            "No contribution found"
        );
        require(
            !project.hasClaimedReward[msg.sender],
            "Reward already claimed"
        );
        uint256 rewardAmount =
            (project.contributions[msg.sender] * project.goalAmount) /
            project.currentAmount;
        payable(msg.sender).transfer(rewardAmount);
        project.hasClaimedReward[msg.sender] = true;
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Race5k {
    uint256 public constant TOTAL_CHECKPOINTS = 10;

    struct Runner {
        uint8 lastCheckpoint;
        uint256 startTime;
        bool finished;
    }

    mapping(address => Runner) public runners;

    event RaceStarted(address runner, uint256 time);
    event CheckpointReached(address runner, uint8 checkpoint, uint256 time);
    event RaceFinished(address runner, uint256 time);

    function startRace() external {
        Runner storage r = runners[msg.sender];
        require(r.startTime == 0, "Race already started");

        r.startTime = block.timestamp;
        r.lastCheckpoint = 0;
        r.finished = false;

        emit RaceStarted(msg.sender, block.timestamp);
    }

    function submitCheckpoint(uint8 checkpointIndex) external {
        Runner storage r = runners[msg.sender];
        require(r.startTime != 0, "Race not started");
        require(!r.finished, "Race finished");
        require(checkpointIndex == r.lastCheckpoint + 1, "Wrong checkpoint");
        require(checkpointIndex <= TOTAL_CHECKPOINTS, "Invalid checkpoint");

        r.lastCheckpoint = checkpointIndex;

        emit CheckpointReached(msg.sender, checkpointIndex, block.timestamp);

        if (checkpointIndex == TOTAL_CHECKPOINTS) {
            r.finished = true;
            emit RaceFinished(msg.sender, block.timestamp);
        }
    }
}


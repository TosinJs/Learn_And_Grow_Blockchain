// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "hardhat/console.sol";

contract WavePortal {
    // Define a variable to monitor the total number of waves in our contract
    uint256 totalWaves;
    uint256 private seed;
    mapping (address => uint) ownerWaveNumber;
    event NewWave(address indexed from, uint256 timestamp, string message);
   
    // Declare an Struct
    struct Wave {
        address waver;
        string message;
        uint256 timestamp;
    }
    // Create an array with items of type struct
    Wave[] waves;
    mapping (address => uint256) lastWavedAt;
    // Define the constructor function
    constructor() payable {
        console.log("This is a Smart Contract");
        seed = (block.timestamp + block.difficulty) % 100;
    }
    // Define a setter function that helps us modify the variable waves 
    function wave(string memory _message) public {
        require(lastWavedAt[msg.sender] + 15 minutes < block.timestamp, "Wait for 15 minutes");
        lastWavedAt[msg.sender] = block.timestamp;
        totalWaves += 1;
        ownerWaveNumber[msg.sender]++;
        console.log("%s waved w/ message %s", msg.sender, _message);
        waves.push(Wave(msg.sender, _message, block.timestamp));
        
        seed = (block.difficulty + block.timestamp + seed) % 100;
        console.log("Random # generated: %d", seed);
        if (seed <= 50) {
                console.log("%s won!", msg.sender);

            //Send ether to a waver
            uint256 prizeAmount = 0.00000001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more than we have eh"
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Lol, we no dey drop funds");
        }

        emit NewWave(msg.sender, block.timestamp, _message);
    }
    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }
    // Define a getter function, to get the variable waves
    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total Waves!", totalWaves);
        console.log("%s has waved %d times", msg.sender, ownerWaveNumber[msg.sender]);
        return totalWaves;
    }
}




// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {BasicNft} from "../src/BasicNft.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {MoodNft} from "../src/MoodNft.sol";

////////////////////////////////////////////////////////////////
contract MintBasicNft is Script {
    string public constant SQUIRREL =
        "https://meta.sofanft.io/api/v1/metadata/sofa/1271";

    function run() external {
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment(
            "BasicNft",
            block.chainid
            //DevOpsTools contract must be deployed and its address must be known at the time of calling function
        );

        mintNftOnContract(mostRecentDeployed);
    }

    function mintNftOnContract(address contractAddress) public {
        vm.startBroadcast();
        BasicNft(contractAddress).mintNft(SQUIRREL);
        vm.stopBroadcast();
    }
}

contract MintMoodNft is Script {
    function run() external {
        address mostRecentlyDeployedBasicNft = DevOpsTools
            .get_most_recent_deployment("MoodNft", block.chainid);
        mintNftOnContract(mostRecentlyDeployedBasicNft);
    }

    function mintNftOnContract(address moodNftAddress) public {
        vm.startBroadcast();
        MoodNft(moodNftAddress).mintNft();
        vm.stopBroadcast();
    }
}

/*
/////////////////////////////////////////////////////////////////////
contract MintMoodNft is Script {
    function run() external {
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment(
            "MoodNft",
            block.chainid
        );
        mintNftOnContract(mostRecentDeployed);
    }

    function mintNftOnContract(address contractAddress) public {
        vm.startBroadcast();
        MoodNft(contractAddress).mintNft();

        vm.stopBroadcast();
    }
}
*/
////////////////////////////////////////////////////////////////

contract FlipMood is Script {
    uint256 public constant TOKEN_ID_TO_FLIP = 0;

    function run() external {
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment(
            "MoodNft",
            block.chainid
        );

        flipMoodOnContract(mostRecentDeployed);
    }

    function flipMoodOnContract(address contractAddress) public {
        vm.startBroadcast();
        MoodNft moodNft = MoodNft(contractAddress);
        moodNft.flipMood(TOKEN_ID_TO_FLIP);
        vm.stopBroadcast();
    }
}

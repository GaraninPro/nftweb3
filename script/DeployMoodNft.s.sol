// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MoodNft} from "../src/MoodNft.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract DeployMoodNft is Script {
    uint256 public DEFAULT_ANVIL_PRIVATE_KEY =
        0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
    uint256 public deployerKey;

    ////////////////////////////////////////////////////////////
    function svgToImageUri(
        string memory svg
    ) public pure returns (string memory) {
        string memory baseURL = "data:image/svg+xml;base64,";
        //////////////////////////////////////////////////////////
        string memory svgBase64Encoded = Base64.encode(abi.encodePacked(svg));

        return string(abi.encodePacked(baseURL, svgBase64Encoded));
        ////////////////////////////////////////////////////////////////////
    }

    function run() external returns (MoodNft) {
        /*  if (block.chainid == 31337) {
            deployerKey = DEFAULT_ANVIL_PRIVATE_KEY;
        } else {
            deployerKey = vm.envUint("KEY2");
        } */
        string memory SAD_SVG = vm.readFile("./img/sad.svg");
        string memory HAPPY_SVG = vm.readFile("./img/happy.svg");

        vm.startBroadcast();
        MoodNft moodNft = new MoodNft(
            svgToImageUri(SAD_SVG),
            svgToImageUri(HAPPY_SVG)
        );
        vm.stopBroadcast();
        return moodNft;
    }
}

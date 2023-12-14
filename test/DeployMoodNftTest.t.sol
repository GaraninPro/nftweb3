// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {DeployMoodNft} from "../script/DeployMoodNft.s.sol";

contract DeploymoodNftTest is Test {
    DeployMoodNft public deployer;

    function setUp() public {
        deployer = new DeployMoodNft();
    }

    function testConvertSvgToUri() public view {
        string
            memory expectedURi = "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiB3aWR0aD0iNTAwIiBoZWlnaHQ9IjUwMCI+IDx0ZXh0IHg9IjAiCiAgICAgICAgICAgICAgICB5PSIxNSIgZmlsbD0iYmxhY2siPkhpISBZb3VyIGJyb3dzZXIgZGVjb2RlZCB0aGlzPC90ZXh0Pjwvc3ZnPg==";
        string memory svg = vm.readFile("./img/example.svg");

        string memory actualUri = deployer.svgToImageUri(svg);
        /////////////////////////////////
        console.log(actualUri);
        console.log(expectedURi);

        assert(
            keccak256(abi.encodePacked(expectedURi)) ==
                keccak256(abi.encodePacked(actualUri))
        );
    }
}

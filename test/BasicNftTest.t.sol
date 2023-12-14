// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {BasicNft} from "../src/BasicNft.sol";
import {DeployBasicNft} from "../script/DeploybasicNft.s.sol";
import {Test} from "forge-std/Test.sol";
import {MintBasicNft} from "../script/Interactions.s.sol";

contract BasicNftTest is Test {
    BasicNft public basicNft;
    DeployBasicNft public deployer;
    address public USER = makeAddr("beef");
    string public constant SQUIRREL =
        "https://ipfs.io/ipfs/QmTn3sRh79RFp9xCVYoz9U3inzM7bmeATKizTRkXVayUW1";

    ////////////////////////////////////////////
    function setUp() public {
        deployer = new DeployBasicNft();

        basicNft = deployer.run();
    }

    function testNameIsCorrect() public view {
        string memory expectedName = "BasicNft";
        string memory actualName = basicNft.name(); // name() default function in erc721
        assert(
            keccak256(abi.encodePacked(expectedName)) ==
                keccak256(abi.encodePacked(actualName))
        );
    }

    function testCanMintHaveBalance() public {
        vm.prank(USER);
        basicNft.mintNft(SQUIRREL);
        assert(basicNft.balanceOf(USER) == 1);
        assert(
            keccak256(abi.encodePacked(SQUIRREL)) ==
                keccak256(abi.encodePacked(basicNft.tokenURI(0)))
        );
    }

    function testMintWithScript() public {
        uint256 startingTokenCount = basicNft.getTokenCounter();
        MintBasicNft mintbasicNft = new MintBasicNft();
        mintbasicNft.mintNftOnContract(address(basicNft));

        assert(basicNft.getTokenCounter() == startingTokenCount + 1);
    }
}

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {MoodNft} from "../src/MoodNft.sol";
import {DeployMoodNft} from "../script/DeployMoodNft.s.sol";
import {Vm} from "forge-std/Vm.sol";

contract MoodNftTest is Test {
    MoodNft moodNft;
    DeployMoodNft deployer;
    //////////////////////////////////////////
    address constant USER = address(1);
    string constant NFT_NAME = "Mood Nft";
    string constant NFT_SYMBOL = "MN";
    ///////////////////////////////////////////////
    string constant HAPPY_SVG_URI_IMAGE =
        "data:image/svg+xml;base64, PHN2ZyB2aWV3Qm94PSIwIDAgMjAwIDIwMCIgd2lkdGg9IjQwMCIgaGVpZ2h0PSI0MDAiIHhtbG5z PSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CiAgICA8Y2lyY2xlIGN4PSIxMDAiIGN5PSIx MDAiIGZpbGw9InllbGxvdyIgcj0iNzgiIHN0cm9rZT0iYmxhY2siIHN0cm9rZS13aWR0aD0iMyIg Lz4KICAgIDxnIGNsYXNzPSJleWVzIj4KICAgICAgICA8Y2lyY2xlIGN4PSI2MSIgY3k9IjgyIiBy PSIxMiIgLz4KICAgICAgICA8Y2lyY2xlIGN4PSIxMjciIGN5PSI4MiIgcj0iMTIiIC8+CiAgICA8 L2c+CiAgICA8cGF0aCBkPSJtMTM2LjgxIDExNi41M2MuNjkgMjYuMTctNjQuMTEgNDItODEuNTIt LjczIiBzdHlsZT0iZmlsbDpub25lOyBzdHJva2U6IGJsYWNrOyBzdHJva2Utd2lkdGg6IDM7IiAv Pgo8L3N2Zz4=";
    string constant SAD_SVG_URI_IMAGE =
        "data:image/svg+xml;base64, PD94bWwgdmVyc2lvbj0iMS4wIiBzdGFuZGFsb25lPSJubyI/Pgo8c3ZnIHdpZHRoPSIxMDI0cHgi IGhlaWdodD0iMTAyNHB4IiB2aWV3Qm94PSIwIDAgMTAyNCAxMDI0IiB4bWxucz0iaHR0cDovL3d3 dy53My5vcmcvMjAwMC9zdmciPgogICAgPHBhdGggZmlsbD0iIzMzMyIKICAgICAgICBkPSJNNTEy IDY0QzI2NC42IDY0IDY0IDI2NC42IDY0IDUxMnMyMDAuNiA0NDggNDQ4IDQ0OCA0NDgtMjAwLjYg NDQ4LTQ0OFM3NTkuNCA2NCA1MTIgNjR6bTAgODIwYy0yMDUuNCAwLTM3Mi0xNjYuNi0zNzItMzcy czE2Ni42LTM3MiAzNzItMzcyIDM3MiAxNjYuNiAzNzIgMzcyLTE2Ni42IDM3Mi0zNzIgMzcyeiIg Lz4KICAgIDxwYXRoIGZpbGw9IiNFNkU2RTYiCiAgICAgICAgZD0iTTUxMiAxNDBjLTIwNS40IDAt MzcyIDE2Ni42LTM3MiAzNzJzMTY2LjYgMzcyIDM3MiAzNzIgMzcyLTE2Ni42IDM3Mi0zNzItMTY2 LjYtMzcyLTM3Mi0zNzJ6TTI4OCA0MjFhNDguMDEgNDguMDEgMCAwIDEgOTYgMCA0OC4wMSA0OC4w MSAwIDAgMS05NiAwem0zNzYgMjcyaC00OC4xYy00LjIgMC03LjgtMy4yLTguMS03LjRDNjA0IDYz Ni4xIDU2Mi41IDU5NyA1MTIgNTk3cy05Mi4xIDM5LjEtOTUuOCA4OC42Yy0uMyA0LjItMy45IDcu NC04LjEgNy40SDM2MGE4IDggMCAwIDEtOC04LjRjNC40LTg0LjMgNzQuNS0xNTEuNiAxNjAtMTUx LjZzMTU1LjYgNjcuMyAxNjAgMTUxLjZhOCA4IDAgMCAxLTggOC40em0yNC0yMjRhNDguMDEgNDgu MDEgMCAwIDEgMC05NiA0OC4wMSA0OC4wMSAwIDAgMSAwIDk2eiIgLz4KICAgIDxwYXRoIGZpbGw9 IiMzMzMiCiAgICAgICAgZD0iTTI4OCA0MjFhNDggNDggMCAxIDAgOTYgMCA0OCA0OCAwIDEgMC05 NiAwem0yMjQgMTEyYy04NS41IDAtMTU1LjYgNjcuMy0xNjAgMTUxLjZhOCA4IDAgMCAwIDggOC40 aDQ4LjFjNC4yIDAgNy44LTMuMiA4LjEtNy40IDMuNy00OS41IDQ1LjMtODguNiA5NS44LTg4LjZz OTIgMzkuMSA5NS44IDg4LjZjLjMgNC4yIDMuOSA3LjQgOC4xIDcuNEg2NjRhOCA4IDAgMCAwIDgt OC40QzY2Ny42IDYwMC4zIDU5Ny41IDUzMyA1MTIgNTMzem0xMjgtMTEyYTQ4IDQ4IDAgMSAwIDk2 IDAgNDggNDggMCAxIDAtOTYgMHoiIC8+Cjwvc3ZnPg==";
    string constant SAD_SVG_URI =
        "data:application/json;base64,eyJuYW1lIjogIk1vb2QgTmZ0IiwgImRlc2NyaXB0aW9uIjogIkNyYXp5IHRva2VuIHRoYXQgY2FuIHNob3cgdGhlIG1vb2Qgb2Ygb3duZXIgISEhIiwiaW1hZ2UiOiAiZGF0YTppbWFnZS9zdmcreG1sO2Jhc2U2NCxQRDk0Yld3Z2RtVnljMmx2YmowaU1TNHdJaUJ6ZEdGdVpHRnNiMjVsUFNKdWJ5SS9QZ284YzNabklIZHBaSFJvUFNJeE1ESTBjSGdpSUdobGFXZG9kRDBpTVRBeU5IQjRJaUIyYVdWM1FtOTRQU0l3SURBZ01UQXlOQ0F4TURJMElpQjRiV3h1Y3owaWFIUjBjRG92TDNkM2R5NTNNeTV2Y21jdk1qQXdNQzl6ZG1jaVBnb2dJQ0FnUEhCaGRHZ2dabWxzYkQwaUl6TXpNeUlLSUNBZ0lDQWdJQ0JrUFNKTk5URXlJRFkwUXpJMk5DNDJJRFkwSURZMElESTJOQzQySURZMElEVXhNbk15TURBdU5pQTBORGdnTkRRNElEUTBPQ0EwTkRndE1qQXdMallnTkRRNExUUTBPRk0zTlRrdU5DQTJOQ0ExTVRJZ05qUjZiVEFnT0RJd1l5MHlNRFV1TkNBd0xUTTNNaTB4TmpZdU5pMHpOekl0TXpjeWN6RTJOaTQyTFRNM01pQXpOekl0TXpjeUlETTNNaUF4TmpZdU5pQXpOeklnTXpjeUxURTJOaTQySURNM01pMHpOeklnTXpjeWVpSWdMejRLSUNBZ0lEeHdZWFJvSUdacGJHdzlJaU5GTmtVMlJUWWlDaUFnSUNBZ0lDQWdaRDBpVFRVeE1pQXhOREJqTFRJd05TNDBJREF0TXpjeUlERTJOaTQyTFRNM01pQXpOekp6TVRZMkxqWWdNemN5SURNM01pQXpOeklnTXpjeUxURTJOaTQySURNM01pMHpOekl0TVRZMkxqWXRNemN5TFRNM01pMHpOeko2VFRJNE9DQTBNakZoTkRndU1ERWdORGd1TURFZ01DQXdJREVnT1RZZ01DQTBPQzR3TVNBME9DNHdNU0F3SURBZ01TMDVOaUF3ZW0wek56WWdNamN5YUMwME9DNHhZeTAwTGpJZ01DMDNMamd0TXk0eUxUZ3VNUzAzTGpSRE5qQTBJRFl6Tmk0eElEVTJNaTQxSURVNU55QTFNVElnTlRrM2N5MDVNaTR4SURNNUxqRXRPVFV1T0NBNE9DNDJZeTB1TXlBMExqSXRNeTQ1SURjdU5DMDRMakVnTnk0MFNETTJNR0U0SURnZ01DQXdJREV0T0MwNExqUmpOQzQwTFRnMExqTWdOelF1TlMweE5URXVOaUF4TmpBdE1UVXhMalp6TVRVMUxqWWdOamN1TXlBeE5qQWdNVFV4TGpaaE9DQTRJREFnTUNBeExUZ2dPQzQwZW0weU5DMHlNalJoTkRndU1ERWdORGd1TURFZ01DQXdJREVnTUMwNU5pQTBPQzR3TVNBME9DNHdNU0F3SURBZ01TQXdJRGsyZWlJZ0x6NEtJQ0FnSUR4d1lYUm9JR1pwYkd3OUlpTXpNek1pQ2lBZ0lDQWdJQ0FnWkQwaVRUSTRPQ0EwTWpGaE5EZ2dORGdnTUNBeElEQWdPVFlnTUNBME9DQTBPQ0F3SURFZ01DMDVOaUF3ZW0weU1qUWdNVEV5WXkwNE5TNDFJREF0TVRVMUxqWWdOamN1TXkweE5qQWdNVFV4TGpaaE9DQTRJREFnTUNBd0lEZ2dPQzQwYURRNExqRmpOQzR5SURBZ055NDRMVE11TWlBNExqRXROeTQwSURNdU55MDBPUzQxSURRMUxqTXRPRGd1TmlBNU5TNDRMVGc0TGpaek9USWdNemt1TVNBNU5TNDRJRGc0TGpaakxqTWdOQzR5SURNdU9TQTNMalFnT0M0eElEY3VORWcyTmpSaE9DQTRJREFnTUNBd0lEZ3RPQzQwUXpZMk55NDJJRFl3TUM0eklEVTVOeTQxSURVek15QTFNVElnTlRNemVtMHhNamd0TVRFeVlUUTRJRFE0SURBZ01TQXdJRGsySURBZ05EZ2dORGdnTUNBeElEQXRPVFlnTUhvaUlDOCtDand2YzNablBnPT0iLCJhdHRyaWJ1dGVzIjpbeyJ0cmFpdF90eXBlIjogIm1vb2RpbmVzcyIsICJ2YWx1ZSI6IDEwMH1dfQ==";
    string constant HAPPY_SVG_URI =
        "data:application/json;base64,eyJuYW1lIjogIk1vb2QgTmZ0IiwgImRlc2NyaXB0aW9uIjogIkNyYXp5IHRva2VuIHRoYXQgY2FuIHNob3cgdGhlIG1vb2Qgb2Ygb3duZXIgISEhIiwiaW1hZ2UiOiAiZGF0YTppbWFnZS9zdmcreG1sO2Jhc2U2NCxQSE4yWnlCMmFXVjNRbTk0UFNJd0lEQWdNakF3SURJd01DSWdkMmxrZEdnOUlqUXdNQ0lnYUdWcFoyaDBQU0kwTURBaUlIaHRiRzV6UFNKb2RIUndPaTh2ZDNkM0xuY3pMbTl5Wnk4eU1EQXdMM04yWnlJK0NpQWdJQ0E4WTJseVkyeGxJR040UFNJeE1EQWlJR041UFNJeE1EQWlJR1pwYkd3OUlubGxiR3h2ZHlJZ2NqMGlOemdpSUhOMGNtOXJaVDBpWW14aFkyc2lJSE4wY205clpTMTNhV1IwYUQwaU15SWdMejRLSUNBZ0lEeG5JR05zWVhOelBTSmxlV1Z6SWo0S0lDQWdJQ0FnSUNBOFkybHlZMnhsSUdONFBTSTJNU0lnWTNrOUlqZ3lJaUJ5UFNJeE1pSWdMejRLSUNBZ0lDQWdJQ0E4WTJseVkyeGxJR040UFNJeE1qY2lJR041UFNJNE1pSWdjajBpTVRJaUlDOCtDaUFnSUNBOEwyYytDaUFnSUNBOGNHRjBhQ0JrUFNKdE1UTTJMamd4SURFeE5pNDFNMk11TmprZ01qWXVNVGN0TmpRdU1URWdOREl0T0RFdU5USXRMamN6SWlCemRIbHNaVDBpWm1sc2JEcHViMjVsT3lCemRISnZhMlU2SUdKc1lXTnJPeUJ6ZEhKdmEyVXRkMmxrZEdnNklETTdJaUF2UGdvOEwzTjJaejQ9IiwiYXR0cmlidXRlcyI6W3sidHJhaXRfdHlwZSI6ICJtb29kaW5lc3MiLCAidmFsdWUiOiAxMDB9XX0=";

    ////////////////////////////////////////////////
    function setUp() public {
        deployer = new DeployMoodNft();
        moodNft = deployer.run();
    }

    function testViewTokenUriAndHasBalanceAndAbleToMint() public {
        vm.prank(USER);
        moodNft.mintNft();

        assertEq(moodNft.balanceOf(USER), 1);
        console.log(msg.sender);
        console.log(moodNft.tokenURI(0));
    }

    function testFlipTokenToSad() public {
        vm.startPrank(msg.sender);

        moodNft.mintNft();

        moodNft.flipMood(0);

        vm.stopPrank();

        assertEq(
            keccak256(abi.encodePacked(SAD_SVG_URI)),
            keccak256(abi.encodePacked(moodNft.tokenURI(0)))
        );
    }

    function testAllNamesOk() public {
        assertEq(
            keccak256(abi.encodePacked(moodNft.name())),
            keccak256(abi.encodePacked(NFT_NAME))
        );
        assertEq(
            keccak256(abi.encodePacked(moodNft.symbol())),
            keccak256(abi.encodePacked(NFT_SYMBOL))
        );
    }

    function testMoodHappyAfterMint() public {
        vm.prank(USER);
        moodNft.mintNft();
        assertEq(
            keccak256(abi.encodePacked(moodNft.tokenURI(0))),
            keccak256(abi.encodePacked(HAPPY_SVG_URI))
        );
    }

    function testEventWriteTokenIdRightWhenMinting() public {
        uint256 currentTokenId = moodNft.getTokenCounter();
        vm.prank(USER);
        vm.recordLogs();
        moodNft.mintNft();

        Vm.Log[] memory entries = vm.getRecordedLogs();
        bytes32 tokenId_proto = entries[0].topics[1];
        uint256 tokenId = uint256(tokenId_proto);
        assertEq(currentTokenId, tokenId);
    }
}

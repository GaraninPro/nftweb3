// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract MoodNft is ERC721, Ownable {
    error MoodNft_CanNotFlipIfNotOwner();
    error MoodNft_NoUriForNonExistentToken();
    ////////////////////////////////////////
    uint256 private s_tokenCounter;
    string private s_sadSvgImageUri;
    string private s_happySvgImageUri;
    mapping(uint256 => Mood) private tokenIdToMood;
    event CreatedNft(uint256 indexed tokenId);
    //////////////////////////
    enum Mood {
        HAPPY,
        SAD
    }

    //////////////////////////////////
    constructor(
        string memory sadSvgImageUri,
        string memory happySvgImageUri
    ) ERC721("Mood Nft", "MN") Ownable(msg.sender) {
        s_tokenCounter = 0;
        s_sadSvgImageUri = sadSvgImageUri;
        s_happySvgImageUri = happySvgImageUri;
    }

    ////////////////////////////////////////////////////////
    function mintNft() public {
        uint256 tokenCounter = s_tokenCounter;
        _safeMint(msg.sender, tokenCounter);
        tokenIdToMood[s_tokenCounter] = Mood.HAPPY;
        s_tokenCounter = s_tokenCounter++;
        emit CreatedNft(tokenCounter);
    }

    /////////////////////////////////////////////////////
    function flipMood(uint256 tokenId) public onlyOwner {
        if (
            ownerOf(tokenId) != msg.sender && getApproved(tokenId) != msg.sender
        ) {
            revert MoodNft_CanNotFlipIfNotOwner();
        }
        if (tokenIdToMood[tokenId] == Mood.HAPPY) {
            tokenIdToMood[tokenId] = Mood.SAD;
        } else {
            tokenIdToMood[tokenId] = Mood.HAPPY;
        }
    }

    //////////////////////////////////////////////////////////
    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    //////////////////////////////////////////////////////////
    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        string memory imageURI;
        if (ownerOf(tokenId) == address(0)) {
            revert MoodNft_NoUriForNonExistentToken();
        }
        //////////////////////////////////////////////
        if (tokenIdToMood[tokenId] == Mood.HAPPY) {
            imageURI = s_happySvgImageUri;
        } else {
            imageURI = s_sadSvgImageUri;
        }
        // selector = bytes4(keccak256(bytes("transfer(address,uint256)"))); keccak also eats bytes!!!
        return
            string( // we need bytes
                abi.encodePacked(
                    _baseURI(),
                    Base64.encode( // we need bytes
                        abi.encodePacked(
                            '{"name": "',
                            name(),
                            '", "description": "Crazy token that can show the mood of owner !!!","image": "',
                            imageURI,
                            '","attributes":[{"trait_type": "moodiness", "value": 100}]}'
                        )
                    )
                )
            );
    }

    function getHappySvg() public view returns (string memory) {
        return s_happySvgImageUri;
    }

    function getSadSvg() public view returns (string memory) {
        return s_sadSvgImageUri;
    }

    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }
}

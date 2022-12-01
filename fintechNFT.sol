// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.7;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import "@openzeppelin/contracts@4.8.0/token/ERC721/extensions/ERC721Enumerable.sol";
import '@openzeppelin/contracts/access/Ownable.sol';
import "@openzeppelin/contracts@4.8.0/utils/Counters.sol";

contract fintechNFT is ERC721, Ownable {
    uint256 public mintPrice = 0.01 ether;
    uint256 public totalSupply;
    uint256 public maxSupply;
    bool public isMintEnabled;
    mapping(address => uint256) public mintedWallets;

    constructor() payable ERC721('Fintech NFT', 'NFT') {
        maxSupply = 1000;
    }
    
    function _baseURI() internal pure override returns (string memory) {
        return "https://api.fintechnft.com/tokens/";
    }
    
    function safeMint(address to) public {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    function toggleIsMintEnabled() external onlyOwner {
        isMintEnabled = !isMintEnabled;
    }

    function setMaxSupply(uint256 maxSupply_) external onlyOwner {
        maxSupply = maxSupply_;
    }
    
    function mint() external payable {
        require(isMintEnabled, 'minting not enabled');
        require(mintedWallets[msg.sender] < 3, 'exceeds max per wallet');
        require(msg.value == mintPrice, 'wrong value');
        require(maxSupply > totalSupply, 'sold out');
    
        mintedWallets[msg.sender]++;
        totalSupply++;
        uint256 tokenId = totalSupply;
        _safeMint(msg.sender, tokenId);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "./RewardToken.sol";

contract NFTVault is ReentrancyGuard {
    IERC721 public immutable nftCollection;
    RewardToken public immutable rewardToken;

    uint256 public constant REWARD_RATE = 10 * 10**18; // 10 tokens per day per NFT

    struct Stake {
        address owner;
        uint256 timestamp;
    }

    mapping(uint256 => Stake) public vault;

    event Staked(address indexed user, uint256 tokenId);
    event Unstaked(address indexed user, uint256 tokenId);

    constructor(address _nft, address _reward) {
        nftCollection = IERC721(_nft);
        rewardToken = RewardToken(_reward);
    }

    function stake(uint256 tokenId) external nonReentrant {
        nftCollection.transferFrom(msg.sender, address(this), tokenId);
        
        vault[tokenId] = Stake({
            owner: msg.sender,
            timestamp: block.timestamp
        });

        emit Staked(msg.sender, tokenId);
    }

    function unstake(uint256 tokenId) external nonReentrant {
        require(vault[tokenId].owner == msg.sender, "Not the owner");
        
        uint256 reward = calculateReward(tokenId);
        delete vault[tokenId];

        if (reward > 0) {
            rewardToken.mint(msg.sender, reward);
        }

        nftCollection.transferFrom(address(this), msg.sender, tokenId);
        emit Unstaked(msg.sender, tokenId);
    }

    function calculateReward(uint256 tokenId) public view returns (uint256) {
        if (vault[tokenId].owner == address(0)) return 0;
        uint256 timeStaked = block.timestamp - vault[tokenId].timestamp;
        return (timeStaked * REWARD_RATE) / 1 days;
    }
}

# Simple NFT Staking Vault

This repository contains a professional-grade Smart Contract system for staking NFTs (ERC-721) to earn Reward Tokens (ERC-20). It is designed to be a foundation for P2E games, DAO memberships, or DeFi reward layers.

### Features
* **Time-Based Rewards:** Users earn a fixed amount of reward tokens per block/second for every NFT staked.
* **Emergency Withdraw:** Built-in safety functions to allow users to recover assets in edge cases.
* **Efficient Math:** Uses consolidated storage to minimize gas costs during multiple NFT stakes.
* **Security:** Implements `ReentrancyGuard` and `Ownable` patterns from OpenZeppelin.

### How it Works
1. **Approve:** User approves the Vault contract to handle their NFT.
2. **Stake:** User calls `stake()` with their Token ID.
3. **Earn:** Rewards accumulate automatically based on the reward rate.
4. **Claim/Unstake:** User withdraws their NFT and receives their earned tokens.

### License
MIT

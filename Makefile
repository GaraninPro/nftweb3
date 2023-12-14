-include .env
deploy:
	forge script script/DeploybasicNft.s.sol --rpc-url $(RPC2) --private-key $(KEY2) --etherscan-api-key $(SCAN) --broadcast --verify
mint:
	forge script script/Interactions.s.sol:MintBasicNft --rpc-url $(RPC2) --private-key $(KEY2) --broadcast


deployMood:
	forge script script/DeployMoodNft.s.sol --rpc-url $(RPC2) --private-key $(KEY2) --etherscan-api-key $(SCAN) --broadcast --verify
mintMood:
	forge script script/Interactions.s.sol:MintMoodNft --rpc-url $(RPC2) --private-key $(KEY2) --broadcast

flipMood:
	forge script script/Interactions.s.sol:FlipMood   --rpc-url $(RPC2) --private-key $(KEY2) --broadcast


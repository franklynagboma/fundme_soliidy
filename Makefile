# Use to write short cuts commands to run code on the terminal
-include .env

deploy-sepolia-live-test:
	forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(SEPOLIA_RPC_URL) --account testKeyOne --sender 0xe04de6307d0EeB8d1Fe13Ee6B6bd04F790a222e7 --broadcast -vvvv

deploy-and-verify-sepolia-live-test:
	forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(SEPOLIA_RPC_URL) --account testKeyOne --sender 0xe04de6307d0EeB8d1Fe13Ee6B6bd04F790a222e7 --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv

deploy-anvil-test:
	forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(ANVIL_LOCAL_RPC_URL) --account anvilKey --sender 0x70997970C51812dc3A010C7d01b50e0d17dc79C8 --broadcast -vvvv
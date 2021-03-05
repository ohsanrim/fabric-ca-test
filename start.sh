#infoln "Generating certificates using cryptogen tool"
cryptogen generate --config=./crypto-config.yaml

#infoln "Generating Orderer Genesis block and systemchannel.tx"
configtxgen -profile TwoOrgsOrdererGenesis -outputBlock genesis.block -channelID systemchannel
configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ch1.tx -channelID systemchannel

#infoln "Generating anchor peer update transaction for Org on channel mychannel"
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate Org1MSPanchors.tx -channelID mychannel -asOrg Org1MSP
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate Org2MSPanchors.tx -channelID mychannel -asOrg Org2MSP
mv genesis.block $HOME/testnet/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/

#infoln "Deploy to orderer node and peer node"
./transport.sh

#channel make
#infoln "Create a channel, channelID with 'mychannel'"
configtxgen -profile TwoOrgsChannel -outputCreateChannelTx mychannel.tx -channelID mychannel

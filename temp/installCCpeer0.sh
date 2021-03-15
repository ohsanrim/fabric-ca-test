export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=peer0:7051


peer lifecycle chaincode install basic.tar.gz


peer lifecycle chaincode approveformyorg -o orderer0:7050 --ordererTLSHostnameOverride orderer0 --channelID mychannel --name ksign
 --version 1.0 --package-id basic_1.0:0788b09dbb0681d835dad50a770a6f51aabdf53f0ad5da4135d776ad585ea48d --sequence 1 --tls --cafile crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem


peer lifecycle chaincode checkcommitreadiness --channelID mychannel --name ksign --version 1.0 --sequence 1 --tls --cafile crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem




peer lifecycle chaincode commit -o orderer0:7050 --ordererTLSHostnameOverride orderer0 --channelID mychannel --name ksign --version 1.0 --sequence 1 --tls --cafile crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem --peerAddresses peer0:7051 --tlsRootCertFiles crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses peer2:7051 --tlsRootCertFiles crypto-config/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/tls/ca.crt 

peer chaincode invoke -o orderer0:7050 --ordererTLSHostnameOverride orderer0 --tls --cafile crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C mychannel -n basic --peerAddresses peer0:7051 --tlsRootCertFiles crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses peer2:7051 --tlsRootCertFiles crypto-config/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/tls/ca.crt -c '{"functions":"initLedger","Args":[]}'

peer chaincode invoke -o orderer0:7050 --ordererTLSHostnameOverride orderer0 --tls --cafile crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C mychannel -n basic --peerAddresses peer0:7051 --tlsRootCertFiles crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses peer2:7051 --tlsRootCertFiles crypto-config/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/tls/ca.crt -c '{"function":"CreateAsset","Args":["asset8","blue","16","Kelley","750"]}'

peer chaincode query -C mychannel -n basic -c '{"Args":["GetAllAssets"]}'

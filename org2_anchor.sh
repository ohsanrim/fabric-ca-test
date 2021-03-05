export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=crypto-config/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ADDRESS=peer2:7051
peer channel create -o orderer0:7050 -c mychannel --ordererTLSHostnameOverride orderer0 -c mychannel -f Org2MSPanchors.tx --tls --cafile crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem


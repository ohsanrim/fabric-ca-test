#peer tls
sudo scp -rq $HOME/testnet/crypto-config/fabric-ca/tls/ca-cert.pem original@peer0:$HOME/testnet/crypto-config/fabric-ca/tls
sudo scp -rq $HOME/testnet/crypto-config/fabric-ca/tls/ca-cert.pem original@peer1:$HOME/testnet/crypto-config/fabric-ca/tls
sudo scp -rq $HOME/testnet/crypto-config/fabric-ca/tls/ca-cert.pem original@peer2:$HOME/testnet/crypto-config/fabric-ca/tls
sudo scp -rq $HOME/testnet/crypto-config/fabric-ca/tls/ca-cert.pem original@orderer0:$HOME/testnet/crypto-config/fabric-ca/tls
#peer MSP
sudo scp -rq $HOME/testnet/crypto-config/fabric-ca/org1/ca-cert.pem original@peer0:$HOME/testnet/crypto-config/fabric-ca/org1
sudo scp -rq $HOME/testnet/crypto-config/fabric-ca/org1/ca-cert.pem original@peer1:$HOME/testnet/crypto-config/fabric-ca/org1
sudo scp -rq $HOME/testnet/crypto-config/fabric-ca/org2/ca-cert.pem original@peer2:$HOME/testnet/crypto-config/fabric-ca/org2
#sudo scp -rq $HOME/testnet/crypto-config/fabric-ca/org2/ca-cert.pem original@peer3:$HOME/testnet/crypto-config/fabric-ca/org2
#orderer MSP
sudo scp -rq $HOME/testnet/crypto-config/fabric-ca/ordererOrg/ca-cert.pem original@orderer0:$HOME/testnet/crypto-config/fabric-ca/ordererOrg
sudo scp -rq $HOME/testnet/crypto-config/fabric-ca/org1/ca-cert.pem original@orderer0:$HOME/testnet/crypto-config/fabric-ca/org1
sudo scp -rq $HOME/testnet/crypto-config/fabric-ca/org2/ca-cert.pem original@orderer0:$HOME/testnet/crypto-config/fabric-ca/org2

#sudo scp -rq $HOME/testnet original@peer0:$HOME
#sudo scp -rq $HOME/testnet original@peer1:$HOME
#sudo scp -rq $HOME/testnet original@peer2:$HOME
#sudo scp -rq $HOME/testnet original@orderer0:$HOME

####################################################################
#Deploy an intermediate Org2 CA
mkdir -p $HOME/testnet/crypto-config/fabric-ca/org2/tls
export FABRIC_CA_SERVER_HOME=$HOME/testnet/crypto-config/fabric-ca/org2

cp $HOME/testnet/crypto-config/fabric-ca/fabric-ca-client/tls-ca/org2_admin/msp/signcerts/cert.pem $HOME/testnet/crypto-config/fabric-ca/org2/tls && cp $HOME/testnet/crypto-config/fabric-ca/fabric-ca-client/tls-ca/org2_admin/msp/keystore/* $HOME/testnet/crypto-config/fabric-ca/org2/tls/key.pem

cp $HOME/testnet/crypto-config/fabric-ca/tls/ca-cert.pem $HOME/testnet/crypto-config/fabric-ca/org2/tls/tls-ca-cert.pem

fabric-ca-server start --port 8054

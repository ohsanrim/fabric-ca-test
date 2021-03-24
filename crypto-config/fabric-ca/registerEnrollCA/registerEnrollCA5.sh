####################################################################
#Deploy an intermediate OrdererOrg CA
mkdir -p $HOME/testnet/crypto-config/fabric-ca/ordererOrg/tls
export FABRIC_CA_SERVER_HOME=$HOME/testnet/crypto-config/fabric-ca/ordererOrg

cp $HOME/testnet/crypto-config/fabric-ca/fabric-ca-client/tls-ca/ordererOrg_admin/msp/signcerts/cert.pem $HOME/testnet/crypto-config/fabric-ca/ordererOrg/tls && cp $HOME/testnet/crypto-config/fabric-ca/fabric-ca-client/tls-ca/ordererOrg_admin/msp/keystore/* $HOME/testnet/crypto-config/fabric-ca/ordererOrg/tls/key.pem

cp $HOME/testnet/crypto-config/fabric-ca/tls/ca-cert.pem $HOME/testnet/crypto-config/fabric-ca/ordererOrg/tls/tls-ca-cert.pem

fabric-ca-server start --port 9054
#docker-compose -f docker/docker-compose-ordererOrg-ica.yaml up -d

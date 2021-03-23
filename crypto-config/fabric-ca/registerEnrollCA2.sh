export FABRIC_CA_SERVER_HOME=$HOME/testnet/crypto-config/fabric-ca/tls
fabric-ca-server start -b tls-ca-admin:tls-ca-adminpw --port 10054

mkdir -p $HOME/testnet/crypto-config/fabric-ca/fabric-ca-client/tls-ca
mkdir -p $HOME/testnet/crypto-config/fabric-ca/fabric-ca-client/tls-root-cert
cp $HOME/testnet/crypto-config/fabric-ca/tls/ca-cert.pem $HOME/testnet/crypto-config/fabric-ca/fabric-ca-client/tls-root-cert/tls-ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$HOME/testnet/crypto-config/fabric-ca/fabric-ca-client
fabric-ca-client enroll -d -u https://tls-ca-admin:tls-ca-adminpw@fabric-ca:10054 --tls.certfiles tls-root-cert/tls-ca-cert.pem --enrollment.profile tls --csr.hosts fabric-ca --mspdir tls-ca/tlsadmin/msp

fabric-ca-client register -d --id.name rcaadmin --id.secret rcaadmin -u https://fabric-ca:10054 --tls.certfiles tls-root-cert/tls-ca-cert.pem --mspdir tls-ca/tlsadmin/msp

fabric-ca-client enroll -d -u https://rcaadmin:rcaadmin@fabric-ca:10054 --tls.certfiles tls-root-cert/tls-ca-cert.pem --enrollment.profile tls --csr.hosts fabric-ca --mspdir tls-ca/rcaadmin/msp
#register and enroll the Intermediate CA admin with the TLS CA
fabric-ca-client register -d --id.name icaadmin --id.secret icaadmin -u https://fabric-ca:10054 --tls.certfiles tls-root-cert/tls-ca-cert.pem --mspdir tls-ca/tlsadmin/msp
fabric-ca-client enroll -d -u https://icaadmin:icaadmin@fabric-ca:10054 --tls.certfiles tls-root-cert/tls-ca-cert.pem --enrollment.profile tls --csr.hosts fabric-ca --mspdir tls-ca/icaadmin/msp

#Deploy an intermediate CA
#mkdir -p $HOME/testnet/crypto-config/fabric-ca/fabric-ca-server-int-ca
cd $HOME/testnet/crypto-config/fabric-ca/fabric-ca-server-int-ca
mkdir tls
cp ../fabric-ca-client/tls-ca/icaadmin/msp/signcerts/cert.pem tls && cp ../fabric-ca-client/tls-ca/icaadmin/msp/keystore/* tls/key.pem
cp ../tls/ca-cert.pem tls/tls-ca-cert.pem
export FABRIC_CA_SERVER_HOME=$HOME/testnet/crypto-config/fabric-ca/fabric-ca-server-int-ca
fabric-ca-server init -b icaadmin:icaadmin

#modify fabric-ca-server-config.yaml in $HOME/testnet/crypto-config/fabric-ca/fabric-ca-server-int-ca




mkdir -p $HOME/testnet/crypto-config/fabric-ca/fabric-ca-client/tls-ca
mkdir -p $HOME/testnet/crypto-config/fabric-ca/fabric-ca-client/tls-root-cert
cp $HOME/testnet/crypto-config/fabric-ca/tls/ca-cert.pem $HOME/testnet/crypto-config/fabric-ca/fabric-ca-client/tls-root-cert/tls-ca-cert.pem

#enroll tls-ca-admin
export FABRIC_CA_CLIENT_HOME=$HOME/testnet/crypto-config/fabric-ca/fabric-ca-client

fabric-ca-client enroll -d -u https://tls-ca-admin:tls-ca-adminpw@fabric-ca:10054 --tls.certfiles tls-root-cert/tls-ca-cert.pem --enrollment.profile tls --csr.hosts fabric-ca --mspdir tls-ca/tlsadmin/msp


#register tls-root-CA
fabric-ca-client register -d --id.name rcaadmin --id.secret rcaadmin -u https://fabric-ca:10054 --tls.certfiles tls-root-cert/tls-ca-cert.pem --mspdir tls-ca/tlsadmin/msp

#enroll tls-root-CA
fabric-ca-client enroll -d -u https://rcaadmin:rcaadmin@fabric-ca:10054 --tls.certfiles tls-root-cert/tls-ca-cert.pem --enrollment.profile tls --csr.hosts fabric-ca --mspdir tls-ca/rcaadmin/msp

#Register Intermediate CA org1_admin with the org1_admin TLS CA
fabric-ca-client register -d --id.name org1_admin --id.secret org1_adminpw -u https://fabric-ca:10054 --tls.certfiles tls-root-cert/tls-ca-cert.pem --mspdir tls-ca/tlsadmin/msp

#Enroll Intermediate CA org1_admin with the org1_admin TLS CA
fabric-ca-client enroll -d -u https://org1_admin:org1_adminpw@fabric-ca:10054 --tls.certfiles tls-root-cert/tls-ca-cert.pem --enrollment.profile tls --csr.hosts fabric-ca --mspdir tls-ca/org1_admin/msp

#Register Intermediate CA org2_admin with the org2_admin TLS CA
fabric-ca-client register -d --id.name org2_admin --id.secret org2_adminpw -u https://fabric-ca:10054 --tls.certfiles tls-root-cert/tls-ca-cert.pem --mspdir tls-ca/tlsadmin/msp

#Enroll Intermediate CA org2_admin with the org2_admin TLS CA
fabric-ca-client enroll -d -u https://org2_admin:org2_adminpw@fabric-ca:10054 --tls.certfiles tls-root-cert/tls-ca-cert.pem --enrollment.profile tls --csr.hosts fabric-ca --mspdir tls-ca/org2_admin/msp

#Register Intermediate CA ordererOrg_admin with the ordererOrg_admin TLS CA
fabric-ca-client register -d --id.name ordererOrg_admin --id.secret ordererOrg_adminpw -u https://fabric-ca:10054 --tls.certfiles tls-root-cert/tls-ca-cert.pem --mspdir tls-ca/tlsadmin/msp

#Enroll Intermediate CA ordererOrg_admin with the ordererOrg_admin TLS CA
fabric-ca-client enroll -d -u https://ordererOrg_admin:ordererOrg_adminpw@fabric-ca:10054 --tls.certfiles tls-root-cert/tls-ca-cert.pem --enrollment.profile tls --csr.hosts fabric-ca --mspdir tls-ca/ordererOrg_admin/msp

####################################################################
#Deploy an organizations CA
export FABRIC_CA_SERVER_HOME=$HOME/testnet/crypto-config/fabric-ca/root

mkdir -p $HOME/testnet/crypto-config/fabric-ca/root/tls

cp $HOME/testnet/crypto-config/fabric-ca/fabric-ca-client/tls-ca/rcaadmin/msp/signcerts/cert.pem $HOME/testnet/crypto-config/fabric-ca/root/tls && cp $HOME/testnet/crypto-config/fabric-ca/fabric-ca-client/tls-ca/rcaadmin/msp/keystore/* $HOME/testnet/crypto-config/fabric-ca/root/tls/key.pem

fabric-ca-server start --port 6054


####################################################################
#tls server start 
export FABRIC_CA_SERVER_HOME=$HOME/testnet/crypto-config/fabric-ca/tls
fabric-ca-server start -b tls-ca-admin:tls-ca-adminpw --port 10054
#docker-compose -f docker/docker-compose-tls-ca.yaml up -d

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

#docker-compose -f docker/docker-compose-rcaadmin.yaml up -d
fabric-ca-server start --port 6054

mkdir -p $HOME/testnet/crypto-config/fabric-ca/fabric-ca-client/root-ca

export FABRIC_CA_CLIENT_HOME=$HOME/testnet/crypto-config/fabric-ca/fabric-ca-client

fabric-ca-client enroll -d -u https://rcaadmin:rcaadminpw@fabric-ca:6054 --tls.certfiles tls-root-cert/tls-ca-cert.pem --csr.hosts fabric-ca --mspdir root-ca/rcaadmin/msp

#register and enroll the Intermediate org1 CA admin with the org1 TLS CA
fabric-ca-client register -d --id.name org1_admin --id.secret org1_adminpw -u https://fabric-ca:6054 --tls.certfiles tls-root-cert/tls-ca-cert.pem --id.attrs '"hf.Registrar.Roles=user,admin","hf.Revoker=true","hf.IntermediateCA=true"' --mspdir root-ca/rcaadmin/msp

#register and enroll the Intermediate org2 CA admin with the org2 TLS CA
fabric-ca-client register -d --id.name org2_admin --id.secret org2_adminpw -u https://fabric-ca:6054 --tls.certfiles tls-root-cert/tls-ca-cert.pem --id.attrs '"hf.Registrar.Roles=user,admin","hf.Revoker=true","hf.IntermediateCA=true"' --mspdir root-ca/rcaadmin/msp

#register and enroll the Intermediate orderer CA admin with the orderer TLS CA
fabric-ca-client register -d --id.name ordererOrg_admin --id.secret ordererOrg_adminpw -u https://fabric-ca:6054 --tls.certfiles tls-root-cert/tls-ca-cert.pem --id.attrs '"hf.Registrar.Roles=user,admin","hf.Revoker=true","hf.IntermediateCA=true"' --mspdir root-ca/rcaadmin/msp

####################################################################
#Deploy an intermediate Org1 CA
mkdir -p $HOME/testnet/crypto-config/fabric-ca/org1/tls
export FABRIC_CA_SERVER_HOME=$HOME/testnet/crypto-config/fabric-ca/org1

cp $HOME/testnet/crypto-config/fabric-ca/fabric-ca-client/tls-ca/org1_admin/msp/signcerts/cert.pem $HOME/testnet/crypto-config/fabric-ca/org1/tls && cp $HOME/testnet/crypto-config/fabric-ca/fabric-ca-client/tls-ca/org1_admin/msp/keystore/* $HOME/testnet/crypto-config/fabric-ca/org1/tls/key.pem

cp $HOME/testnet/crypto-config/fabric-ca/tls/ca-cert.pem $HOME/testnet/crypto-config/fabric-ca/org1/tls/tls-ca-cert.pem

fabric-ca-server start --port 7054
#docker-compose -f docker/docker-compose-org1-ica.yaml up -d

cd $HOME/testnet/crypto-config/fabric-ca/fabric-ca-client
export FABRIC_CA_CLIENT_HOME=${PWD}

fabric-ca-client enroll -d -u https://org1_admin:org1_adminpw@fabric-ca:7054 --tls.certfiles tls-root-cert/tls-ca-cert.pem --csr.hosts fabric-ca --mspdir int-ca/org1_admin/msp

export FABRIC_CA_SERVER_HOME=$HOME/testnet/crypto-config/fabric-ca/org1

####################################################################
#Deploy an intermediate Org2 CA
mkdir -p $HOME/testnet/crypto-config/fabric-ca/org2/tls
export FABRIC_CA_SERVER_HOME=$HOME/testnet/crypto-config/fabric-ca/org2

cp $HOME/testnet/crypto-config/fabric-ca/fabric-ca-client/tls-ca/org2_admin/msp/signcerts/cert.pem $HOME/testnet/crypto-config/fabric-ca/org2/tls && cp $HOME/testnet/crypto-config/fabric-ca/fabric-ca-client/tls-ca/org2_admin/msp/keystore/* $HOME/testnet/crypto-config/fabric-ca/org2/tls/key.pem

cp $HOME/testnet/crypto-config/fabric-ca/tls/ca-cert.pem $HOME/testnet/crypto-config/fabric-ca/org2/tls/tls-ca-cert.pem

fabric-ca-server start --port 8054
#docker-compose -f docker/docker-compose-org2-ica.yaml up -d

cd $HOME/testnet/crypto-config/fabric-ca/fabric-ca-client
export FABRIC_CA_CLIENT_HOME=${PWD}

fabric-ca-client enroll -d -u https://org2_admin:org2_adminpw@fabric-ca:8054 --tls.certfiles tls-root-cert/tls-ca-cert.pem --csr.hosts fabric-ca --mspdir intt-ca/org2_admin/msp

export FABRIC_CA_SERVER_HOME=$HOME/testnet/crypto-config/fabric-ca/org2

####################################################################
#Deploy an intermediate OrdererOrg CA
mkdir -p $HOME/testnet/crypto-config/fabric-ca/ordererOrg/tls
export FABRIC_CA_SERVER_HOME=$HOME/testnet/crypto-config/fabric-ca/ordererOrg

cp $HOME/testnet/crypto-config/fabric-ca/fabric-ca-client/tls-ca/ordererOrg_admin/msp/signcerts/cert.pem $HOME/testnet/crypto-config/fabric-ca/ordererOrg/tls && cp $HOME/testnet/crypto-config/fabric-ca/fabric-ca-client/tls-ca/ordererOrg_admin/msp/keystore/* $HOME/testnet/crypto-config/fabric-ca/ordererOrg/tls/key.pem

cp $HOME/testnet/crypto-config/fabric-ca/tls/ca-cert.pem $HOME/testnet/crypto-config/fabric-ca/ordererOrg/tls/tls-ca-cert.pem

fabric-ca-server start --port 9054
#docker-compose -f docker/docker-compose-ordererOrg-ica.yaml up -d

cd $HOME/testnet/crypto-config/fabric-ca/fabric-ca-client
export FABRIC_CA_CLIENT_HOME=${PWD}

fabric-ca-client enroll -d -u https://ordererOrg_admin:ordererOrg_adminpw@fabric-ca:9054 --tls.certfiles tls-root-cert/tls-ca-cert.pem --csr.hosts fabric-ca --mspdir int-ca/ordererOrg_admin/msp

export FABRIC_CA_SERVER_HOME=$HOME/testnet/crypto-config/fabric-ca/ordererOrg


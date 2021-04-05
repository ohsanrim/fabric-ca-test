
mkdir -p $HOME/testnet/crypto-config/fabric-ca/fabric-ca-client/root-ca

export FABRIC_CA_CLIENT_HOME=$HOME/testnet/crypto-config/fabric-ca/fabric-ca-client

fabric-ca-client enroll -d -u https://rcaadmin:rcaadminpw@fabric-ca:6054 --tls.certfiles tls-root-cert/tls-ca-cert.pem --csr.hosts fabric-ca --mspdir root-ca/rcaadmin/msp

#register and enroll the Intermediate org1 CA admin with the org1 TLS CA
#fabric-ca-client register -d --id.name org1_admin --id.secret org1_adminpw -u https://fabric-ca:6054 --tls.certfiles tls-root-cert/tls-ca-cert.pem --id.attrs '"hf.Registrar.Roles=user,admin","hf.Revoker=true","hf.IntermediateCA=true"' --mspdir root-ca/rcaadmin/msp

#register and enroll the Intermediate org2 CA admin with the org2 TLS CA
#fabric-ca-client register -d --id.name org2_admin --id.secret org2_adminpw -u https://fabric-ca:6054 --tls.certfiles tls-root-cert/tls-ca-cert.pem --id.attrs '"hf.Registrar.Roles=user,admin","hf.Revoker=true","hf.IntermediateCA=true"' --mspdir root-ca/rcaadmin/msp

#register and enroll the Intermediate orderer CA admin with the orderer TLS CA
#fabric-ca-client register -d --id.name ordererOrg_admin --id.secret ordererOrg_adminpw -u https://fabric-ca:6054 --tls.certfiles tls-root-cert/tls-ca-cert.pem --id.attrs '"hf.Registrar.Roles=user,admin","hf.Revoker=true","hf.IntermediateCA=true"' --mspdir root-ca/rcaadmin/msp

fabric-ca-client register -d --id.name admin --id.secret adminpw -u https://fabric-ca:6054 --tls.certfiles tls-root-cert/tls-ca-cert.pem --id.attrs '"hf.Registrar.Roles=user,admin","hf.Revoker=true","hf.IntermediateCA=true"' --mspdir root-ca/rcaadmin/msp

####################################################################
#Deploy an intermediate Org1 CA
mkdir -p $HOME/testnet/crypto-config/fabric-ca/org1/tls
export FABRIC_CA_SERVER_HOME=$HOME/testnet/crypto-config/fabric-ca/org1

cp $HOME/testnet/crypto-config/fabric-ca/fabric-ca-client/tls-ca/org1_admin/msp/signcerts/cert.pem $HOME/testnet/crypto-config/fabric-ca/org1/tls && cp $HOME/testnet/crypto-config/fabric-ca/fabric-ca-client/tls-ca/org1_admin/msp/keystore/* $HOME/testnet/crypto-config/fabric-ca/org1/tls/key.pem

cp $HOME/testnet/crypto-config/fabric-ca/tls/ca-cert.pem $HOME/testnet/crypto-config/fabric-ca/org1/tls/tls-ca-cert.pem

#fabric-ca-server start --port 7054
docker-compose -f docker/docker-compose-org1CA.yaml up -d


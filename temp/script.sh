###########################TLS########################


######################setup orderer#########################
#Enrolling the CA admin
#export FABRIC_CA_CLIENT_TLS_CERTFILES=$HOME/testnet/crypto-config/fabric-ca/ordererOrg/tls-cert.pem
#export FABRIC_CA_CLIENT_HOME=$HOME/testnet/crypto-config/fabric-ca/ordererOrg/admin

mkdir -p $HOME/testnet/crypto-config/ordererOrganizations/example.com
export FABRIC_CA_CLIENT_HOME=${PWD}/crypto-config/ordererOrganizations/example.com

fabric-ca-client enroll -u https://admin:adminpw@0.0.0.0:9054 --caname ca_ordererOrg -M ${PWD}/crypto-config/ordererOrganizations/example.com/msp --tls.certfiles ${PWD}/crypto-config/fabric-ca/ordererOrg/tls-cert.pem

echo 'NodeOUs:
 Enable: true
 ClientOUIdentifier:
   Certificate: cacerts/ca.crt
   OrganizationalUnitIdentifier: client
 PeerOUIdentifier:
   Certificate: cacerts/ca.crt
   OrganizationalUnitIdentifier: peer
 AdminOUIdentifier:
   Certificate: cacerts/ca.crt
   OrganizationalUnitIdentifier: admin
 OrdererOUIdentifier:
   Certificate: cacerts/ca.crt
   OrganizationalUnitIdentifier: orderer' > $HOME/testnet/crypto-config/ordererOrganizations/example.com/msp/config.yaml

#registering orderer
#fabric-ca-client register --caname ca_ordererOrg --id.name orderer --id.secret ordererpw --id.type orderer -u https://0.0.0.0:9054 --tls.certfiles ${PWD}/crypto-config/fabric-ca/ordererOrg/tls-cert.pem
fabric-ca-client register --caname ca_ordererOrg --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/crypto-config/fabric-ca/ordererOrg/tls-cert.pem

#registering the orderer admin
#fabric-ca-client register -d --id.name orderer-admin --id.secret ordereradminpw --id.type admin --id.attrs  "hf.Registrar.Roles=client,hf.Registrar.Attributes=*,hf.Revoker=true,hf.GenCRL=true,admin=true:ecert,abac.init=true:ecert" -u https://0.0.0.0:9054 --tls.certfiles ${PWD}/crypto-config/fabric-ca/ordererOrg/tls-cert.pem
fabric-ca-client register --caname ca_ordererOrg --id.name orderer-admin --id.secret ordereradminpw --id.type admin --tls.certfiles ${PWD}/crypto-config/fabric-ca/ordererOrg/tls-cert.pem

#generating the orderer(orderer, tls-msp directory maked)
#fabric-ca-client enroll -d -u https://orderer:ordererpw@0.0.0.0:9054 -M $HOME/testnet/crypto-config/ordererOrganizations/example.com/msp --tls.certfiles ${PWD}/crypto-config/fabric-ca/ordererOrg/tls-cert.pem

mkdir -p $HOME/testnet/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com

fabric-ca-client enroll -d -u https://orderer:ordererpw@0.0.0.0:9054 --caname ca_ordererOrg -M $HOME/testnet/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/msp --tls.certfiles ${PWD}/crypto-config/fabric-ca/ordererOrg/tls-cert.pem


cp ${PWD}/crypto-config/ordererOrganizations/example.com/msp/config.yaml ${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/config.yaml

fabric-ca-client enroll -d -u https://orderer:ordererpw@0.0.0.0:9054 --caname ca_ordererOrg -M $HOME/testnet/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/tls --enrollment.profile tls --csr.hosts orderer --tls.certfiles ${PWD}/crypto-config/fabric-ca/ordererOrg/tls-cert.pem

mkdir $HOME/testnet/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts
cp $HOME/testnet/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/tls/tlscacerts/* $HOME/testnet/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem


#complete
#enroll OrdererOrg admin

mkdir -p $HOME/testnet/crypto-config/ordererOrganizations/example.com/users/Admin@example.com

mkdir -p $HOME/testnet/crypto-config/ordererOrganizations/example.com/msp/admincerts 
cp  $HOME/testnet/crypto-config/fabric-ca/ordererOrg/admin/msp/signcerts/cert.pem $HOME/testnet/crypto-config/ordererOrganizations/example.com/msp/admincerts/orderer-admin-cert.pem

mkdir -p $HOME/testnet/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/admincerts
cp  $HOME/testnet/crypto-config/fabric-ca/ordererOrg/admin/msp/signcerts/cert.pem $HOME/testnet/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/admincerts/orderer-admin-cert.pem

export FABRIC_CA_CLIENT_HOME=$HOME/testnet/crypto-config/ordererOrganizations/example.com/users/Admin@example.com
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://orderer-admin:ordereradminpw@0.0.0.0:9054 --tls.certfiles ${PWD}/crypto-config/fabric-ca/ordererOrg/tls-cert.pem

mkdir -p $HOME/testnet/crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp/admincerts
cp $HOME/testnet/crypto-config/fabric-ca/ordererOrg/admin/msp/signcerts/cert.pem $HOME/testnet/crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp/admincerts/Admin@ordererorg-cert.pem

#TLS 폴더에 server.key, server.crt복사
cp $HOME/testnet/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/tls/tlscacerts/* $HOME/testnet/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/tls/ca.crt
cp $HOME/testnet/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/tls/signcerts/* $HOME/testnet/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/tls/server.crt
cp $HOME/testnet/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/tls/keystore/* $HOME/testnet/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/tls/server.key

cp $HOME/testnet/crypto-config/ordererOrganizations/example.com/msp/config.yaml $HOME/testnet/crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp/config.yaml

mv $HOME/testnet/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/cacerts/*  $HOME/testnet/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/cacerts/ca.crt
mv $HOME/testnet/crypto-config/ordererOrganizations/example.com/msp/cacerts/*  $HOME/testnet/crypto-config/ordererOrganizations/example.com/msp/cacerts/ca.crt

cp -r $HOME/testnet/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/tls $HOME/testnet/crypto-config/ordererOrganizations/example.com/users/Admin@example.com

########################ORG1#########################
mkdir -p $HOME/testnet/crypto-config/peerOrganizations/org1.example.com/msp

export FABRIC_CA_CLIENT_HOME=$HOME/testnet/crypto-config/peerOrganizations/org1.example.com

fabric-ca-client enroll -d -u https://admin:adminpw@0.0.0.0:7054 --tls.certfiles ${PWD}/crypto-config/fabric-ca/org1/tls-cert.pem

echo 'NodeOUs:
 Enable: true
 ClientOUIdentifier:
   Certificate: cacerts/ca.crt
   OrganizationalUnitIdentifier: client
 PeerOUIdentifier:
   Certificate: cacerts/ca.crt
   OrganizationalUnitIdentifier: peer
 AdminOUIdentifier:
   Certificate: cacerts/ca.crt
   OrganizationalUnitIdentifier: admin
 OrdererOUIdentifier:
   Certificate: cacerts/ca.crt
   OrganizationalUnitIdentifier: orderer' > $HOME/testnet/crypto-config/peerOrganizations/org1.example.com/msp/config.yaml
   
#registering peer0,admin,user
fabric-ca-client register -d --id.name peer0 --id.secret peer0PW --id.type peer -u https://0.0.0.0:7054 --tls.certfiles ${PWD}/crypto-config/fabric-ca/org1/tls-cert.pem
fabric-ca-client register -d --id.name peer1 --id.secret peer1PW --id.type peer -u https://0.0.0.0:7054 --tls.certfiles ${PWD}/crypto-config/fabric-ca/org1/tls-cert.pem
fabric-ca-client register -d --id.name admin-org1 --id.secret org1AdminPW --id.type admin -u https://0.0.0.0:7054 --tls.certfiles ${PWD}/crypto-config/fabric-ca/org1/tls-cert.pem
fabric-ca-client register -d --id.name user-org1 --id.secret org1UserPW --id.type user -u https://0.0.0.0:7054 --tls.certfiles ${PWD}/crypto-config/fabric-ca/org1/tls-cert.pem
   
#generatin the peer0 msp
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://peer0:peer0PW@0.0.0.0:7054 -M ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp --tls.certfiles ${PWD}/crypto-config/fabric-ca/org1/tls-cert.pem

cp ${PWD}/crypto-config/peerOrganizations/org1.example.com/msp/config.yaml ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp/config.yaml

#generating the peer-tls certificates
export FABRIC_CA_CLIENT_MSPDIR=tls
fabric-ca-client enroll -d -u https://peer0:peer0PW@0.0.0.0:7054 --enrollment.profile tls --csr.hosts peer0 -M ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls --tls.certfiles ${PWD}/crypto-config/fabric-ca/org1/tls-cert.pem

cp ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/tlscacerts/* ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
cp ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/signcerts/* ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.crt
cp ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/keystore/* ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.key

cp ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/tlscacerts/* ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/ca.crt
cp ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/signcerts/* ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/server.crt
cp ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/keystore/* ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/server.key

mkdir -p ${PWD}/crypto-config/peerOrganizations/org1.example.com/msp/tlscacerts
cp ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/tlscacerts/* ${PWD}/crypto-config/peerOrganizations/org1.example.com/msp/tlscacerts/ca.crt

mkdir -p ${PWD}/crypto-config/peerOrganizations/org1.example.com/msp/tlsca
cp ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/tlscacerts/* ${PWD}/crypto-config/peerOrganizations/org1.example.com/msp/tlsca/tlsca.org1.example.com-cert.pem

mkdir -p ${PWD}/crypto-config/peerOrganizations/org1.example.com/ca
cp ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp/cacerts/*.pem ${PWD}/crypto-config/peerOrganizations/org1.example.com/ca/ca.org1.example.com-cert.pem


fabric-ca-client enroll -d -u https://peer1:peer1PW@0.0.0.0:7054 -M ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/msp --tls.certfiles ${PWD}/crypto-config/fabric-ca/org1/tls-cert.pem


fabric-ca-client enroll -d -u https://peer1:peer1PW@0.0.0.0:7054 -M ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls --enrollment.profile tls --csr.hosts peer1 --tls.certfiles ${PWD}/crypto-config/fabric-ca/org1/tls-cert.pem


#Generating the user msp

fabric-ca-client enroll -d -u https://user-org1:org1UserPW@0.0.0.0:7054 -M ${PWD}/crypto-config/peerOrganizations/org1.example.com/users/User1@org1.example.com/msp --tls.certfiles ${PWD}/crypto-config/fabric-ca/org1/tls-cert.pem

cp $HOME/testnet/crypto-config/peerOrganizations/org1.example.com/msp/config.yaml $HOME/testnet/crypto-config/peerOrganizations/org1.example.com/users/User1@org1.example.com/msp/config.yaml


#Generating the org admin msp
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://admin-org1:org1AdminPW@0.0.0.0:7054 -M ${PWD}/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp --tls.certfiles ${PWD}/crypto-config/fabric-ca/org1/tls-cert.pem

cp $HOME/testnet/crypto-config/peerOrganizations/org1.example.com/msp/config.yaml $HOME/testnet/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/config.yaml

mv $HOME/testnet/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp/cacerts/* $HOME/testnet/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp/cacerts/ca.crt
mv $HOME/testnet/crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/msp/cacerts/* $HOME/testnet/crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/msp/cacerts/ca.crt
mv $HOME/testnet/crypto-config/peerOrganizations/org1.example.com/msp/cacerts/* $HOME/testnet/crypto-config/peerOrganizations/org1.example.com/msp/cacerts/ca.crt

#make admincerts directory
mkdir -p $HOME/testnet/crypto-config/peerOrganizations/org1.example.com/msp/admincerts 
cp  $HOME/testnet/crypto-config/peerOrganizations/org1.example.com/msp/signcerts/cert.pem $HOME/testnet/crypto-config/peerOrganizations/org1.example.com/msp/admincerts/orderer-admin-cert.pem

mkdir -p $HOME/testnet/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp/admincerts
cp  $HOME/testnet/crypto-config/peerOrganizations/org1.example.com/msp/signcerts/cert.pem $HOME/testnet/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp/admincerts/org1-admin-cert.pem

mkdir -p $HOME/testnet/crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/msp/admincerts
cp  $HOME/testnet/crypto-config/peerOrganizations/org1.example.com/msp/signcerts/cert.pem $HOME/testnet/crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/msp/admincerts/org1-admin-cert.pem


###################setup Org2 peers########################
#generatin the peer2 msp
mkdir -p $HOME/testnet/crypto-config/peerOrganizations/org2.example.com/msp

export FABRIC_CA_CLIENT_HOME=$HOME/testnet/crypto-config/peerOrganizations/org2.example.com/

fabric-ca-client enroll -d -u https://admin:adminpw@0.0.0.0:8054 --tls.certfiles ${PWD}/crypto-config/fabric-ca/org2/tls-cert.pem

echo 'NodeOUs:
 Enable: true
 ClientOUIdentifier:
   Certificate: cacerts/ca.crt
   OrganizationalUnitIdentifier: client
 PeerOUIdentifier:
   Certificate: cacerts/ca.crt
   OrganizationalUnitIdentifier: peer
 AdminOUIdentifier:
   Certificate: cacerts/ca.crt
   OrganizationalUnitIdentifier: admin
 OrdererOUIdentifier:
   Certificate: cacerts/ca.crt
   OrganizationalUnitIdentifier: orderer' > $HOME/testnet/crypto-config/peerOrganizations/org2.example.com/msp/config.yaml

fabric-ca-client register -d --id.name peer2 --id.secret peer2PW --id.type peer -u https://0.0.0.0:8054 --tls.certfiles ${PWD}/crypto-config/fabric-ca/org2/tls-cert.pem

fabric-ca-client register -d --id.name admin-org2 --id.secret org2AdminPW --id.type user -u https://0.0.0.0:8054 --tls.certfiles ${PWD}/crypto-config/fabric-ca/org2/tls-cert.pem

fabric-ca-client register -d --id.name user-org2 --id.secret org2UserPW --id.type user -u https://0.0.0.0:8054 --tls.certfiles ${PWD}/crypto-config/fabric-ca/org2/tls-cert.pem


#generating the peer0 msp
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://peer2:peer2PW@0.0.0.0:8054 -M $HOME/testnet/crypto-config/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/msp --tls.certfiles ${PWD}/crypto-config/fabric-ca/org2/tls-cert.pem

cp ${PWD}/crypto-config/peerOrganizations/org2.example.com/msp/config.yaml ${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/msp/config.yaml

#generating the peer0-tls certificates
export FABRIC_CA_CLIENT_MSPDIR=tls
fabric-ca-client enroll -d -u https://peer2:peer2PW@0.0.0.0:8054 --enrollment.profile tls --csr.hosts peer2 -M $HOME/testnet/crypto-config/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/tls --tls.certfiles ${PWD}/crypto-config/fabric-ca/org2/tls-cert.pem

cp ${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/tls/tlscacerts/* ${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/tls/ca.crt
cp ${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/tls/signcerts/* ${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/tls/server.crt
cp ${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/tls/keystore/* ${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/tls/server.key

mkdir -p ${PWD}/crypto-config/peerOrganizations/org2.example.com/msp/tlscacerts
cp ${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/tls/tlscacerts/* ${PWD}/crypto-config/peerOrganizations/org2.example.com/msp/tlscacerts/ca.crt

mkdir -p ${PWD}/crypto-config/peerOrganizations/org2.example.com/msp/tlsca
cp ${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/tls/tlscacerts/* ${PWD}/crypto-config/peerOrganizations/org2.example.com/msp/tlsca/tlsca.org2.example.com-cert.pem

mkdir -p ${PWD}/crypto-config/peerOrganizations/org2.example.com/ca
cp ${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/msp/cacerts/*.pem ${PWD}/crypto-config/peerOrganizations/org2.example.com/ca/ca.org2.example.com-cert.pem

# generating the user msp
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://user-org2:org2UserPW@0.0.0.0:8054 -M ${PWD}/crypto-config/peerOrganizations/org2.example.com/users/User@org2.example.com/msp --tls.certfiles ${PWD}/crypto-config/fabric-ca/org2/tls-cert.pem

cp ${PWD}/crypto-config/peerOrganizations/org2.example.com/msp/config.yaml ${PWD}/crypto-config/peerOrganizations/org2.example.com/users/User@org2.example.com/msp/config.yaml

# generating the org2 admin msp
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://admin-org2:org2AdminPW@0.0.0.0:8054 -M ${PWD}/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp --tls.certfiles ${PWD}/crypto-config/fabric-ca/org2/tls-cert.pem

cp ${PWD}/crypto-config/peerOrganizations/org2.example.com/msp/config.yaml ${PWD}/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/config.yaml

#make admincerts directory
mkdir -p $HOME/testnet/crypto-config/peerOrganizations/org2.example.com/msp/admincerts 
cp  $HOME/testnet/crypto-config/peerOrganizations/org1.example.com/msp/signcerts/cert.pem $HOME/testnet/crypto-config/peerOrganizations/org2.example.com/msp/admincerts/orderer-admin-cert.pem

mkdir -p $HOME/testnet/crypto-config/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/msp/admincerts
cp  $HOME/testnet/crypto-config/peerOrganizations/org2.example.com/msp/signcerts/cert.pem $HOME/testnet/crypto-config/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/msp/admincerts/org2-admin-cert.pem

mv $HOME/testnet/crypto-config/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/msp/cacerts/*  $HOME/testnet/crypto-config/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/msp/cacerts/ca.crt
mv $HOME/testnet/crypto-config/peerOrganizations/org2.example.com/msp/cacerts/*  $HOME/testnet/crypto-config/peerOrganizations/org2.example.com/msp/cacerts/ca.crt

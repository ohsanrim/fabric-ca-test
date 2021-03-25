export VERBOSE=false
. scripts/utils.sh

function createOrg1() {
  infoln "Enrolling the CA admin"
  mkdir -p crypto-config/peerOrganizations/org1.example.com/msp

  export FABRIC_CA_CLIENT_HOME=${PWD}/crypto-config/peerOrganizations/org1.example.com/

  set -x
  fabric-ca-client enroll -u https://org1_admin:org1_adminpw@fabric-ca:7054 --tls.certfiles $HOME/testnet/crypto-config/fabric-ca/fabric-ca-client/tls-root-cert/tls-ca-cert.pem
{ set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: intermediatecerts/fabric-ca-7054.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: intermediatecerts/fabric-ca-7054.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: intermediatecerts/fabric-ca-7054.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: intermediatecerts/fabric-ca-7054.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/crypto-config/peerOrganizations/org1.example.com/msp/config.yaml

infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@fabric-ca:7054 -M ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp --csr.hosts peer0 --tls.certfiles $HOME/testnet/crypto-config/fabric-ca/fabric-ca-client/tls-root-cert/tls-ca-cert.pem

cp ${PWD}/crypto-config/peerOrganizations/org1.example.com/msp/config.yaml ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp/config.yaml

fabric-ca-client enroll -u https://peer0-org1:peer0PW@fabric-ca:10054 -M ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls --enrollment.profile tls --csr.hosts peer0 --tls.certfiles $HOME/testnet/crypto-config/fabric-ca/fabric-ca-client/tls-root-cert/tls-ca-cert.pem

  cp ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/tlscacerts/* ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
  cp ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/signcerts/* ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.crt
  cp ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/keystore/* ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.key

  mkdir -p ${PWD}/crypto-config/peerOrganizations/org1.example.com/msp/tlscacerts
  cp ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/tlscacerts/* ${PWD}/crypto-config/peerOrganizations/org1.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/crypto-config/peerOrganizations/org1.example.com/tlsca
  cp ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/tlscacerts/* ${PWD}/crypto-config/peerOrganizations/org1.example.com/tlsca/tlsca.org1.example.com-cert.pem

  mkdir -p ${PWD}/crypto-config/peerOrganizations/org1.example.com/ca
  cp ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp/cacerts/* ${PWD}/crypto-config/peerOrganizations/org1.example.com/ca/ca.org1.example.com-cert.pem

 infoln "Generating the peer1 msp"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@fabric-ca:7054 -M ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/msp --csr.hosts peer1 --tls.certfiles $HOME/testnet/crypto-config/fabric-ca/fabric-ca-client/tls-root-cert/tls-ca-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/crypto-config/peerOrganizations/org1.example.com/msp/config.yaml ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/msp/config.yaml
#fabric-ca-client register -d --id.name peer1-org1 --id.secret peer1PW --id.type peer -u https://localhost:10054
  infoln "Generating the peer1-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer1-org1:peer1PW@fabric-ca:10054 -M ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls --enrollment.profile tls --csr.hosts peer1 --tls.certfiles $HOME/testnet/crypto-config/fabric-ca/fabric-ca-client/tls-root-cert/tls-ca-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/tlscacerts/* ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/ca.crt
  cp ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/signcerts/* ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/server.crt
  cp ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/keystore/* ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/server.key

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@fabric-ca:7054 -M ${PWD}/crypto-config/peerOrganizations/org1.example.com/users/User1@org1.example.com/msp --tls.certfiles $HOME/testnet/crypto-config/fabric-ca/fabric-ca-client/tls-root-cert/tls-ca-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/crypto-config/peerOrganizations/org1.example.com/msp/config.yaml ${PWD}/crypto-config/peerOrganizations/org1.example.com/users/User1@org1.example.com/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://org1admin:org1adminpw@fabric-ca:7054 -M ${PWD}/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp --tls.certfiles $HOME/testnet/crypto-config/fabric-ca/fabric-ca-client/tls-root-cert/tls-ca-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/crypto-config/peerOrganizations/org1.example.com/msp/config.yaml ${PWD}/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/config.yaml
  
  
}

function createOrg2() {
  infoln "Enrolling the CA admin"
  mkdir -p crypto-config/peerOrganizations/org2.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/crypto-config/peerOrganizations/org2.example.com/

  set -x
  fabric-ca-client enroll -u https://org2_admin:org2_adminpw@fabric-ca:8054 --tls.certfiles $HOME/testnet/crypto-config/fabric-ca/fabric-ca-client/tls-root-cert/tls-ca-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: intermediatecerts/fabric-ca-8054.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: intermediatecerts/fabric-ca-8054.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: intermediatecerts/fabric-ca-8054.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: intermediatecerts/fabric-ca-8054.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/crypto-config/peerOrganizations/org2.example.com/msp/config.yaml


  infoln "Generating the peer2 msp"
  set -x
  fabric-ca-client enroll -u https://peer2:peer2pw@fabric-ca:8054 -M ${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/msp --csr.hosts peer2 --tls.certfiles $HOME/testnet/crypto-config/fabric-ca/fabric-ca-client/tls-root-cert/tls-ca-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/crypto-config/peerOrganizations/org2.example.com/msp/config.yaml ${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/msp/config.yaml
  
  infoln "Generating the peer2-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer2-org2:peer2PW@fabric-ca:10054 -M ${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/tls --enrollment.profile tls --csr.hosts peer2 --tls.certfiles $HOME/testnet/crypto-config/fabric-ca/fabric-ca-client/tls-root-cert/tls-ca-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/tls/tlscacerts/* ${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/tls/ca.crt
  cp ${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/tls/signcerts/* ${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/tls/server.crt
  cp ${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/tls/keystore/* ${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/tls/server.key

  mkdir -p ${PWD}/crypto-config/peerOrganizations/org2.example.com/msp/tlscacerts
  cp ${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/tls/tlscacerts/* ${PWD}/crypto-config/peerOrganizations/org2.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/crypto-config/peerOrganizations/org2.example.com/tlsca
  cp ${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/tls/tlscacerts/* ${PWD}/crypto-config/peerOrganizations/org2.example.com/tlsca/tlsca.org2.example.com-cert.pem

  mkdir -p ${PWD}/crypto-config/peerOrganizations/org2.example.com/ca
  cp ${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/msp/cacerts/* ${PWD}/crypto-config/peerOrganizations/org2.example.com/ca/ca.org2.example.com-cert.pem

  infoln "Generating the peer3 msp"
  set -x
  fabric-ca-client enroll -u https://peer3:peer3pw@fabric-ca:8054 -M ${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer3.org2.example.com/msp --csr.hosts peer3 --tls.certfiles $HOME/testnet/crypto-config/fabric-ca/fabric-ca-client/tls-root-cert/tls-ca-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/crypto-config/peerOrganizations/org2.example.com/msp/config.yaml ${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer3.org2.example.com/msp/config.yaml
  
  infoln "Generating the peer3-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer3-org2:peer3PW@fabric-ca:10054 -M ${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer3.org2.example.com/tls --enrollment.profile tls --csr.hosts peer3 --tls.certfiles $HOME/testnet/crypto-config/fabric-ca/fabric-ca-client/tls-root-cert/tls-ca-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer3.org2.example.com/tls/tlscacerts/* ${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer3.org2.example.com/tls/ca.crt
  cp ${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer3.org2.example.com/tls/signcerts/* ${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer3.org2.example.com/tls/server.crt
  cp ${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer3.org2.example.com/tls/keystore/* ${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer3.org2.example.com/tls/server.key


  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@fabric-ca:8054 -M ${PWD}/crypto-config/peerOrganizations/org2.example.com/users/User1@org2.example.com/msp --tls.certfiles $HOME/testnet/crypto-config/fabric-ca/fabric-ca-client/tls-root-cert/tls-ca-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/crypto-config/peerOrganizations/org2.example.com/msp/config.yaml ${PWD}/crypto-config/peerOrganizations/org2.example.com/users/User1@org2.example.com/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://org2admin:org2adminpw@fabric-ca:8054 -M ${PWD}/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp --tls.certfiles $HOME/testnet/crypto-config/fabric-ca/fabric-ca-client/tls-root-cert/tls-ca-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/crypto-config/peerOrganizations/org2.example.com/msp/config.yaml ${PWD}/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/config.yaml
}


function createOrderer() {
  infoln "Enrolling the CA admin"
  mkdir -p crypto-config/ordererOrganizations/example.com
  
  export FABRIC_CA_CLIENT_HOME=${PWD}/crypto-config/ordererOrganizations/example.com

  set -x
  fabric-ca-client enroll -u https://ordererOrg_admin:ordererOrg_adminpw@fabric-ca:9054 -M ${PWD}/crypto-config/ordererOrganizations/example.com/msp --tls.certfiles $HOME/testnet/crypto-config/fabric-ca/fabric-ca-client/tls-root-cert/tls-ca-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: intermediatecerts/fabric-ca-9054.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: intermediatecerts/fabric-ca-9054.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: intermediatecerts/fabric-ca-9054.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: intermediatecerts/fabric-ca-9054.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/crypto-config/ordererOrganizations/example.com/msp/config.yaml



  infoln "Generating the orderer msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@fabric-ca:9054 -M ${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/msp --csr.hosts orderer0 --csr.hosts fabric-ca --tls.certfiles $HOME/testnet/crypto-config/fabric-ca/fabric-ca-client/tls-root-cert/tls-ca-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/crypto-config/ordererOrganizations/example.com/msp/config.yaml ${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/config.yaml
  
  infoln "Generating the orderer-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer0-org:orderer0PW@fabric-ca:10054 -M ${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/tls --enrollment.profile tls --csr.hosts orderer0 --tls.certfiles $HOME/testnet/crypto-config/fabric-ca/fabric-ca-client/tls-root-cert/tls-ca-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/tls/tlscacerts/* ${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/tls/ca.crt
  cp ${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/tls/signcerts/* ${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/tls/server.crt
  cp ${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/tls/keystore/* ${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/tls/server.key

  mkdir -p ${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts
  cp ${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/tls/tlscacerts/* ${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  mkdir -p ${PWD}/crypto-config/ordererOrganizations/example.com/msp/tlscacerts
  cp ${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/tls/tlscacerts/* ${PWD}/crypto-config/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  infoln "Generating the admin msp"
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@fabric-ca:9054 -M ${PWD}/crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp --tls.certfiles $HOME/testnet/crypto-config/fabric-ca/fabric-ca-client/tls-root-cert/tls-ca-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/crypto-config/ordererOrganizations/example.com/msp/config.yaml ${PWD}/crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp/config.yaml
  
}

MODE=$1
PEER_NUM=$2

if [ "$MODE" == "org1" ]; then
  createOrg1 
elif [ "$MODE" == "org2" ]; then
  createOrg2 
elif [ "$MODE" == "all" ]; then 
  createOrg1
  createOrg2
  createOrderer
fi

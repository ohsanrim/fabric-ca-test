#!/bin/bash
function createTLS(){
  infoln "Enrolling the CA tls"
  mkdir -p crypto-config/fabric-ca/tls/admin
  #cp $HOME/testnet/crypto-config/fabric-ca/tls/ca-cert.pem $HOME/testnet/crypto-config/fabric-ca/tls/tls-ca-cert.pem
  
  export FABRIC_CA_CLIENT_TLS_CERTFILES=$HOME/testnet/crypto-config/fabric-ca/tls/tls-cert.pem
  export FABRIC_CA_CLIENT_HOME=crypto-config/fabric-ca/tls/admin
  fabric-ca-client enroll -d -u https://tls-ca-admin:tls-ca-adminpw@localhost:10054 --caname ca_tls --tls.certfiles ${PWD}/crypto-config/fabric-ca/tls/tls-cert.pem
  fabric-ca-client register -d --id.name peer0-org1 --id.secret peer0PW --id.type peer -u https://localhost:10054 --tls.certfiles ${PWD}/crypto-config/fabric-ca/tls/tls-cert.pem
  fabric-ca-client register -d --id.name peer1-org1 --id.secret peer1PW --id.type peer -u https://localhost:10054 --tls.certfiles ${PWD}/crypto-config/fabric-ca/tls/tls-cert.pem
  fabric-ca-client register -d --id.name peer2-org2 --id.secret peer2PW --id.type peer -u https://localhost:10054 --tls.certfiles ${PWD}/crypto-config/fabric-ca/tls/tls-cert.pem
  fabric-ca-client register -d --id.name peer3-org2 --id.secret peer3PW --id.type peer -u https://localhost:10054 --tls.certfiles ${PWD}/crypto-config/fabric-ca/tls/tls-cert.pem
  fabric-ca-client register -d --id.name orderer0-org --id.secret orderer0PW --id.type orderer -u https://localhost:10054 --tls.certfiles ${PWD}/crypto-config/fabric-ca/tls/tls-cert.pem

}
function createOrg1() {
  infoln "Enrolling the CA admin"
  mkdir -p crypto-config/peerOrganizations/org1.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/crypto-config/peerOrganizations/org1.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca_org1 --tls.certfiles ${PWD}/crypto-config/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca_org1.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca_org1.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca_org1.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca_org1.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/crypto-config/peerOrganizations/org1.example.com/msp/config.yaml

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca_org1 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/crypto-config/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca_org1 --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/crypto-config/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca_org1 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/crypto-config/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca_org1 --id.name org1admin --id.secret org1adminpw --id.type admin --tls.certfiles ${PWD}/crypto-config/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca_org1 -M ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp --csr.hosts peer0 --tls.certfiles ${PWD}/crypto-config/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/crypto-config/peerOrganizations/org1.example.com/msp/config.yaml ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp/config.yaml
#fabric-ca-client register -d --id.name peer0-org1 --id.secret peer0PW --id.type peer -u https://localhost:10054
  infoln "Generating the peer0-tls certificates" #add
  set -x
  fabric-ca-client enroll -u https://peer0-org1:peer0PW@localhost:10054 --caname ca_tls -M ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls --enrollment.profile tls --csr.hosts peer0 --tls.certfiles ${PWD}/crypto-config/fabric-ca/tls/tls-cert.pem  #add
  { set +x; } 2>/dev/null

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
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca_org1 -M ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/msp --csr.hosts peer1 --tls.certfiles ${PWD}/crypto-config/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/crypto-config/peerOrganizations/org1.example.com/msp/config.yaml ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/msp/config.yaml
#fabric-ca-client register -d --id.name peer1-org1 --id.secret peer1PW --id.type peer -u https://localhost:10054
  infoln "Generating the peer1-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer1-org1:peer1PW@localhost:10054 --caname ca_tls -M ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls --enrollment.profile tls --csr.hosts peer1 --tls.certfiles ${PWD}/crypto-config/fabric-ca/tls/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/tlscacerts/* ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/ca.crt
  cp ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/signcerts/* ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/server.crt
  cp ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/keystore/* ${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/server.key

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca_org1 -M ${PWD}/crypto-config/peerOrganizations/org1.example.com/users/User1@org1.example.com/msp --tls.certfiles ${PWD}/crypto-config/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/crypto-config/peerOrganizations/org1.example.com/msp/config.yaml ${PWD}/crypto-config/peerOrganizations/org1.example.com/users/User1@org1.example.com/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://org1admin:org1adminpw@localhost:7054 --caname ca_org1 -M ${PWD}/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp --tls.certfiles ${PWD}/crypto-config/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/crypto-config/peerOrganizations/org1.example.com/msp/config.yaml ${PWD}/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/config.yaml
  
  
}

function createOrg2() {
  infoln "Enrolling the CA admin"
  mkdir -p crypto-config/peerOrganizations/org2.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/crypto-config/peerOrganizations/org2.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca_org2 --tls.certfiles ${PWD}/crypto-config/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca_org2.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca_org2.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca_org2.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca_org2.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/crypto-config/peerOrganizations/org2.example.com/msp/config.yaml

  infoln "Registering peer2"
  set -x
  fabric-ca-client register --caname ca_org2 --id.name peer2 --id.secret peer2pw --id.type peer --tls.certfiles ${PWD}/crypto-config/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null
  
  infoln "Registering peer3"
  set -x
  fabric-ca-client register --caname ca_org2 --id.name peer3 --id.secret peer3pw --id.type peer --tls.certfiles ${PWD}/crypto-config/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca_org2 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/crypto-config/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca_org2 --id.name org2admin --id.secret org2adminpw --id.type admin --tls.certfiles ${PWD}/crypto-config/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer2 msp"
  set -x
  fabric-ca-client enroll -u https://peer2:peer2pw@localhost:8054 --caname ca_org2 -M ${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/msp --csr.hosts peer2 --tls.certfiles ${PWD}/crypto-config/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/crypto-config/peerOrganizations/org2.example.com/msp/config.yaml ${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/msp/config.yaml
#fabric-ca-client register -d --id.name peer2-org2 --id.secret peer2PW --id.type peer -u https://localhost:10054
  infoln "Generating the peer2-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer2-org2:peer2PW@localhost:10054 --caname ca_tls -M ${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/tls --enrollment.profile tls --csr.hosts peer2 --tls.certfiles ${PWD}/crypto-config/fabric-ca/tls/tls-cert.pem
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
  fabric-ca-client enroll -u https://peer3:peer3pw@localhost:8054 --caname ca_org2 -M ${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer3.org2.example.com/msp --csr.hosts peer3 --tls.certfiles ${PWD}/crypto-config/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/crypto-config/peerOrganizations/org2.example.com/msp/config.yaml ${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer3.org2.example.com/msp/config.yaml
#fabric-ca-client register -d --id.name peer3-org2 --id.secret peer3PW --id.type peer -u https://localhost:10054
  infoln "Generating the peer3-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer3-org2:peer3PW@localhost:10054 --caname ca_tls -M ${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer3.org2.example.com/tls --enrollment.profile tls --csr.hosts peer3 --tls.certfiles ${PWD}/crypto-config/fabric-ca/tls/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer3.org2.example.com/tls/tlscacerts/* ${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer3.org2.example.com/tls/ca.crt
  cp ${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer3.org2.example.com/tls/signcerts/* ${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer3.org2.example.com/tls/server.crt
  cp ${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer3.org2.example.com/tls/keystore/* ${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer3.org2.example.com/tls/server.key


  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca_org2 -M ${PWD}/crypto-config/peerOrganizations/org2.example.com/users/User1@org2.example.com/msp --tls.certfiles ${PWD}/crypto-config/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/crypto-config/peerOrganizations/org2.example.com/msp/config.yaml ${PWD}/crypto-config/peerOrganizations/org2.example.com/users/User1@org2.example.com/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://org2admin:org2adminpw@localhost:8054 --caname ca_org2 -M ${PWD}/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp --tls.certfiles ${PWD}/crypto-config/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/crypto-config/peerOrganizations/org2.example.com/msp/config.yaml ${PWD}/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/config.yaml
}


function createOrderer() {
  infoln "Enrolling the CA admin"
  mkdir -p crypto-config/ordererOrganizations/example.com
  
  export FABRIC_CA_CLIENT_HOME=${PWD}/crypto-config/ordererOrganizations/example.com

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca_ordererOrg -M ${PWD}/crypto-config/ordererOrganizations/example.com/msp --tls.certfiles ${PWD}/crypto-config/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca_ordererOrg.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca_ordererOrg.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca_ordererOrg.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca_ordererOrg.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/crypto-config/ordererOrganizations/example.com/msp/config.yaml

  infoln "Registering orderer"
  set -x
  fabric-ca-client register --caname ca_ordererOrg --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/crypto-config/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the orderer admin"
  set -x
  fabric-ca-client register --caname ca_ordererOrg --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/crypto-config/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the orderer msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca_ordererOrg -M ${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/msp --csr.hosts orderer0 --csr.hosts localhost --tls.certfiles ${PWD}/crypto-config/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/crypto-config/ordererOrganizations/example.com/msp/config.yaml ${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/config.yaml
#  fabric-ca-client register -d --id.name orderer0-org --id.secret orderer0PW --id.type orderer -u https://localhost:10054
  infoln "Generating the orderer-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer0-org:orderer0PW@localhost:10054 --caname ca_tls -M ${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/tls --enrollment.profile tls --csr.hosts orderer0 --tls.certfiles ${PWD}/crypto-config/fabric-ca/tls/tls-cert.pem
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
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca_ordererOrg -M ${PWD}/crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp --tls.certfiles ${PWD}/crypto-config/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/crypto-config/ordererOrganizations/example.com/msp/config.yaml ${PWD}/crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp/config.yaml
}


#!/bin/bash
function createTLS(){
  infoln "Enrolling the CA tls"
  mkdir -p crypto-config/fabric-ca/tls/admin
  #cp $HOME/testnet/crypto-config/fabric-ca/tls/ca-cert.pem $HOME/testnet/crypto-config/fabric-ca/tls/tls-ca-cert.pem
  
  export FABRIC_CA_CLIENT_TLS_CERTFILES=$HOME/testnet/crypto-config/fabric-ca/tls/tls-cert.pem
  export FABRIC_CA_CLIENT_HOME=crypto-config/fabric-ca/tls/admin
  fabric-ca-client enroll -d -u https://tls-ca-admin:tls-ca-adminpw@fabric-ca:10054 --caname ca_tls --tls.certfiles ${PWD}/crypto-config/fabric-ca/tls/tls-cert.pem
  fabric-ca-client register -d --id.name peer0-org1 --id.secret peer0PW --id.type peer -u https://fabric-ca:10054 --tls.certfiles ${PWD}/crypto-config/fabric-ca/tls/tls-cert.pem
  fabric-ca-client register -d --id.name peer1-org1 --id.secret peer1PW --id.type peer -u https://fabric-ca:10054 --tls.certfiles ${PWD}/crypto-config/fabric-ca/tls/tls-cert.pem
  fabric-ca-client register -d --id.name peer2-org2 --id.secret peer2PW --id.type peer -u https://fabric-ca:10054 --tls.certfiles ${PWD}/crypto-config/fabric-ca/tls/tls-cert.pem
  fabric-ca-client register -d --id.name peer3-org2 --id.secret peer3PW --id.type peer -u https://fabric-ca:10054 --tls.certfiles ${PWD}/crypto-config/fabric-ca/tls/tls-cert.pem
  fabric-ca-client register -d --id.name orderer0-org --id.secret orderer0PW --id.type orderer -u https://fabric-ca:10054 --tls.certfiles ${PWD}/crypto-config/fabric-ca/tls/tls-cert.pem

}
function createOrg1() {
  infoln "Enrolling the CA admin"
  mkdir -p crypto-config/peerOrganizations/org1.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/crypto-config/peerOrganizations/org1.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@fabric-ca:7054 --caname ca_org1 --tls.certfiles ${PWD}/crypto-config/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

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

}

function createOrg2() {
  infoln "Enrolling the CA admin"
  mkdir -p crypto-config/peerOrganizations/org2.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/crypto-config/peerOrganizations/org2.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@fabric-ca:8054 --caname ca_org2 --tls.certfiles ${PWD}/crypto-config/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

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

}


function createOrderer0() {
  infoln "Enrolling the CA admin"
  mkdir -p crypto-config/ordererOrganizations/example.com
  
  export FABRIC_CA_CLIENT_HOME=${PWD}/crypto-config/ordererOrganizations/example.com

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@fabric-ca:9054 --caname ca_ordererOrg -M ${PWD}/crypto-config/ordererOrganizations/example.com/msp --tls.certfiles ${PWD}/crypto-config/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null


  infoln "Registering orderer"
  set -x
  fabric-ca-client register --caname ca_ordererOrg --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/crypto-config/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the orderer admin"
  set -x
  fabric-ca-client register --caname ca_ordererOrg --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/crypto-config/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

}


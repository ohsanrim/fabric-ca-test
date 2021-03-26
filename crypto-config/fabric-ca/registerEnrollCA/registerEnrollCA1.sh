####################################################################
#tls server start 
export FABRIC_CA_SERVER_HOME=$HOME/testnet/crypto-config/fabric-ca/tls
#fabric-ca-server start -b tls-ca-admin:tls-ca-adminpw --port 10054
docker-compose -f docker/docker-compose-tls-ca.yaml up -d

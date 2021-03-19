export VERBOSE=false

. scripts/utils.sh

function clearContainers() {
  docker rm -f $(docker ps -a -q)
}

function removeUnwantedImages() {
  DOCKER_IMAGE_IDS=$(docker images | awk '($1 ~ /dev-peer.*/) {print $3}')
  if [ -z "$DOCKER_IMAGE_IDS" -o "$DOCKER_IMAGE_IDS" == " " ]; then
    infoln "No images available for deletion"
  else
    docker rmi -f $DOCKER_IMAGE_IDS
  fi
}

function networkUp(){
  if [  "$CRYPTO" == "Certificate Authorities" ]; then
    #start with CA
    if [ "$TYPE" == "orderer0" ]; then
      ./crypto-config/fabric-ca/registerEnroll.sh all
      configtxgen -profile TwoOrgsOrdererGenesis -channelID system-channel -outputBlock system-genesis-block/genesis.block
      orderer start >&log.txt
    elif [ "$TYPE" == "peer0" ]; then
      ./crypto-config/fabric-ca/registerEnroll.sh org1
      PWD=$HOME/testnet/peer/org1/peer0
      peer node start >&log.txt
    elif [ "$TYPE" == "peer1" ]; then
      ./crypto-config/fabric-ca/registerEnroll.sh org1
      PWD=$HOME/testnet/peer/org1/peer1
      peer node start >&log.txt
    elif [ "$TYPE" == "peer2" ]; then
      ./crypto-config/fabric-ca/registerEnroll.sh org2
      PWD=$HOME/testnet/peer/org2/peer2
      peer node start >&log.txt 
    elif [ "$TYPE" == "peer3" ]; then 
      ./crypto-config/fabric-ca/registerEnroll.sh $TYPE
      PWD=$HOME/testnet/peer/org2/peer
      peer node start >&log.txt
    elif [ "$TYPE" == "FABRIC_CA" ]; then
    infoln "Generating certificates using Fabric CA"

    IMAGE_TAG=${CA_IMAGETAG} docker-compose -f $COMPOSE_FILE_CA up -d 2>&1

    . crypto-config/fabric-ca/registerEnrollCA.sh

  while :
    do
      if [ ! -f "$HOME/testnet/crypto-config/fabric-ca/tls/tls-cert.pem" ]; then
        sleep 1
      else
        break
      fi
    done

    infoln "Creating TLS Identities"

    createTLS

    infoln "Creating Org1 Identities"

    createOrg1

    infoln "Creating Org2 Identities"

    createOrg2

    infoln "Creating Orderer Org Identities"

    createOrderer0
    
    docker ps -a
    
    ./transport.sh
    if [ $? -ne 0 ]; then
      fatalln "Unable to start network"
    fi
  fi
       
  elif [ "$CRYPTO" == "cryptogen" ]; then
    #start with cryptogen
      if [ ! -f "$HOME/testnet/crypto-config/fabric-ca/tls/ca-cert.pem" ]; then
        errorln "certificate files not found..."
        break
      else 
        orderer start >&log.txt
      fi
   fi
}

function createChannel() {
  # Bring up the network if it is not already up.

  if [ ! -d "crypto-config/peerOrganizations" ]; then
    infoln "Bringing up network"
    networkUp
  fi
  
  scripts/createChannel.sh $CHANNEL_NAME $CLI_DELAY $MAX_RETRY $VERBOSE
}

function deployCC() {
  scripts/deployCC.sh $CHANNEL_NAME $CC_NAME $CC_SRC_PATH $CC_SRC_LANGUAGE $CC_VERSION $CC_SEQUENCE $CC_INIT_FCN $CC_END_POLICY $CC_COLL_CONFIG $CLI_DELAY $MAX_RETRY $VERBOSE

  if [ $? -ne 0 ]; then
    fatalln "Deploying chaincode failed"
  fi
}

function stopOrderer(){

    docker-compose -f $COMPOSE_FILE_CA down --volumes --remove-orphans
    clearContainers
    #Cleanup images
    removeUnwantedImages
infoln "Stopping network" 
    docker run --rm -v $(pwd):/data busybox sh -c 'cd /data && rm -rf system-genesis-block/*.block crypto-config/peerOrganizations crypto-config/ordererOrganizations'
     
    docker run --rm -v $(pwd):/data busybox sh -c 'cd /data && rm -rf crypto-config/fabric-ca/org1/msp crypto-config/fabric-ca/org1/ca-cert.pem crypto-config/fabric-ca/org1/tls-cert.pem crypto-config/fabric-ca/org1/IssuerPublicKey crypto-config/fabric-ca/org1/IssuerRevocationPublicKey crypto-config/fabric-ca/org1/fabric-ca-server.db'
    
    docker run --rm -v $(pwd):/data busybox sh -c 'cd /data && rm -rf crypto-config/fabric-ca/org2/msp crypto-config/fabric-ca/org2/tls-cert.pem crypto-config/fabric-ca/org2/ca-cert.pem crypto-config/fabric-ca/org2/IssuerPublicKey crypto-config/fabric-ca/org2/IssuerRevocationPublicKey crypto-config/fabric-ca/org2/fabric-ca-server.db'
    
    docker run --rm -v $(pwd):/data busybox sh -c 'cd /data && rm -rf crypto-config/fabric-ca/ordererOrg/msp crypto-config/fabric-ca/ordererOrg/tls-cert.pem crypto-config/fabric-ca/ordererOrg/ca-cert.pem crypto-config/fabric-ca/ordererOrg/IssuerPublicKey crypto-config/fabric-ca/ordererOrg/IssuerRevocationPublicKey crypto-config/fabric-ca/ordererOrg/fabric-ca-server.db'
    
    docker run --rm -v $(pwd):/data busybox sh -c 'cd /data && rm -rf crypto-config/fabric-ca/tls/msp crypto-config/fabric-ca/tls/tls-cert.pem crypto-config/fabric-ca/tls/ca-cert.pem crypto-config/fabric-ca/tls/IssuerPublicKey crypto-config/fabric-ca/tls/IssuerRevocationPublicKey crypto-config/fabric-ca/tls/fabric-ca-server.db crypto-config/fabric-ca/tls/admin'
    
    docker run --rm -v $(pwd):/data busybox sh -c 'cd /data && rm -rf Org1MSPanchors.tx Org1MSPconfig.json Org1MSPmodified_config.json Org2MSPanchors.tx Org2MSPconfig.json Org2MSPmodified_config.json config_update.json config_update.pb config_update_in_envelope.json modified_config.pb original_config.pb config_block.pb'
    
    docker run --rm -v $(pwd):/data busybox sh -c 'cd /data && rm -rf channel-artifacts log.txt *.tar.gz'
    
    docker run --rm -v $(pwd):/data busybox sh -c 'cd /data && rm -rf /tmp/hyperledger'
    
    infoln "all files removed..."
}

OS_ARCH=$(echo "$(uname -s | tr '[:upper:]' '[:lower:]' | sed 's/mingw64_nt.*/windows/')-$(uname -m | sed 's/x86_64/amd64/g')" | awk '{print tolower($0)}')
# Using crpto vs CA. default is cryptogen
CRYPTO="cryptogen"
# timeout duration - the duration the CLI should wait for a response from
# another container before giving up
MAX_RETRY=5
# default for delay between commands
CLI_DELAY=3
# channel name defaults to "mychannel"
CHANNEL_NAME="mychannel"
# chaincode name defaults to "NA"
CC_NAME="NA"
# chaincode path defaults to "NA"
CC_SRC_PATH="NA"
# endorsement policy defaults to "NA". This would allow chaincodes to use the majority default policy.
CC_END_POLICY="NA"
# collection configuration defaults to "NA"
CC_COLL_CONFIG="NA"
# chaincode init function defaults to "NA"
CC_INIT_FCN="NA"
# use this as the default docker-compose yaml definition
COMPOSE_FILE_BASE=docker/docker-compose-test-net.yaml
# docker-compose.yaml file if you are using couchdb
COMPOSE_FILE_COUCH=docker/docker-compose-couch.yaml
# certificate authorities compose file
COMPOSE_FILE_CA=docker/docker-compose-ca.yaml
# use this as the docker compose couch file for org3
COMPOSE_FILE_COUCH_ORG3=addOrg3/docker/docker-compose-couch-org3.yaml
# use this as the default docker-compose yaml definition for org3
COMPOSE_FILE_ORG3=addOrg3/docker/docker-compose-org3.yaml
#
# chaincode language defaults to "NA"
CC_SRC_LANGUAGE="NA"
# Chaincode version
CC_VERSION="1.0"
# Chaincode definition sequence
CC_SEQUENCE=1
# default image tag
IMAGETAG="latest"
# default ca image tag
CA_IMAGETAG="latest"
# default database
DATABASE="leveldb"
TYPE="FABRIC_CA"
if [[ $# -lt 1 ]] ; then
  printHelp
  exit 0
else
  MODE=$1
  shift
fi

# parse a createChannel subcommand if used
if [[ $# -ge 1 ]] ; then
  key="$1"
  if [[ "$key" == "createChannel" ]]; then
      export MODE="createChannel"
      shift
  fi
fi


while [[ $# -ge 1 ]] ; do
  key="$1"
  case $key in
  -h )
    printHelp $MODE
    exit 0
    ;;
  -t )
    TYPE="$2"
    shift
    ;;
  -c )
    CHANNEL_NAME="$2"
    shift
    ;;
  -p )
    FILE_PATH="$2"
    shift
    ;;    
  -ca )
    CRYPTO="Certificate Authorities"
    ;;
  -r )
    MAX_RETRY="$2"
    shift
    ;;
  -d )
    CLI_DELAY="$2"
    shift
    ;;
  -s )
    DATABASE="$2"
    shift
    ;;
  -ccl )
    CC_SRC_LANGUAGE="$2"
    shift
    ;;
  -ccn )
    CC_NAME="$2"
    shift
    ;;
  -ccv )
    CC_VERSION="$2"
    shift
    ;;
  -ccs )
    CC_SEQUENCE="$2"
    shift
    ;;
  -ccp )
    CC_SRC_PATH="$2"
    shift
    ;;
  -ccep )
    CC_END_POLICY="$2"
    shift
    ;;
  -cccg )
    CC_COLL_CONFIG="$2"
    shift
    ;;
  -cci )
    CC_INIT_FCN="$2"
    shift
    ;;
  -i )
    IMAGETAG="$2"
    shift
    ;;
  -cai )
    CA_IMAGETAG="$2"
    shift
    ;;
  -verbose )
    VERBOSE=true
    shift
    ;;
  * )
    errorln "Unknown flag: $key"
    printHelp
    exit 1
    ;;
  esac
  shift
done

if [ "$MODE" == "up" ]; then
  infoln "Start network"  
  networkUp
elif [ "${MODE}" == "createChannel" ]; then
  createChannel  
elif [ "${MODE}" == "deployCC" ]; then
  deployCC  
elif [ "$MODE" == "down" ]; then
  stopOrderer
fi

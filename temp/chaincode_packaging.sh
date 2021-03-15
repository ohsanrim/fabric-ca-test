cd chaincode/chaincode-go
cat go.mod
GO111MODULE=on go mod vendor
cd ../../
peer lifecycle chaincode package basic.tar.gz --path chaincode/chaincode-go/ --lang golang --label basic_1.0

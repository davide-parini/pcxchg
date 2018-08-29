#!/bin/bash
set -e
#set -x

echo -e "\E[1;32m### CHANNELS SETUP BY AMAZON\E[0m"
docker exec cli.Amazon bash -c '/etc/hyperledger/scripts/amazon.sh'

echo -e "\E[1;32m### CHANNELS JOIN BY VENDORS\E[0m"
docker exec cli.Asus bash -c 'peer channel join -b asus.block'
docker exec cli.Dell bash -c 'peer channel join -b dell.block'
docker exec cli.HP bash   -c 'peer channel join -b hp.block'

echo -e "\E[1;32m### CHANNELS UPDATE\E[0m"
docker exec cli.Asus bash -c 'peer channel update -o orderer.pcxchg.com:7050 -c asus -f ./channels/asusanchor.tx'
docker exec cli.Dell bash -c 'peer channel update -o orderer.pcxchg.com:7050 -c dell -f ./channels/dellanchor.tx'
docker exec cli.HP bash   -c 'peer channel update -o orderer.pcxchg.com:7050 -c hp   -f ./channels/hpanchor.tx'

docker exec cli.Amazon bash -c 'peer channel update -o orderer.pcxchg.com:7050 -c asus -f ./channels/amazonanchorasus.tx'
docker exec cli.Amazon bash -c 'peer channel update -o orderer.pcxchg.com:7050 -c dell -f ./channels/amazonanchordell.tx'
docker exec cli.Amazon bash -c 'peer channel update -o orderer.pcxchg.com:7050 -c hp   -f ./channels/amazonanchorhp.tx'

echo -e "\E[1;32m### CHAINCODE INSTALL (producer)\E[0m"
docker exec cli.Amazon bash -c "peer chaincode install -p producer -n producer -v 0"
docker exec cli.Asus bash   -c "peer chaincode install -p producer -n producer -v 0"
docker exec cli.Dell bash   -c "peer chaincode install -p producer -n producer -v 0"
docker exec cli.HP bash     -c "peer chaincode install -p producer -n producer -v 0"

echo -e "\E[1;32m### CHAINCODE INSTALL (market)\E[0m"
docker exec cli.Amazon bash -c "peer chaincode install -p market -n market -v 0"

echo -e "\E[1;32m### CHAINCODE INSTANTIATE (producer)\E[0m"
docker exec cli.Asus bash -c "peer chaincode instantiate -C asus -n producer -v 0 -c '{\"Args\":[]}' -P OR\(\'AsusMSP.member\'\)"
docker exec cli.Dell bash -c "peer chaincode instantiate -C dell -n producer -v 0 -c '{\"Args\":[]}' -P OR\(\'DellMSP.member\'\)"
docker exec cli.HP bash   -c "peer chaincode instantiate -C hp   -n producer -v 0 -c '{\"Args\":[]}' -P OR\(\'HPMSP.member\'\)"

echo -e "\E[1;32m### CHAINCODE INSTANTIATE (market)\E[0m"
docker exec cli.Amazon bash -c "peer chaincode instantiate -C asus -n market -v 0 -c '{\"Args\":[]}' -P OR\(\'AmazonMSP.member\'\)"
docker exec cli.Amazon bash -c "peer chaincode instantiate -C dell -n market -v 0 -c '{\"Args\":[]}' -P OR\(\'AmazonMSP.member\'\)"
docker exec cli.Amazon bash -c "peer chaincode instantiate -C hp   -n market -v 0 -c '{\"Args\":[]}' -P OR\(\'AmazonMSP.member\'\)"

echo -e "\E[1;32m### FILLING LEDGER\E[0m"
docker exec cli.Asus bash -c "peer chaincode invoke -C asus -n producer -c '{\"Args\":[\"createPC\", \"Asus001\", \"foo\", \"bar\"]}'"
docker exec cli.Asus bash -c "peer chaincode invoke -C asus -n producer -c '{\"Args\":[\"createPC\", \"Asus002\", \"foo\", \"bar\"]}'"
docker exec cli.Asus bash -c "peer chaincode invoke -C asus -n producer -c '{\"Args\":[\"createPC\", \"Asus003\", \"foo\", \"bar\"]}'"
docker exec cli.Dell bash -c "peer chaincode invoke -C dell -n producer -c '{\"Args\":[\"createPC\", \"Dell001\", \"foo\", \"bar\"]}'"
docker exec cli.Dell bash -c "peer chaincode invoke -C dell -n producer -c '{\"Args\":[\"createPC\", \"Dell002\", \"foo\", \"bar\"]}'"
docker exec cli.Dell bash -c "peer chaincode invoke -C dell -n producer -c '{\"Args\":[\"createPC\", \"Dell003\", \"foo\", \"bar\"]}'"
docker exec cli.Dell bash -c "peer chaincode invoke -C dell -n producer -c '{\"Args\":[\"createPC\", \"Dell004\", \"foo\", \"bar\"]}'"
docker exec cli.HP bash   -c "peer chaincode invoke -C hp   -n producer -c '{\"Args\":[\"createPC\", \"HP002\",   \"foo\", \"bar\"]}'"
docker exec cli.HP bash   -c "peer chaincode invoke -C hp   -n producer -c '{\"Args\":[\"createPC\", \"HP001\",   \"foo\", \"bar\"]}'"

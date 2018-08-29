#!/bin/bash
set -e
#set -x

CHAINCODE=$1
V_OLD=$2
V_NEW=$3

echo Replacing chaincode $CHAINCODE version $V_OLD with version $V_NEW...

echo -e "\E[1;32m### INSTALLING NEW CHAINCODE\E[0m"
docker exec cli.Amazon bash -c "peer chaincode install -p $CHAINCODE -n $CHAINCODE -v $V_NEW"
docker exec cli.Asus   bash -c "peer chaincode install -p $CHAINCODE -n $CHAINCODE -v $V_NEW"
docker exec cli.Dell   bash -c "peer chaincode install -p $CHAINCODE -n $CHAINCODE -v $V_NEW"
docker exec cli.HP     bash -c "peer chaincode install -p $CHAINCODE -n $CHAINCODE -v $V_NEW"

echo -e "\E[1;32m### UPGRADING CHAINCODE\E[0m"
docker exec cli.Asus bash -c "peer chaincode upgrade -C asus -n $CHAINCODE -v $V_NEW -c '{\"Args\":[]}'"
docker exec cli.Dell bash -c "peer chaincode upgrade -C dell -n $CHAINCODE -v $V_NEW -c '{\"Args\":[]}'"
docker exec cli.HP   bash -c "peer chaincode upgrade -C hp   -n $CHAINCODE -v $V_NEW -c '{\"Args\":[]}'"

echo -e "\E[1;32m### STOPPING CONTAINERS\E[0m"
docker stop $(docker ps -a -q -f "name=$CHAINCODE-$V_OLD")

echo -e "\E[1;32m### DELETING CONTAINERS\E[0m"
docker rm   $(docker ps -a -q -f "name=$CHAINCODE-$V_OLD")

echo -e "\E[1;32m### DELETEING IMAGES\E[0m"
docker rmi  $(docker images --format "{{.ID}}" -f "reference=*$CHAINCODE-$V_OLD*")

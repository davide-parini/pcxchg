#!/bin/bash
set -e -x

CHAINCODE=$1
V_OLD=$2
V_NEW=$3

echo Replacing chaincode $CHAINCODE version $V_OLD with version $V_NEW...

echo \#\#\# INSTALLING NEW CHAINCODE
docker exec cli.Amazon bash -c "peer chaincode install -p $CHAINCODE -n $CHAINCODE -v $V_NEW"
docker exec cli.Asus   bash -c "peer chaincode install -p $CHAINCODE -n $CHAINCODE -v $V_NEW"
docker exec cli.Dell   bash -c "peer chaincode install -p $CHAINCODE -n $CHAINCODE -v $V_NEW"
docker exec cli.HP     bash -c "peer chaincode install -p $CHAINCODE -n $CHAINCODE -v $V_NEW"

echo \#\#\# UPGRADING CHAINCODE
docker exec cli.Asus bash -c "peer chaincode upgrade -C asus -n $CHAINCODE -v $V_NEW -c '{\"Args\":[]}'"
docker exec cli.Dell bash -c "peer chaincode upgrade -C dell -n $CHAINCODE -v $V_NEW -c '{\"Args\":[]}'"
docker exec cli.HP   bash -c "peer chaincode upgrade -C hp   -n $CHAINCODE -v $V_NEW -c '{\"Args\":[]}'"

echo \#\#\# STOPPING CONTAINERS
docker stop $(docker ps -a -q -f "name=$CHAINCODE-$V_OLD")

echo \#\#\# DELETING CONTAINERS
docker rm   $(docker ps -a -q -f "name=$CHAINCODE-$V_OLD")

echo \#\#\# DELETEING IMAGES
docker rmi  $(docker images --format "{{.ID}}" -f "reference=*$CHAINCODE-$V_OLD*")

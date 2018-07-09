set -e -x

echo Replacing chaincode version $1 with version $2...

echo \#\#\# INSTALLING NEW CHAINCODE
docker exec cli.Amazon bash -c "peer chaincode install -p pcxchg -n pcxchg -v $2"
docker exec cli.Asus   bash -c "peer chaincode install -p pcxchg -n pcxchg -v $2"
docker exec cli.Dell   bash -c "peer chaincode install -p pcxchg -n pcxchg -v $2"
docker exec cli.HP     bash -c "peer chaincode install -p pcxchg -n pcxchg -v $2"

echo \#\#\# UPGRADING CHAINCODE
docker exec cli.Asus bash -c "peer chaincode upgrade -C asus -n pcxchg -v $2 -c '{\"Args\":[]}'"
docker exec cli.Dell bash -c "peer chaincode upgrade -C dell -n pcxchg -v $2 -c '{\"Args\":[]}'"
docker exec cli.HP   bash -c "peer chaincode upgrade -C hp   -n pcxchg -v $2 -c '{\"Args\":[]}'"

echo \#\#\# STOPPING CONTAINERS
docker stop $(docker ps -a -q -f "name=pcxchg-$1")

echo \#\#\# DELETING CONTAINERS
docker rm   $(docker ps -a -q -f "name=pcxchg-$1")

echo \#\#\# DELETEING IMAGES
docker rmi  $(docker images --format "{{.ID}}" -f "reference=*pcxchg-$1*")

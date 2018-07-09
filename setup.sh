set -e -x

echo \#\#\# CHANNELS SETUP BY AMAZON
docker exec cli.Amazon bash -c '/etc/hyperledger/scripts/amazon.sh'

echo \#\#\# CHANNELS JOIN BY VENDORS
docker exec cli.Asus bash -c 'peer channel join -b asus.block'
docker exec cli.Dell bash -c 'peer channel join -b dell.block'
docker exec cli.HP bash   -c 'peer channel join -b hp.block'

echo \#\#\# CHANNELS UPDATE
docker exec cli.Asus bash -c 'peer channel update -o orderer.pcxchg.com:7050 -c asus -f ./channels/asusanchor.tx'
docker exec cli.Dell bash -c 'peer channel update -o orderer.pcxchg.com:7050 -c dell -f ./channels/dellanchor.tx'
docker exec cli.HP bash   -c 'peer channel update -o orderer.pcxchg.com:7050 -c hp   -f ./channels/hpanchor.tx'

docker exec cli.Amazon bash -c 'peer channel update -o orderer.pcxchg.com:7050 -c asus -f ./channels/amazonanchorasus.tx'
docker exec cli.Amazon bash -c 'peer channel update -o orderer.pcxchg.com:7050 -c dell -f ./channels/amazonanchordell.tx'
docker exec cli.Amazon bash -c 'peer channel update -o orderer.pcxchg.com:7050 -c hp   -f ./channels/amazonanchorhp.tx'

echo \#\#\# CHAINCODE INSTALL
docker exec cli.Amazon bash -c 'peer chaincode install -p pcxchg -n pcxchg -v 0'
docker exec cli.Asus bash   -c 'peer chaincode install -p pcxchg -n pcxchg -v 0'
docker exec cli.Dell bash   -c 'peer chaincode install -p pcxchg -n pcxchg -v 0'
docker exec cli.HP bash     -c 'peer chaincode install -p pcxchg -n pcxchg -v 0'

echo \#\#\# CHAINCODE INSTANTIATE
docker exec cli.Asus bash -c "peer chaincode instantiate -C asus -n pcxchg -v 0 -c '{\"Args\":[]}'"
docker exec cli.Dell bash -c "peer chaincode instantiate -C dell -n pcxchg -v 0 -c '{\"Args\":[]}'"
docker exec cli.HP bash   -c "peer chaincode instantiate -C hp   -n pcxchg -v 0 -c '{\"Args\":[]}'"

echo \#\#\# FILLING LEDGER
docker exec cli.Asus bash -c "peer chaincode invoke -C asus -n pcxchg -c '{\"Args\":[\"createPC\", \"Asus001\", \"foo\", \"bar\"]}'"
docker exec cli.Asus bash -c "peer chaincode invoke -C asus -n pcxchg -c '{\"Args\":[\"createPC\", \"Asus002\", \"foo\", \"bar\"]}'"
docker exec cli.Asus bash -c "peer chaincode invoke -C asus -n pcxchg -c '{\"Args\":[\"createPC\", \"Asus003\", \"foo\", \"bar\"]}'"
docker exec cli.Dell bash -c "peer chaincode invoke -C dell -n pcxchg -c '{\"Args\":[\"createPC\", \"Dell001\", \"foo\", \"bar\"]}'"
docker exec cli.Dell bash -c "peer chaincode invoke -C dell -n pcxchg -c '{\"Args\":[\"createPC\", \"Dell002\", \"foo\", \"bar\"]}'"
docker exec cli.Dell bash -c "peer chaincode invoke -C dell -n pcxchg -c '{\"Args\":[\"createPC\", \"Dell003\", \"foo\", \"bar\"]}'"
docker exec cli.Dell bash -c "peer chaincode invoke -C dell -n pcxchg -c '{\"Args\":[\"createPC\", \"Dell004\", \"foo\", \"bar\"]}'"
docker exec cli.HP bash   -c "peer chaincode invoke -C hp   -n pcxchg -c '{\"Args\":[\"createPC\", \"HP001\",   \"foo\", \"bar\"]}'"
docker exec cli.HP bash   -c "peer chaincode invoke -C hp   -n pcxchg -c '{\"Args\":[\"createPC\", \"HP002\",   \"foo\", \"bar\"]}'"

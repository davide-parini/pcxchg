peer channel create -c asus -f ./channels/Asus.tx -o orderer.pcxchg.com:7050
peer channel create -c dell -f ./channels/Dell.tx -o orderer.pcxchg.com:7050
peer channel create -c hp   -f ./channels/HP.tx   -o orderer.pcxchg.com:7050

peer channel join -b asus.block
peer channel join -b dell.block
peer channel join -b hp.block
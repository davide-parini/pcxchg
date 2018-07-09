set -e -x

echo \#\#\# STOPPING CONTAINERS
docker stop $(docker ps -a -q -f "name=pcxchg-")

echo \#\#\# DELETING CONTAINERS
docker rm   $(docker ps -a -q -f "name=pcxchg-")

echo \#\#\# DELETEING IMAGES
docker rmi  $(docker images --format "{{.ID}}" -f "reference=*pcxchg-*")

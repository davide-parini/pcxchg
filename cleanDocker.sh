#!/bin/bash
set -e -x

echo \#\#\# STOPPING CONTAINERS
docker stop $(docker ps -a -q -f "name=dev-")

echo \#\#\# DELETING CONTAINERS
docker rm   $(docker ps -a -q -f "name=dev-")

echo \#\#\# DELETEING IMAGES
docker rmi  $(docker images --format "{{.ID}}" -f "reference=dev-*")

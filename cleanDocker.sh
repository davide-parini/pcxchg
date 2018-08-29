#!/bin/bash
set -e
#set -x

echo -e "\E[1;32m### STOPPING CONTAINERS\E[0m"
docker stop $(docker ps -a -q -f "name=dev-peer")

echo -e "\E[1;32m### DELETING CONTAINERS\E[0m"
docker rm   $(docker ps -a -q -f "name=dev-peer")

echo -e "\E[1;32m### DELETEING IMAGES\E[0m"
docker rmi  $(docker images --format "{{.ID}}" -f "reference=dev-peer*")

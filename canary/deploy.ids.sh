#!/bin/sh
clear
docker ps -a | grep "/bin/sh" | awk '{ print $1 }' | xargs docker container rm -f 
docker image list | grep none | awk '{print $3}' | xargs docker image rm

OS=ubuntu
# OS=centos
docker build -t "msec/${OS}:v1" -f ids.${OS}.Dockerfile .

docker run -d "msec/${OS}:v1" /bin/sh
docker ps -a
CONTAINER_ID=`docker ps -a | grep "msec/${OS}:*" | awk '{ print $1 }'`
docker exec -it ${CONTAINER_ID} /bin/sh -c "ls -la ."
docker exec -it ${CONTAINER_ID} /bin/sh
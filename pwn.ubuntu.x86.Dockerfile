FROM ubuntu:19.04
LABEL maintainer="tomagoyaky <tomagoyaky@gmail.com>" app="msec-ubuntu-ids"
ENV VERSION=1.0.0 DEBUG=on NAME="MSEC-IDS"
VOLUME /var/docker-local
WORKDIR /var/docker-local
# ADD *.c /var/docker-local
# ADD Makefile /var/docker-local
RUN apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y && apt-get install apt-utils libelf-dev gcc g++ make build-essential linux-headers-$(uname -r) -y
RUN cd /var/docker-local && make
ENTRYPOINT top -b -H > /dev/null

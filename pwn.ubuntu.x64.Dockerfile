FROM ubuntu:19.04
LABEL maintainer="tomagoyaky <tomagoyaky@gmail.com>" app="msec-ubuntu-ids"
ENV VERSION=1.0.0 DEBUG=on NAME="MSEC-IDS"
VOLUME /var/docker-local
WORKDIR /var/docker-local

#apt-get的一个选项--assume-yes,即忽略掉警告信息
RUN apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y && apt-get install --assume-yes tree libelf-dev gcc g++ make -y
# RUN cd /var/docker-local && make
ENTRYPOINT top -b -H > /dev/null

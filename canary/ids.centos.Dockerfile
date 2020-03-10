FROM centos:7.5
LABEL maintainer="tomagoyaky <tomagoyaky@gmail.com>" app="msec-centos-ids"
ENV VERSION=1.0.0 DEBUG=on NAME="MSEC-IDS"
VOLUME /var/docker-local/ids
WORKDIR /var/docker-local/ids
ADD *.c /var/docker-local/ids
ADD Makefile /var/docker-local/ids
RUN apt-get install kernel-headers -y
RUN apt-get install kernel-devel -y
ENTRYPOINT top -b -H > /dev/null

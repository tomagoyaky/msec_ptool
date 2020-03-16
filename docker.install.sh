#!/usr/bin/env bash

# 脚本用于一键安装docker dev环境
clear

sudo yum remove docker \
          docker-client \
          docker-client-latest \
          docker-common \
          docker-latest \
          docker-latest-logrotate \
          docker-logrotate \
          docker-engine && \
echo "-----------------------------------------" && \
echo "| >>> remove finish ..." && \
echo "-----------------------------------------" && \
sudo yum install -y yum-utils \
          device-mapper-persistent-data \
          lvm2 && \
echo "-----------------------------------------" && \
echo "| >>> install docker-depends ok ..." && \
echo "-----------------------------------------" && \
sudo yum-config-manager \
          --add-repo \
          https://download.docker.com/linux/centos/docker-ce.repo &&
sudo yum install -y docker-ce docker-ce-cli containerd.io && \
sudo groupadd docker && \
sudo gpasswd -a ${USER} docker && \
sudo service docker restart && \
newgrp - docker && \
echo "-----------------------------------------" && \
echo "| >>> install docker and docker-cli ok ..." && \
echo "-----------------------------------------" && \
docker -v && \
echo "-----------------------------------------" && \
echo "| >>> install docker-compose ..." && \
echo "-----------------------------------------" && \
sudo yum install -y python-devel
if [ ! -f 'get-pip.py' ];then
  curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
fi
sudo python get-pip.py && \
sudo pip install --ignore-installed requests && \
sudo pip install --upgrade pip && \
sudo pip install six --user -U && \
sudo pip install docker-compose && \
docker-compose -v
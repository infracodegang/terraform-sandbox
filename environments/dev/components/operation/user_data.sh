#!/bin/sh

# docker
amazon-linux-extras install -y docker
systemctl start docker
systemctl enable docker

# mysql 5.7
yum install -y https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
yum-config-manager --disable mysql80-community
yum-config-manager --enable mysql57-community
yum install -y mysql-community-client

# mysql 8.0
# yum install -y https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
# yum-config-manager --enable mysql80-community
# yum-config-manager --disable mysql57-community
# yum install -y mysql-community-client

# redis
amazon-linux-extras install -y epel
yum install -y redis

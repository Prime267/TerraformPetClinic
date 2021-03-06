#!/bin/bash

yum update
yum install docker -y
systemctl enable docker.service
systemctl start docker.service
docker run --name mariadbPetClinic -e MYSQL_PASSWORD=${pass} -e MYSQL_USER=${user} -e MYSQL_ROOT_PASSWORD=${root_pass} -e MYSQL_DATABASE=${database} -p 3306:3306 -d docker.io/library/mariadb:latest


#!/bin/bash
echo 'Random changes for testing'>/home/newfileFromTerraform
yum update
yum install docker -y
systemctl enable docker.service
systemctl start docker.service
docker run --name mariadbPetClinic -e MYSQL_PASSWORD=petclinic -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=petclinic -p 3306:3306 -d docker.io/library/mariadb:latest



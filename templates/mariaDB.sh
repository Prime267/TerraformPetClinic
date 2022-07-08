#!/bin/bash
#echo "${var.pass}----${var.root_pass}----${database}----var.database">/home/newfileFromTerraform
yum update
yum install docker -y
systemctl enable docker.service
systemctl start docker.service
#docker run --name mariadbPetClinic -e MYSQL_PASSWORD=${var.MYSQL_PASSWORD} -e MYSQL_ROOT_PASSWORD=${var.MYSQL_ROOT_PASSWORD} -e MYSQL_DATABASE=${MYSQL_DATABASE} -p 3306:3306 -d docker.io/library/mariadb:latest



#!/bin/bash

export MYSQL_PASS=${MYSQL_PASS} 
export MYSQL_URL=${MYSQL_URL} 
export MYSQL_USER=${MYSQL_USER}

wget https://gitlab.com/bogdan.sh.ua/Demo/-/jobs/2708915634/artifacts/download?file_type=archive -O /petclinic
unzip /petclinic/artifacts.zip .

# wget https://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
# sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
# yum install apache-maven -y 
yum install java-1.8.0-devel -y
# yum install git -y
# cd / && mkdir petclinic
# cd /petclinic && git clone https://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@github.com/Rudya93/Demo.git
# chmod -R 777 /petclinic
# cd /petclinic/Demo && sudo ./mvnw package

java -Dspring.profiles.active=mysql -jar spring-petclinic-2.7.0-SNAPSHOT.jar

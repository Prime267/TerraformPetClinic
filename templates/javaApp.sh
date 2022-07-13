#!/bin/bash

export MYSQL_PASS=${MYSQL_PASS} 
export MYSQL_URL=${MYSQL_URL} 
export MYSQL_USER=${MYSQL_USER}

# mkdir /petclinicWget && wget https://gitlab.com/bogdan.sh.ua/Demo/-/jobs/artifacts/master/download?job=build -O /petclinic
# unzip /petclinicWget/artifacts.zip .

mkdir /petclinic && aws s3 cp s3://my-s3-bucket-0001/spring-petclinic-2.3.1.BUILD-SNAPSHOT.jar /petclinic
yum install java-1.8.0-devel -y
java -Dspring.profiles.active=mysql -jar /petclinic/spring-petclinic*.jar

# wget https://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
# sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
# yum install apache-maven -y 
# yum install git -y
# cd / && mkdir petclinic
# cd /petclinic && git clone https://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@github.com/Rudya93/Demo.git
# chmod -R 777 /petclinic
# cd /petclinic/Demo && sudo ./mvnw package


# yum install java-1.8.0-devel -y
# java -Dspring.profiles.active=mysql -jar spring-petclinic-*-SNAPSHOT.jar

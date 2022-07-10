#!/bin/bash

sudo wget https://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
sudo sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
sudo yum install -y apache-maven
sudo yum install java-1.8.0-devel
sudo yum install git -y
cd /home && git clone https://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@github.com/Rudya93/Demo.git
cd Demo && sudo bash mvnw package




resource "aws_instance" "ec2_javaApp" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.javaApp_securityGroup.id]
  subnet_id              = aws_subnet.myPublicSubnet.id
  #associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.my_profile.name
  #user_data                   = "${data.template_file.provision.rendered}"
  #iam_instance_profile = "${aws_iam_instance_profile.some_profile.id}"
  #depends_on = [aws_subnet.myPublicSubnet, aws_security_group.javaApp_securityGroup, aws_iam_role.ssm-role]

  tags = {
    Name = "Terra-javaApp"
  }
}



resource "aws_instance" "ec2_dataBase" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.javaApp_securityGroup.id]
  subnet_id              = aws_subnet.myPublicSubnet.id
  private_ip             = var.db_connection_data["private_ip"]
  #associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.my_profile.name
  #user_data                   = "${data.template_file.provision.rendered}"
  #iam_instance_profile = "${aws_iam_instance_profile.some_profile.id}"
  #depends_on = [aws_subnet.myPublicSubnet, aws_security_group.db_securityGroup, aws_iam_role.ssm-role]
  tags = {
    Name = "Terra-dataBase"
  }

  user_data = <<EOF
#!/bin/bash
yum update
yum install docker -y
systemctl enable docker.service
systemctl start docker.service
docker run --name mariadbPetClinic -e MYSQL_PASSWORD=petclinic -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=petclinic -p 3306:3306 -d docker.io/library/mariadb:latest
EOF

}

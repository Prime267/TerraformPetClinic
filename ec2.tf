data "aws_ami" "amazon-linux-2" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

}

data "template_file" "db_script" {
  template = file("${path.module}/templates/mariaDB.sh")
  vars     = { pass = var.MYSQL_PASSWORD, root_pass = var.MYSQL_ROOT_PASSWORD, database = var.MYSQL_DATABASE }
}

# Render a multi-part cloud-init config making use of the part
# above, and other source files
# data "template_cloudinit_config" "db_config" {
#   gzip          = true
#   base64_encode = true

#   # Main cloud-config configuration file.
#   part {
#   content = data.template_file.db_script.template
#    }
# }

resource "aws_instance" "ec2_javaApp" {
  ami                    = data.aws_ami.amazon-linux-2.id
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
  ami                    = data.aws_ami.amazon-linux-2.id
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

  #user_data = data.template_file.db_script.rendered
  user_data = templatefile("templates/mariaDB.sh", { pass = var.MYSQL_PASSWORD, root_pass = var.MYSQL_ROOT_PASSWORD, database = var.MYSQL_DATABASE })

}

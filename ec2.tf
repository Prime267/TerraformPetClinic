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

# data "aws_ami" "ubuntu" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#   }

#   filter {
#     name   = "architecture"
#     values = ["x86_64"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

# }


data "template_file" "db_script" {
  template = file("${path.module}/templates/db.sh")
  vars     = { pass = var.MYSQL_PASSWORD, user = var.MYSQL_USER, root_pass = var.MYSQL_ROOT_PASSWORD, database = var.MYSQL_DATABASE }
}

data "template_cloudinit_config" "db_config" {
  gzip          = true
  base64_encode = true
  # Main cloud-config configuration file.
  part {
    content = data.template_file.db_script.rendered
  }
}


data "template_file" "javaApp_script" {
  template = file("${path.module}/templates/javaApp.sh")
  vars     = { MYSQL_PASS = var.MYSQL_PASSWORD, MYSQL_USER = var.MYSQL_USER, MYSQL_URL = "jdbc:mysql://${aws_instance.ec2_dataBase.private_ip}:${var.db_connection_data["port"]}/${var.MYSQL_DATABASE}" } # vars will be added later, maybe
}

data "template_cloudinit_config" "javaApp_config" {
  gzip          = true
  base64_encode = true
  # Main cloud-config configuration file.
  part {
    content = data.template_file.javaApp_script.rendered
  }
}


resource "aws_instance" "ec2_dataBase" {
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.db_securityGroup.id]
  subnet_id              = aws_subnet.myPublicSubnet.id
  private_ip             = var.db_connection_data["private_ip"]
  iam_instance_profile   = aws_iam_instance_profile.my_profile.name
  user_data              = data.template_cloudinit_config.db_config.rendered
  tags = {
    Name = "Terra-dataBase"
  }
}

resource "aws_instance" "ec2_javaApp" {
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.javaApp_securityGroup.id]
  subnet_id              = aws_subnet.myPublicSubnet.id
  iam_instance_profile   = aws_iam_instance_profile.my_profile.name
  user_data              = data.template_cloudinit_config.javaApp_config.rendered

  tags = {
    Name = "Terra-javaApp"
  }
}


resource "aws_s3_bucket" "b" {

  bucket = "my-s3-bucket-0001"

}

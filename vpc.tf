# VPC
resource "aws_vpc" "terra_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "Terra-VPC"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "terra_igw" {
  vpc_id = aws_vpc.terra_vpc.id
  tags = {
    Name = "Terra-IGW"
  }
}

# Subnets : public
resource "aws_subnet" "myPublicSubnet" {
  vpc_id                  = aws_vpc.terra_vpc.id
  cidr_block              = var.subnet_cidr
  availability_zone       = var.aws_az
  map_public_ip_on_launch = true
  tags = {
    Name = "Terra-Subnet"
  }
}

resource "aws_security_group" "javaApp_securityGroup" {
  name   = "Terra-SG"
  vpc_id = aws_vpc.terra_vpc.id
  #Incoming traffic
  ingress {
    from_port   = var.javaApp_port
    to_port     = var.javaApp_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #replace it with your ip address
  }

  #Outgoing traffic
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db_securityGroup" {
  name   = "DB-SG"
  vpc_id = aws_vpc.terra_vpc.id
  #Incoming traffic
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.subnet_cidr, "0.0.0.0/0"] #replace it with your ip address
  }

  #Outgoing traffic
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}



# Route table: attach Internet Gateway 
resource "aws_route_table" "terra_public_rt" {
  vpc_id = aws_vpc.terra_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terra_igw.id
  }
  tags = {
    Name = "Terra-RouteTable"
  }
}

# Route table association with public subnets
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.myPublicSubnet.id
  route_table_id = aws_route_table.terra_public_rt.id
}


# 创建 VPC
resource "aws_vpc" "jenkins" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "vpc-jenkins"
  }
}

# 创建 Internet Gateway
resource "aws_internet_gateway" "ig_jenkins" {
  vpc_id = aws_vpc.jenkins.id

  tags = {
    Name = "ig-jenkins"
  }
}

# 创建公共子网
resource "aws_subnet" "sn_jenkins" {
  vpc_id                  = aws_vpc.jenkins.id
  cidr_block              = var.public-subnet-cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "sn-jenkins"
  }
}

# 创建路由表
resource "aws_route_table" "rt_jenkins" {
  vpc_id = aws_vpc.jenkins.id

  # 0.0.0.0/0 指向 Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig_jenkins.id
  }

  # 10.0.0.0/16 指向 VPC 内部
  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }

  tags = {
    Name = "rt-jenkins"
  }
}

# 将路由表关联到子网
resource "aws_route_table_association" "rta_jenkins" {
  subnet_id      = aws_subnet.sn_jenkins.id
  route_table_id = aws_route_table.rt_jenkins.id
}

# 创建安全组
resource "aws_security_group" "sg_jenkins" {
  vpc_id = aws_vpc.jenkins.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-jenkins"
  }
}

resource "aws_key_pair" "jenkins-ec2-key" {
  key_name   = "jenkins-key" // 定义密钥对的名称
  public_key = var.aws_key_pair-pub

  tags = {
    Name = "jenkins-ec2-key"
  }
}
locals {
  ec2-ami = data.aws_ami.ami-ec2-jenkins.id
}

# 创建 EC2 实例
resource "aws_instance" "jenkins" {
  key_name                    = aws_key_pair.jenkins-ec2-key.key_name
  ami                         = data.aws_ami.ami-ec2-jenkins # Ubuntu 22.04 AMI ID
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.sn_jenkins.id
  security_groups             = [aws_security_group.sg_jenkins.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              apt update && apt -y upgrade
              curl -sSL https://get.docker.com | bash
              EOF

  tags = {
    Name = "jenkins-ec2"
  }

}

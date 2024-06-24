data "aws_ami" "ami-ec2-jenkins" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-20.08-amd64-server-*"]
  }

  filter {
    name   = "virtualization - type"
    values = ["hvm"]
  }

  owners = ["AWS"]
}

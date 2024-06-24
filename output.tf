output "ec2-public_ip" {

  value = {

    ec2-public_ip = aws_instance.jenkins.public_ip
  }
}

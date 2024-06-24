# 仅在工作空间为 "prod" 时输出 prod 的 public_ip
output "ec2-prod-public_ip" {
  value = terraform.workspace == "prod" ? aws_instance.jenkins-prod[0].public_ip : null


}

# 仅在工作空间为 "dev" 时输出 dev 的 public_ip
output "ec2-dev-public_ip" {
  value = terraform.workspace == "dev" ? aws_instance.jenkins-dev[0].public_ip : null

}

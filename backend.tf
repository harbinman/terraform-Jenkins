terraform {
  backend "s3" {
    key            = "key/terraform/terraform.tfstate"
    bucket         = "terraformstatefilebucket2077"
    region         = "ap-southeast-1"
    dynamodb_table = "terraformstatetable"

  }
}

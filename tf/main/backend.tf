terraform {
  backend "s3" {
    bucket         = "wowcher-terraform-states"
    key            = "openvpn/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform_locks"
  }
}
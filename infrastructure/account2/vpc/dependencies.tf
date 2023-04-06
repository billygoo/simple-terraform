data "terraform_remote_state" "account1_vpc" {
  backend = "s3"
  config = {
    bucket                  = "kcd-temp-tf-backend"
    key                     = "account1/vpc/terraform.tfstate"
    region                  = "ap-northeast-2"
    profile                 = "account1"
    shared_credentials_file = "~/.aws/credentials"
  }
}

data "aws_caller_identity" "current" {}

data "terraform_remote_state" "account2_vpc" {
  backend = "s3"
  config = {
    bucket                  = "kcd-temp-tf-backend"
    key                     = "account2/vpc/terraform.tfstate"
    region                  = "ap-northeast-2"
    profile                 = "account1"
    shared_credentials_file = "~/.aws/credentials"
  }
}

data "aws_caller_identity" "current" {}
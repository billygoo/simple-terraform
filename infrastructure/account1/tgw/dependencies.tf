data "terraform_remote_state" "account1" {
  backend = "s3"
  config = {
    bucket                  = "kcd-temp-tf-backend"
    key                     = "account1/terraform.tfstate"
    region                  = "ap-northeast-2"
    profile                 = "account1"
    shared_credentials_file = "~/.aws/credentials"
  }
}

data "terraform_remote_state" "account2" {
  backend = "s3"
  config = {
    bucket                  = "kcd-temp-tf-backend"
    key                     = "account2/terraform.tfstate"
    region                  = "ap-northeast-2"
    profile                 = "account1"
    shared_credentials_file = "~/.aws/credentials"
  }
}

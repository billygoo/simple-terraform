terraform {
  required_version = ">= 1.4.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.60.0"
    }
  }

  backend "s3" {
    encrypt                 = true
    bucket                  = "kcd-temp-tf-backend"
    key                     = "account1/s3/terraform.tfstate"
    region                  = "ap-northeast-2"
    profile                 = "account1"
    shared_credentials_file = "~/.aws/credentials"

    dynamodb_table = "terraform-locks"
  }
}

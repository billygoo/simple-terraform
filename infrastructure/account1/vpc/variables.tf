locals {
  region = "ap-northeast-2"
  az     = "ap-northeast-2a"
  account_id = data.aws_caller_identity.current.account_id
}

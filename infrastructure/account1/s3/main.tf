provider "aws" {
  region                   = "ap-northeast-2"
  profile                  = "account1"
  shared_credentials_files = ["~/.aws/credentials"]
}

resource "aws_s3_bucket" "kcd-temp-tf-backend" {
  bucket        = "kcd-temp-tf-backend"
  force_destroy = "false"

  grant {
    id          = "ac8c991b92f9e1bc417f5e0ffd85d6a4c475f898cc5b490ce5881f7cea6b6311"
    permissions = ["FULL_CONTROL"]
    type        = "CanonicalUser"
  }

  object_lock_enabled = "false"
  request_payer       = "BucketOwner"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }

      bucket_key_enabled = "true"
    }
  }

  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

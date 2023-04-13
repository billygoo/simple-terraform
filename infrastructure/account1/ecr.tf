# IAM 
resource "aws_iam_user" "cicd_bot" {
  name = "cicd_bot"
}

resource "aws_iam_access_key" "cicd_bot_user_access_key" {
  user = aws_iam_user.cicd_bot.name
}

# ECR 
resource "aws_ecr_repository" "ecr" {
  name = "simple-web-server"
}

# ECR Policy
data "aws_iam_policy_document" "ecr_policy" {
  statement {
    sid    = "cicd-bot-policy"
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${local.account_id}:user/cicd_bot",
        "arn:aws:iam::${local.staging_account_id}:user/cicd_bot"
      ]
    }

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
      "ecr:DeleteRepository",
      "ecr:BatchDeleteImage",
      "ecr:SetRepositoryPolicy",
      "ecr:DeleteRepositoryPolicy",
    ]
  }
}

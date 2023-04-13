# ECR 
resource "aws_ecr_repository" "ecr" {
  name = "simple-web-server"
}

# # ECR Policy
data "aws_iam_policy_document" "cicd_bot" {
  statement {
    sid    = "cicdpolicy"
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${local.account_id}:user/smgu1",
        "arn:aws:iam::${local.staging_account_id}:user/smgu2"
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
      "ecr:GetAuthorizationToken"
    ]
  }
}

resource "aws_ecr_repository_policy" "cicd_bot" {
  repository = aws_ecr_repository.ecr.name

  policy = data.aws_iam_policy_document.cicd_bot.json
}

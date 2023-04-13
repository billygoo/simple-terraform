# cicd_bot user for ecr access
resource "aws_iam_user" "cicd_bot" {
  name = "cicd_bot"
}

resource "aws_iam_access_key" "cicd_bot_user_access_key" {
  user = aws_iam_user.cicd_bot.name
}

provider "aws" {
  # change env set first
  region = "us-west-2"
}
resource "aws_iam_user" "lb" {
  name  = "iamuser.${count.index}"
  count = 3
  path  = "/system/"
}

output "arns" {
  value = aws_iam_user.lb[*].arn
}

output "name" {
  value = aws_iam_user.lb[*].name
}

# use Spalat expression and zipmap
output "combined" {
  value = zipmap(aws_iam_user.lb[*].name, aws_iam_user.lb[*].arn)
}

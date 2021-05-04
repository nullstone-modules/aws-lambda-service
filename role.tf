resource "aws_iam_role" "executor" {
  name               = local.resource_name
  assume_role_policy = data.aws_iam_policy_document.executor_assume.json
  tags               = data.ns_workspace.this.tags
}

data "aws_iam_policy_document" "executor_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "executor_basic" {
  role       = aws_iam_role.executor.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "executor_vpc" {
  role       = aws_iam_role.executor.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"

  count = local.has_network ? 1 : 0
}

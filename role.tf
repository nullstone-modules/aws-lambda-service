resource "aws_iam_role" "executor" {
  name               = local.resource_name
  assume_role_policy = data.aws_iam_policy_document.executor_assume.json
  tags               = local.tags
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
}

resource "aws_iam_role_policy" "executor" {
  role   = aws_iam_role.executor.id
  policy = data.aws_iam_policy_document.executor.json
}

locals {
  // These are used to generate an IAM policy statement to allow the app to read the secrets
  existing_arns              = values(local.existing_secret_refs)
  secret_arns                = [for as in aws_secretsmanager_secret.app_secret : as.arn]
  all_arns                   = concat(local.secret_arns, local.existing_arns)
  secret_statement_resources = length(local.all_arns) > 0 ? [local.all_arns] : []
}

data "aws_iam_policy_document" "executor" {
  statement {
    sid       = "AllowBasicSecretsListing"
    effect    = "Allow"
    actions   = ["secretsmanager:ListSecrets"]
    resources = ["*"]
  }

  dynamic "statement" {
    for_each = local.secret_statement_resources

    content {
      sid       = "AllowReadSecrets"
      effect    = "Allow"
      resources = statement.value

      actions = [
        "secretsmanager:GetSecretValue",
        "kms:Decrypt"
      ]
    }
  }
}

locals {
  // Since lambda does not have secret injection, we are going to add a list of env vars mapping the secret ids
  // e.g. POSTGRES_URL => POSTGRES_URL_SECRET_ID = <secret-id>
  app_secret_ids  = { for key in local.secret_keys : "${key}_SECRET_ID" => aws_secretsmanager_secret.app_secret[key].id }
  app_secret_arns = [for key in local.secret_keys : aws_secretsmanager_secret.app_secret[key].arn]
}

resource "aws_secretsmanager_secret" "app_secret" {
  # bridgecrew:skip=CKV2_AWS_57: "Ensure Secrets Manager secrets should have automatic rotation enabled". We cannot automatically rotate user secrets.
  for_each = local.secret_keys

  name       = "${local.resource_name}/${each.value}"
  tags       = local.tags
  kms_key_id = aws_kms_key.this.id
}

resource "aws_secretsmanager_secret_version" "app_secret" {
  for_each = local.secret_keys

  secret_id     = aws_secretsmanager_secret.app_secret[each.value].id
  secret_string = local.all_secrets[each.value]
}

resource "aws_iam_role_policy_attachment" "lambda-secrets" {
  count = length(local.secret_keys) > 0 ? 1 : 0

  role       = aws_iam_role.executor.name
  policy_arn = aws_iam_policy.secrets[count.index].arn
}

resource "aws_iam_policy" "secrets" {
  count = length(local.secret_keys) > 0 ? 1 : 0

  name   = local.resource_name
  policy = data.aws_iam_policy_document.secrets.json
}

data "aws_iam_policy_document" "secrets" {
  dynamic "statement" {
    for_each = length(local.secret_keys) > 0 ? [local.app_secret_arns] : []

    content {
      sid       = "AllowReadSecrets"
      effect    = "Allow"
      resources = [statement.value]
  
      actions = [
        "secretsmanager:GetSecretValue",
        "kms:Decrypt"
      ]
    }
  }
}

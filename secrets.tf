locals {
  // Since lambda does not have secret injection, we are going to add a list of env vars mapping the secret ids
  // e.g. POSTGRES_URL => POSTGRES_URL_SECRET_ID = <secret-id>
  app_secret_ids = { for key in local.secret_keys : "${key}_SECRET_ID" => aws_secretsmanager_secret.app_secret[key].id }
}

resource "aws_secretsmanager_secret" "app_secret" {
  # bridgecrew:skip=CKV2_AWS_57: "Ensure Secrets Manager secrets should have automatic rotation enabled". We cannot automatically rotate user secrets.
  for_each = local.secret_keys

  name                    = "${local.resource_name}/${each.value}"
  tags                    = local.tags
  kms_key_id              = aws_kms_key.this.id
  recovery_window_in_days = 0 // force delete so that re-adding the secret doesn't cause issues

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_secretsmanager_secret_version" "app_secret" {
  for_each = local.secret_keys

  secret_id     = aws_secretsmanager_secret.app_secret[each.value].id
  secret_string = local.all_secrets[each.value]
}

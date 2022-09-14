locals {
  // We use `local.secret_keys` to create secret resources
  // If we used `length(local.capabilities.secrets)`,
  //   terraform would complain about not knowing count of the resource until after apply
  // This is because the name of secrets isn't computed in the modules; only the secret value
  cap_secrets = { for secret in try(local.capabilities.secrets, []) : secret["name"] => secret["value"] }
  all_secrets = merge(local.cap_secrets, var.service_secrets)
  secret_keys = can(nonsensitive(keys(local.all_secrets))) ? toset(nonsensitive(keys(local.all_secrets))) : toset(keys(local.all_secrets))

  // Since lambda does not have secret injection, we are going to add a list of env vars mapping the secret ids
  // e.g. POSTGRES_URL => POSTGRES_URL_SECRET_ID = <secret-id>
  app_secret_ids = { for key in local.secret_keys : "${key}_SECRET_ID" => aws_secretsmanager_secret.app_secret[key].id }
}

resource "aws_secretsmanager_secret" "app_secret" {
  for_each = local.secret_keys

  name = "${local.resource_name}/${each.value}"
  tags = local.tags
}

resource "aws_secretsmanager_secret_version" "app_secret" {
  for_each = local.secret_keys

  secret_id     = aws_secretsmanager_secret.app_secret[each.value].id
  secret_string = local.all_secrets[each.value]
}

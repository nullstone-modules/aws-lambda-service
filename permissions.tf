locals {
  permissions = try(local.capabilities.permissions, [])
}

resource "aws_lambda_permission" "caps" {
  for_each = {for p in local.permissions : p.name => p}

  function_name       = aws_lambda_function.this.function_name
  statement_id_prefix = try(each.value.sid_prefix, null)
  action              = try(each.value.action, null)
  principal           = try(each.value.principal, null)

  source_arn             = try(each.value.source_arn, null)
  source_account         = try(each.value.source_account, null)
  event_source_token     = try(each.value.event_source_token, null)
  qualifier              = try(each.value.qualifier, null)
  principal_org_id       = try(each.value.principal_org_id, null)
  function_url_auth_type = try(each.value.function_url_auth_type, null)
}

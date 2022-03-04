
data "ns_app_env" "this" {
  stack_id = data.ns_workspace.this.stack_id
  app_id   = data.ns_workspace.this.block_id
  env_id   = data.ns_workspace.this.env_id
}

locals {
  app_version = data.ns_app_env.this.version
}

locals {
  app_metadata = tomap({
    // Inject app metadata into capabilities here (e.g. security_group_name, role_name)
    function_arn      = aws_lambda_function.this.arn
    function_name     = local.resource_name
    role_name         = aws_iam_role.executor.name
    role_arn          = aws_iam_role.executor.arn
    security_group_id = try(aws_security_group.this[0].id, "")
    log_group_name    = module.logs.name
  })
}

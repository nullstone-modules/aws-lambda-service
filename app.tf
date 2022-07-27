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
    function_name = local.resource_name
    // We can't use aws_lambda_function.this.arn because it will create a cycle lambda => env => capabilities => lambda
    // NOTE: This *may* introduce a race condition for newly-launched lambdas
    //    e.g. api gateway capability adds an `aws_lambda_permission` before the lambda exists
    function_arn      = "arn:aws:lambda:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:function:${local.resource_name}"
    role_name         = aws_iam_role.executor.name
    role_arn          = aws_iam_role.executor.arn
    security_group_id = aws_security_group.this.id
    log_group_name    = module.logs.name
  })
}

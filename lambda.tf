locals {
  standard_env_vars = tomap({
    NULLSTONE_ENV = data.ns_workspace.this.env_name
  })
  env_vars = {for k, v in merge(local.standard_env_vars, var.service_env_vars) : k => v }
}

resource "aws_lambda_function" "this" {
  function_name = local.resource_name
  handler       = var.service_handler
  role          = aws_iam_role.executor.arn
  runtime       = var.service_runtime
  memory_size   = var.service_memory
  timeout       = var.service_timeout
  tags          = local.tags
  s3_bucket     = aws_s3_bucket.artifacts.bucket
  s3_key        = local.has_artifact ? local.artifact_key : aws_s3_bucket_object.placeholder.key

  dynamic "vpc_config" {
    for_each = local.vpc_configs

    content {
      security_group_ids = vpc_config.value["security_group_ids"]
      subnet_ids         = vpc_config.value["subnet_ids"]
    }
  }

  environment {
    variables = local.env_vars
  }
}

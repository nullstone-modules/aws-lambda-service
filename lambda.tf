resource "aws_lambda_function" "this" {
  function_name = data.ns_workspace.this.hyphenated_name
  handler       = var.service_handler
  role          = aws_iam_role.executor.arn
  runtime       = var.service_runtime
  memory_size   = var.service_memory
  timeout       = var.service_timeout
  tags          = data.ns_workspace.this.tags
  s3_bucket     = aws_s3_bucket.artifacts.arn
  s3_key        = "service-${local.app_version}.zip"

  dynamic "vpc_config" {
    for_each = local.vpc_configs

    content {
      security_group_ids = vpc_config.value["security_group_ids"]
      subnet_ids         = vpc_config.value["subnet_ids"]
    }
  }

  environment {
    variables = var.service_env_vars
  }
}

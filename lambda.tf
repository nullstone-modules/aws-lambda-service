resource "aws_lambda_function" "this" {
  function_name                  = local.resource_name
  handler                        = var.handler
  role                           = aws_iam_role.executor.arn
  runtime                        = var.runtime
  memory_size                    = var.memory
  timeout                        = var.timeout
  tags                           = local.tags
  s3_bucket                      = aws_s3_bucket.artifacts.bucket
  s3_key                         = local.has_artifact ? local.artifact_key : aws_s3_object.placeholder.key
  reserved_concurrent_executions = 100
  kms_key_arn                    = aws_kms_key.this.arn

  vpc_config {
    security_group_ids = [aws_security_group.this.id]
    subnet_ids         = local.private_subnet_ids
  }

  environment {
    variables = local.all_env_vars
  }

  tracing_config {
    mode = "Active"
  }

  dynamic "dead_letter_config" {
    for_each = local.dead_letter_queues

    content {
      target_arn = dead_letter_config.value.queue_arn
    }
  }
}

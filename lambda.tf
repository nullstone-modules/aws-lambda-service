resource "aws_lambda_function" "this" {
  function_name = local.resource_name
  handler       = var.handler
  role          = aws_iam_role.executor.arn
  runtime       = var.runtime
  memory_size   = var.memory
  timeout       = var.timeout
  tags          = local.tags
  s3_bucket     = aws_s3_bucket.artifacts.bucket
  s3_key        = local.has_artifact ? local.artifact_key : aws_s3_object.placeholder.key

  vpc_config {
    security_group_ids = [aws_security_group.this.id]
    subnet_ids         = local.private_subnet_ids
  }

  environment {
    variables = local.all_env_vars
  }
}

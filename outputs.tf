output "artifacts_bucket_arn" {
  value       = aws_s3_bucket.artifacts.arn
  description = "string ||| The ARN of the created S3 bucket."
}

output "artifacts_bucket_name" {
  value       = aws_s3_bucket.artifacts.bucket
  description = "string ||| The name of the created S3 bucket."
}

output "deployer" {
  value = {
    name       = aws_iam_user.deployer.name
    access_key = aws_iam_access_key.deployer.id
    secret_key = aws_iam_access_key.deployer.secret
  }

  description = "object({ name: string, access_key: string, secret_key: string }) ||| An AWS User with explicit privilege to deploy to the S3 bucket."

  sensitive = true
}

output "log_group_name" {
  value       = aws_cloudwatch_log_group.this.name
  description = "string ||| Cloudwatch Log Group for Lambda function"
}

output "lambda_name" {
  value       = aws_lambda_function.this.function_name
  description = "string ||| Lambda Function Name"
}

output "lambda_arn" {
  value       = aws_lambda_function.this.arn
  description = "string ||| Lambda Function ARN"
}

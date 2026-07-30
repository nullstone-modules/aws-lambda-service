output "region" {
  value       = data.aws_region.this.region
  description = "string ||| The region the lambda was created."
}

output "artifacts_bucket_arn" {
  value       = aws_s3_bucket.artifacts.arn
  description = "string ||| The ARN of the created S3 bucket."
}

output "artifacts_bucket_name" {
  value       = aws_s3_bucket.artifacts.bucket
  description = "string ||| The name of the created S3 bucket."
}

output "artifacts_key_template" {
  value       = "service-{{app-version}}.zip"
  description = "string ||| Template for s3 object key that is used for Lambda function ({{app-version}} should be replaced with the app-version)"
}

output "deployer" {
  value       = module.scaffold.deployer
  description = "object({ role_arn: string, session_duration: number }) ||| An IAM role with explicit privilege to publish new Lambda versions, upload artifacts, and invoke the function. Assumable by the Nullstone agent."
}

output "lambda_name" {
  value       = aws_lambda_function.this.function_name
  description = "string ||| Lambda Function Name"
}

output "lambda_arn" {
  value       = aws_lambda_function.this.arn
  description = "string ||| Lambda Function ARN"
}

output "log_provider" {
  value       = "cloudwatch"
  description = "string ||| "
}

output "log_group_name" {
  value       = module.scaffold.log_group.name
  description = "string ||| The name of the cloudwatch log group containing application logs."
}

output "log_reader" {
  value       = module.scaffold.log_reader
  description = "object({ name: string, access_key: string, secret_key: string }) ||| An AWS User with explicit privilege to read logs from Cloudwatch."
  sensitive   = true
}

output "metrics_provider" {
  value       = "cloudwatch"
  description = "string ||| "
}

output "metrics_reader" {
  value       = module.scaffold.log_reader
  description = "object({ name: string, access_key: string, secret_key: string }) ||| An AWS User with explicit privilege to read metrics from Cloudwatch."
  sensitive   = true
}

output "metrics_mappings" {
  value = local.metrics_mappings
}

output "private_urls" {
  value       = local.private_urls
  description = "list(string) ||| A list of URLs only accessible inside the network"
}

output "public_urls" {
  value       = local.public_urls
  description = "list(string) ||| A list of URLs accessible to the public"
}

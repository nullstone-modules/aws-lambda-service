output "region" {
  value       = data.aws_region.this.name
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
  value = {
    name       = aws_iam_user.deployer.name
    access_key = aws_iam_access_key.deployer.id
    secret_key = aws_iam_access_key.deployer.secret
  }

  description = "object({ name: string, access_key: string, secret_key: string }) ||| An AWS User with explicit privilege to deploy to the S3 bucket."

  sensitive = true
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
  value       = module.logs.name
  description = "string ||| The name of the cloudwatch log group containing application logs."
}

output "log_reader" {
  value       = module.logs.reader
  description = "object({ name: string, access_key: string, secret_key: string }) ||| An AWS User with explicit privilege to read logs from Cloudwatch."
  sensitive   = true
}

locals {
  // Private and public URLs are shown in the Nullstone UI
  // Typically, they are created through capabilities attached to the application
  // If this module has URLs, add them here as list(string)
  additional_private_urls = []
  additional_public_urls  = []
}

output "private_urls" {
  value       = concat([for url in try(local.capabilities.private_urls, []) : url["url"]], local.additional_private_urls)
  description = "list(string) ||| A list of URLs only accessible inside the network"
}

output "public_urls" {
  value       = concat([for url in try(local.capabilities.public_urls, []) : url["url"]], local.additional_public_urls)
  description = "list(string) ||| A list of URLs accessible to the public"
}

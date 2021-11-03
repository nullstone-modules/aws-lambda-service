module "logs" {
  source = "nullstone-modules/logs/aws"

  // NOTE: This name must be `/aws/lambda/{function_name}` to properly collect logs from function
  name              = "/aws/lambda/${local.resource_name}"
  tags              = local.tags
  enable_log_reader = true
}

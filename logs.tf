module "logs" {
  #bridgecrew:skip=CKV_TF_1: "Ensure Terraform module sources use a commit hash". We want to accept any updates to minor updates.
  source  = "nullstone-modules/logs/aws"
  version = "~>0.1.0"

  // NOTE: This name must be `/aws/lambda/{function_name}` to properly collect logs from function
  name               = "/aws/lambda/${local.resource_name}"
  tags               = local.tags
  enable_log_reader  = true
  enable_get_metrics = true
}

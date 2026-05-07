module "scaffold" {
  source = "registry.terraform.io/nullstone-modules/lambda-appscaffold/aws"

  region          = data.aws_region.this.region
  account_id      = data.aws_caller_identity.this.account_id
  block_ref       = data.ns_workspace.this.block_ref
  resource_suffix = random_string.resource_suffix.result
  tags            = local.tags

  op_assumer_arns      = [local.ns_agent_user_arn]
  package_type         = "Zip"
  lambda_function_arn  = aws_lambda_function.this.arn
  artifacts_bucket_arn = aws_s3_bucket.artifacts.arn
  secret_arns = concat(
    values(local.existing_secret_refs),
    [for s in aws_secretsmanager_secret.app_secret : s.arn],
  )
}

// State migration for resources extracted into the lambda-appscaffold module.
// These can be removed once every environment has been successfully applied
// against the new module layout.

moved {
  from = aws_iam_role.executor
  to   = module.scaffold.aws_iam_role.executor
}

moved {
  from = aws_iam_role_policy_attachment.executor_basic
  to   = module.scaffold.aws_iam_role_policy_attachment.executor_basic
}

moved {
  from = aws_iam_role_policy_attachment.executor_vpc
  to   = module.scaffold.aws_iam_role_policy_attachment.executor_vpc
}

moved {
  from = aws_iam_role_policy.executor
  to   = module.scaffold.aws_iam_role_policy.executor
}

moved {
  from = aws_kms_key.this
  to   = module.scaffold.aws_kms_key.this
}

moved {
  from = module.logs
  to   = module.scaffold.module.logs
}

variable "env_vars" {
  type        = map(string)
  default     = {}
  description = <<EOF
The environment variables to inject into the service.
These are typically used to configure a service per environment.
It is dangerous to put sensitive information in this variable because they are not protected and could be unintentionally exposed.
EOF
}

variable "secrets" {
  type        = map(string)
  default     = {}
  sensitive   = true
  description = <<EOF
The sensitive environment variables to inject into the service.
These are typically used to configure a service per environment.
EOF
}

locals {
  standard_env_vars = tomap({
    NULLSTONE_STACK         = data.ns_workspace.this.stack_name
    NULLSTONE_APP           = data.ns_workspace.this.block_name
    NULLSTONE_ENV           = data.ns_workspace.this.env_name
    NULLSTONE_VERSION       = data.ns_app_env.this.version
    NULLSTONE_COMMIT_SHA    = data.ns_app_env.this.commit_sha
    NULLSTONE_PUBLIC_HOSTS  = join(",", local.public_hosts)
    NULLSTONE_PRIVATE_HOSTS = join(",", local.private_hosts)
  })

  // Lambda sets these reserved variables on every function; they are reported, not added to the function environment
  cloud_env_vars = tomap({
    AWS_REGION                      = data.aws_region.this.region
    AWS_DEFAULT_REGION              = data.aws_region.this.region
    AWS_LAMBDA_FUNCTION_NAME        = local.resource_name
    AWS_LAMBDA_FUNCTION_MEMORY_SIZE = tostring(var.memory)
  })
}

// ns_env_layout classifies secrets using keys only, so the set of secrets to add to aws secrets manager is known at plan time
data "ns_env_layout" "this" {
  platform               = "aws_lambda"
  standard_keys          = keys(local.standard_env_vars)
  cloud_keys             = keys(local.cloud_env_vars)
  capability_env_keys    = [for e in local.capabilities.env : { capability = e.capability, name = e.name }]
  capability_secret_keys = [for s in local.capabilities.secrets : { capability = s.capability, name = s.name }]
  capability_prefixes    = local.cap_prefixes
  user_env               = var.env_vars
  user_secret_keys       = nonsensitive(keys(var.secrets))
}

data "ns_env_values" "this" {
  platform            = "aws_lambda"
  standard            = local.standard_env_vars
  cloud               = local.cloud_env_vars
  capability_env      = local.capabilities.env
  capability_secrets  = local.capabilities.secrets
  capability_prefixes = local.cap_prefixes
  user_env            = var.env_vars
  user_secrets        = var.secrets
}

// ns_env_platform_data records where each managed secret lives so Nullstone can display the environment
data "ns_env_platform_data" "this" {
  values     = data.ns_env_values.this.platform_data
  secret_ids = { for key, secret in aws_secretsmanager_secret.app_secret : key => secret.arn }
}

locals {
  // A cloud variable reaches the function only when a capability or the user overrides it
  function_env_vars = { for k, v in data.ns_env_values.this.env_variables : k => v if data.ns_env_values.this.sources[k] != "cloud" }
  // Since lambda does not have secret injection, secrets reach the function as env vars holding secret ids
  // Managed secrets are added as <KEY>_SECRET_ID; existing secrets are added as <KEY> = <secret ref>
  all_env_vars = merge(local.function_env_vars, local.app_secret_ids, data.ns_env_values.this.unmanaged_secret_refs)
}

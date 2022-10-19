locals {
  standard_env_vars = tomap({
    NULLSTONE_STACK         = data.ns_workspace.this.stack_name
    NULLSTONE_APP           = data.ns_workspace.this.block_name
    NULLSTONE_ENV           = data.ns_workspace.this.env_name
    NULLSTONE_VERSION       = data.ns_app_env.this.version
    NULLSTONE_COMMIT_SHA    = data.ns_app_env.this.commit_sha
  })
  env_vars = merge(local.standard_env_vars, local.cap_env_vars, local.app_secret_ids, var.service_env_vars)
}

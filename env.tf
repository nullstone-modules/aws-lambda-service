locals {
  standard_env_vars = tomap({
    NULLSTONE_ENV = data.ns_workspace.this.env_name
  })
  cap_env_vars = { for item in try(local.capabilities.env, []) : item.name => item.value }
  env_vars     = merge(local.cap_env_vars, local.app_secret_ids, var.service_env_vars, local.standard_env_vars)
}

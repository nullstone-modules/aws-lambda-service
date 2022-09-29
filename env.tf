locals {
  standard_env_vars = tomap({
    NULLSTONE_ENV = data.ns_workspace.this.env_name
  })
  env_vars = merge(local.standard_env_vars, local.cap_env_vars, local.app_secret_ids, var.service_env_vars)
}

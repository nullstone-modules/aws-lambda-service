terraform {
  required_providers {
    ns = {
      source = "nullstone-io/ns"
    }
  }
}

data "ns_workspace" "this" {}

data "ns_app_env" "this" {
  app   = data.ns_workspace.this.block
  stack = data.ns_workspace.this.stack
  env   = data.ns_workspace.this.env
}

locals {
  app_version = data.ns_app_env.this.version
}

data "ns_connection" "network" {
  name     = "network"
  type     = "network/aws"
  optional = true
}

locals {
  has_network = try(signum(data.ns_connection.network.outputs.private_subnet_ids), 0)
  subnet_ids  = try(data.ns_connection.network.outputs.private_subnet_ids, [])
  vpc_configs = local.has_network ? [{
    subnet_ids         = local.subnet_ids
    security_group_ids = aws_security_group.this.*.id
  }] : []
}

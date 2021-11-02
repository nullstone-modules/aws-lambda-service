terraform {
  required_providers {
    ns = {
      source = "nullstone-io/ns"
    }
  }
}

data "ns_workspace" "this" {}

data "ns_connection" "network" {
  name     = "network"
  type     = "network/aws"
  optional = true
}

locals {
  tags = data.ns_workspace.this.tags

  has_network = try(length(data.ns_connection.network.outputs.private_subnet_ids), 0) > 0
  subnet_ids  = try(data.ns_connection.network.outputs.private_subnet_ids, [])

  vpc_configs = local.has_network ? [{
    subnet_ids         = local.subnet_ids
    security_group_ids = aws_security_group.this.*.id
  }] : []
}

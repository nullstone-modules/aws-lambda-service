terraform {
  required_providers {
    ns = {
      source = "nullstone-io/ns"
    }
  }
}

data "ns_workspace" "this" {}

// Generate a random suffix to ensure uniqueness of resources
resource "random_string" "resource_suffix" {
  length  = 5
  lower   = true
  upper   = false
  number  = false
  special = false
}

locals {
  tags          = data.ns_workspace.this.tags
  block_name    = data.ns_workspace.this.block_name
  resource_name = "${data.ns_workspace.this.block_ref}-${random_string.resource_suffix.result}"
}

data "ns_connection" "network" {
  name     = "network"
  type     = "network/aws"
  optional = true
}

locals {
  has_network = try(length(data.ns_connection.network.outputs.private_subnet_ids), 0) > 0
  subnet_ids  = try(data.ns_connection.network.outputs.private_subnet_ids, [])

  vpc_configs = local.has_network ? [{
    subnet_ids         = local.subnet_ids
    security_group_ids = aws_security_group.this.*.id
  }] : []
}

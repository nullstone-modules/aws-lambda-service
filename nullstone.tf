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

data "ns_connection" "subdomain" {
  name     = "subdomain"
  type     = "subdomain/aws"
  optional = true
}

locals {
  has_network = try(length(data.ns_connection.network.outputs.private_subnet_ids), 0) > 0
  subnet_ids  = try(data.ns_connection.network.outputs.private_subnet_ids, [])
  vpc_configs = local.has_network ? [{
    subnet_ids         = local.subnet_ids
    security_group_ids = aws_security_group.this.*.id
  }] : []

  has_subdomain      = try(length(data.ns_connection.subdomain.outputs.fqdn), 0) > 0
  subdomain_name     = try(data.ns_connection.subdomain.outputs.fqdn, "")
  subdomain_cert_arn = data.ns_connection.subdomain.outputs.cert_arn
}

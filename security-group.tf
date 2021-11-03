resource "aws_security_group" "this" {
  name   = local.resource_name
  vpc_id = data.ns_connection.network.outputs.vpc_id
  tags   = merge(local.tags, { Name = local.resource_name })

  count = local.has_network ? 1 : 0
}

resource "aws_security_group_rule" "this-https-to-world" {
  security_group_id = aws_security_group.this[count.index].id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]

  count = local.has_network ? 1 : 0
}

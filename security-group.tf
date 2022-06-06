resource "aws_security_group" "this" {
  name        = local.resource_name
  vpc_id      = local.vpc_id
  tags        = merge(local.tags, { Name = local.resource_name })
  description = "Managed by Terraform"
}

resource "aws_security_group_rule" "this-https-to-world" {
  description       = "Allow service to communicate with world over HTTPS"
  security_group_id = aws_security_group.this.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_cloudwatch_log_group" "this" {
  name = local.resource_name
  tags = data.ns_workspace.this.tags
}

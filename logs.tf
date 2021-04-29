resource "aws_cloudwatch_log_group" "this" {
  name = "/${data.ns_workspace.this.env}/${data.ns_workspace.this.block}"
  tags = data.ns_workspace.this.tags
}

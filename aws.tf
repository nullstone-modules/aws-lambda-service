data "aws_region" "this" {}
data "aws_caller_identity" "this" {}

locals {
  account_id = data.aws_caller_identity.this.account_id
}

provider "aws" {
  default_tags {
    tags = local.tags
  }
}

locals {
  artifacts_bucket_name = "${data.ns_workspace.this.block}-artifacts-${random_string.resource_suffix.result}"
}

resource "aws_s3_bucket" "artifacts" {
  bucket = local.artifacts_bucket_name
  acl    = "private"
  tags   = data.ns_workspace.this.tags

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }

  object_lock_configuration {
    object_lock_enabled = "Enabled"
  }
}

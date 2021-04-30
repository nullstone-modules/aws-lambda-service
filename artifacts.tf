locals {
  artifacts_bucket_name = "${data.ns_workspace.this.block}-artifacts-${random_string.resource_suffix.result}"
}

resource "aws_s3_bucket" "artifacts" {
  bucket        = local.artifacts_bucket_name
  acl           = "private"
  tags          = data.ns_workspace.this.tags
  force_destroy = true

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

data "archive_file" "placeholder" {
  output_path = "${path.cwd}/placeholder.zip"
  type        = "zip"

  source {
    filename = "index.js"
    content  = <<EOF
exports.handler = async (event) => {
  console.log("Hello world");
};
EOF
  }
}

data "aws_s3_bucket_objects" "find_existing" {
  bucket = aws_s3_bucket.artifacts.bucket
  prefix = local.artifact_key
}

locals {
  artifact_key = "service-${local.app_version}.zip"
  has_artifact = length(data.aws_s3_bucket_objects.find_existing.keys) > 0
}

// Add a placeholder object if it doesn't exit
resource "aws_s3_bucket_object" "placeholder" {
  bucket = aws_s3_bucket.artifacts.bucket
  key    = "placeholder.zip"
  source = data.archive_file.placeholder.output_path
  etag   = filemd5(data.archive_file.placeholder.output_path)

  lifecycle { ignore_changes = [etag] }
}

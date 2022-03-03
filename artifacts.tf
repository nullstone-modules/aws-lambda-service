locals {
  artifacts_bucket_name = "artifacts-${local.resource_name}"
}

resource "aws_s3_bucket" "artifacts" {
  bucket        = local.artifacts_bucket_name
  tags          = local.tags
  force_destroy = true

  object_lock_configuration {
    object_lock_enabled = "Enabled"
  }
}

resource "aws_s3_bucket_acl" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}


data "archive_file" "placeholder" {
  output_path = "placeholder.zip"
  type        = "zip"

  source {
    filename = "index.js"
    content  = <<EOF
exports.handler = async (event) => {
    const response = {
        statusCode: 200,
        body: JSON.stringify('Welcome to Nullstone!'),
    };
    return response;
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
  etag   = data.archive_file.placeholder.output_md5

  lifecycle { ignore_changes = [etag] }
}

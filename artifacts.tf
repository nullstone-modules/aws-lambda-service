locals {
  artifacts_bucket_name = "artifacts-${local.resource_name}"
}

resource "aws_s3_bucket" "artifacts" {
  #bridgecrew:skip=CKV_AWS_144: "Ensure that S3 bucket has cross-region replication enabled". These artifacts are only used by lambda.
  #bridgecrew:skip=CKV_AWS_18: "Ensure the S3 bucket has access logging enabled".
  bucket              = local.artifacts_bucket_name
  tags                = local.tags
  force_destroy       = true
  object_lock_enabled = true
}

resource "aws_s3_bucket_lifecycle_configuration" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  rule {
    id     = "noop"
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.artifacts.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_acl" "artifacts" {
  depends_on = [aws_s3_bucket_ownership_controls.default]

  bucket = aws_s3_bucket.artifacts.id
  acl    = "private"
}

resource "aws_s3_bucket_ownership_controls" "default" {
  bucket = aws_s3_bucket.artifacts.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

/*
NOTE: We added this file to the module
      Uncomment if you want to regenerate placeholder.zip
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

locals {
  placeholder_path = data.archive_file.placeholder.output_path
  placeholder_etag = data.archive_file.placeholder.output_md5
}
*/

locals {
  placeholder_path = "placeholder.zip"
  placeholder_etag = filemd5(local.placeholder_path)
}

data "aws_s3_objects" "find_existing" {
  bucket = aws_s3_bucket.artifacts.bucket
  prefix = local.artifact_key
}

locals {
  artifact_key = "service-${local.app_version}.zip"
  has_artifact = length(data.aws_s3_objects.find_existing.keys) > 0
}

// Add a placeholder object if it doesn't exit
resource "aws_s3_object" "placeholder" {
  bucket = aws_s3_bucket.artifacts.bucket
  key    = "placeholder.zip"
  source = local.placeholder_path
  etag   = local.placeholder_etag

  lifecycle { ignore_changes = [etag] }
}

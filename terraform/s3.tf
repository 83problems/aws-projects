resource "aws_kms_key" "tf_bucket_kms_key" {
  description             = "S3 bucket KMS key for Terraform state file."
  deletion_window_in_days = 10

  tags = {
    Terraform = true
    Name      = "tf_bucket_kms_key"
  }
}

resource "aws_s3_bucket" "tf_bucket" {

  tags = {
    Terraform = true
    Name      = "s3_tf_bucket"
  }
}

resource "aws_s3_bucket_public_access_block" "tf_bucket_public_block" {
  bucket = aws_s3_bucket.tf_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "tf_bucket_acl" {
  bucket = aws_s3_bucket.tf_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "tf_bucket_versioning" {
  bucket = aws_s3_bucket.tf_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_bucket_sse" {
  bucket = aws_s3_bucket.tf_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.tf_bucket_kms_key.arn
      sse_algorithm     = "aws:kms"
    }
  }

}

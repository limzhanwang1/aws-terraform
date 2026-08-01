# 1. Lookup the identity running Terraform
data "aws_caller_identity" "current" {}

# 2. S3 Bucket (Private)
resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  force_destroy = false
}

# 3. Ownership Controls (Disable ACLs, rely on bucket/IAM policies)
resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# 4. Block Public Internet Access
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 5. Bucket Policy: Restrict modifications except for Terraform execution role and root
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket     = aws_s3_bucket.this.id
  depends_on = [aws_s3_bucket_public_access_block.public_access]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # Statement 1: Allow CloudFront OAC Read Access
      {
        Sid       = "AllowCloudFrontOACReadOnly"
        Effect    = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.this.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      },

      # Statement 2: Deny modifications UNLESS performed by GitHub Actions OIDC Role / Root
      {
        Sid       = "RestrictModificationsToTerraformRole"
        Effect    = "Deny"
        Principal = "*"
        Action = [
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:PutBucketPolicy",
          "s3:PutBucketAcl"
        ]
        Resource = [
          aws_s3_bucket.this.arn,
          "${aws_s3_bucket.this.arn}/*"
        ]
        Condition = {
          ArnNotLike = {
            "aws:PrincipalArn" = [
              # Allows baseline role & any assumed-role sessions (e.g. GitHubActions)
              "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/GitHubOIDC-Terraform",
              "arn:aws:sts::${data.aws_caller_identity.current.account_id}:assumed-role/GitHubOIDC-Terraform/*",
              "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
            ]
          }
        }
      }
    ]
  })
}

# 6. Upload index.html securely
resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.this.id
  key    = "index.html"

  source       = "${path.module}/index.html"
  etag         = filemd5("${path.module}/index.html")
  content_type = "text/html"

  depends_on = [aws_s3_bucket_policy.bucket_policy]
}

# 7. State Lock Table
resource "aws_dynamodb_table" "tf_locks" {
  name         = "terraform-state-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
##Turn off public access
#output "website_endpoint" {
#  value = aws_s3_bucket_website_configuration.this.website_endpoint
#}

output "bucket_id" {
  value       = aws_s3_bucket.this.id
  description = "The name/ID of the S3 bucket"
}

output "bucket_arn" {
  value       = aws_s3_bucket.this.arn
  description = "The ARN of the S3 bucket"
}

output "bucket_regional_domain_name" {
  value       = aws_s3_bucket.this.bucket_regional_domain_name
  description = "The regional domain name of the bucket (used by CloudFront)"
}
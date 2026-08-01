output "cloudfront_distribution_id" {
  value       = aws_cloudfront_distribution.this.id
  description = "The ID of the CloudFront distribution"
}

output "cloudfront_domain_name" {
  value       = aws_cloudfront_distribution.this.domain_name
  description = "The domain name of the CloudFront distribution (e.g. d111111abcdef8.cloudfront.net)"
}

output "cloudfront_hosted_zone_id" {
  value       = aws_cloudfront_distribution.this.hosted_zone_id
  description = "CloudFront Route 53 Zone ID (useful if referencing in Route53/DNS)"
}
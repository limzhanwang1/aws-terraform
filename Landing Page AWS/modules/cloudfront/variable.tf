variable "domain_name" {
  type        = string
  description = "The custom domain name (e.g., landing.southlab.work)"
}

variable "s3_bucket_id" {
  type        = string
  description = "The ID/Name of the S3 bucket"
}

variable "s3_bucket_arn" {
  type        = string
  description = "The ARN of the S3 bucket"
}

variable "s3_bucket_domain_name" {
  type        = string
  description = "The regional domain name of the S3 bucket"
}

variable "acm_certificate_arn" {
  type        = string
  description = "The ARN of the validated ACM Certificate in us-east-1"
}

variable "comment" {
  type        = string
  default     = "CloudFront Distribution for Static Website"
  description = "Optional comment for the distribution"
}
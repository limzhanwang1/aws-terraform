variable "aws_region" {
  type    = string
  default = "ap-southeast-1"
}

variable "aws_region_acm" {
  type    = string
  default = "us-east-1"
}

variable "bucket_name" {
  type    = string
  default = "landingpage-southlab"
}

variable "domain_name" {
  type    = string
  default = "landing.southlab.work"
}
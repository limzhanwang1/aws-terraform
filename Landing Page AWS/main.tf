terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}


# CONTROL PANEL: Call your S3 module here
module "landing_page_site" {
  source      = "./modules/s3_website"
  bucket_name = var.bucket_name
}
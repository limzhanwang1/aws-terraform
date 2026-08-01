terraform {
  required_version = ">= 1.5.0"
  backend "s3" {
    bucket         = "landingpage-southlab"   # Your state bucket name
    key            = "tfstate/terraform.tfstate" # Path where the state file is stored
    region         = "ap-southeast-1"
    #dynamodb_table = "terraform-state-locks"          # For state locking
    encrypt        = true                             # Encrypt state file at rest
  }


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


# Import the existing S3 Bucket into Terraform state
#import {
#  to = module.landing_page_site.aws_s3_bucket.this
#  id = "landingpage-southlab"
#}

# Import the existing DynamoDB Table into Terraform state
#import {
#  to = module.landing_page_site.aws_dynamodb_table.tf_locks
#  id = "terraform-state-locks"
#}





# CONTROL PANEL: Call S3 module here
module "landing_page_site" {
  source      = "./modules/s3_website"
  bucket_name = var.bucket_name
}

# CONTROL PANEL: Call cloudfront module here
module "cloudfront" {
  source = "./modules/cloudfront"

  domain_name           = var.domain_name
  s3_bucket_id          = module.s3_website.bucket_id
  s3_bucket_arn         = module.s3_website.bucket_arn
  s3_bucket_domain_name = module.s3_website.bucket_regional_domain_name
  acm_certificate_arn   = module.acm.certificate_arn
}
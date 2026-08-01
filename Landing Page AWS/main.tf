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



# Lookup the existing ACM certificate by domain name
data "aws_acm_certificate" "existing" {
  domain   = "landing.southlab.work"
  statuses = ["ISSUED"]
  
  # Note: Certificates for CloudFront MUST be in us-east-1
   provider = aws.us_east_1 
}

####CONTROL PANEL BELOW

#Call S3 module here
module "landing_page_site" {
  source      = "./modules/s3_website"
  bucket_name = var.bucket_name
}





#Call Cloudfront module here
module "cloudfront" {
  source = "./modules/cloudfront"

  domain_name           = "landing.southlab.work"
  s3_bucket_id          = module.s3_website.bucket_id
  s3_bucket_arn         = module.s3_website.bucket_arn
  s3_bucket_domain_name = module.s3_website.bucket_regional_domain_name
  
  # Reference the data source output:
  acm_certificate_arn   = data.aws_acm_certificate.existing.arn
}

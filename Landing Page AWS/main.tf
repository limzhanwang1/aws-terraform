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


# CONTROL PANEL: Call your S3 module here
module "landing_page_site" {
  source      = "./modules/s3_website"
  bucket_name = var.bucket_name
}
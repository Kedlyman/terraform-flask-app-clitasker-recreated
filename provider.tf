terraform {
  required_version = ">= 1.4.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 5.94.1"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "terraform-flask-app"
      Environment = "Dev"
      ManagedBy   = "Terraform"
    }
  }
}

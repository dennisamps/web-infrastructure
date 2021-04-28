terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket = "terraform-backend-dennis-nginx-234"
    region = "us-east-1"
    key = "acm/terraform.tfstate"
  }
  required_version = ">= 0.13"
}

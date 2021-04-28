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
  profile = var.profile
}

terraform {
  backend "s3" {
    bucket = "terraform-backend-dennis-nginx-234"
    region = "us-east-1"
    key = "ecs/terraform.tfstate"
  }
  required_version = ">= 0.13"
}

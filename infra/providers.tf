terraform {
  required_version = ">= 1.6.0"

  backend "s3" {
    bucket       = "cloudops-task-tracker-tfstate-marcel-20260521"
    key          = "cloudops-task-tracker/dev/terraform.tfstate"
    region       = "eu-central-1"
    encrypt      = true
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}

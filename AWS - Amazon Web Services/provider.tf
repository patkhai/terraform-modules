terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.49"
    }
  }
}

provider "aws" {
  region     = var.aws_region
  assume_role {
    role_arn = "role_arn"
  }
}

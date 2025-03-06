terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  version = "~> 5.0"
  region  = "eu-west-1"
}

resource "aws_s3_bucket" "s3" {
  bucket = "tofu-demo-bucket"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

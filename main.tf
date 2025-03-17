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
  tags = {
    Name        = var.s3_name
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.s3.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    } 

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.s3.arn,
      "${aws_s3_bucket.s3.arn}/*",
    ]
  }
}

variable "s3_name" {
  type = string
  description = "name of the s3 bucket"
}

output "s3_policy" {
  value = {
    id = aws_s3_bucket.s3.id
    arn = aws_s3_bucket.s3.arn
    policy = "'${aws_s3_bucket_policy.allow_access_from_another_account.policy}'"
  }
}

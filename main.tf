terraform {
  # Terraform Version
  required_version = ">= 1.7.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }

  #   Uncomment after creating the backend, then run `terraform init`
  #   backend "s3" {
  #     bucket         = "tfstate-12345678"
  #     key            = "backend/terraform.tfstate"
  #     region         = "us-east-1"
  #     dynamodb_table = "terraform-state-locks"
  #     encrypt        = true
  #   }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}

# S3 buckets must be globally unique
# so we generate a unique bucket name suffix
resource "random_id" "s3_bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "tfstate-${random_id.s3_bucket_suffix.hex}"
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  point_in_time_recovery {
    enabled = true
  }

  attribute {
    name = "LockID"
    type = "S"
  }
}

output "bucket_name" {
  description = "Name of created S3 bucket"
  value       = aws_s3_bucket.terraform_state.bucket
}

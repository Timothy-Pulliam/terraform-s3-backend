# About

This Terraform script will create an [S3 backend](https://developer.hashicorp.com/terraform/language/settings/backends/s3) with file versioning enabled. Statefile locking will be handled in a DynamoDB table.

![](/backend.png)

# Create backend

```bash
terraform init
terraform plan
terraform apply
```

Note: S3 bucket names must be globally unique, so we generate a unique bucket name suffix. The bucket name will appear in the output

# Use the backend

Uncomment out the backend section in main\.tf replacing the bucket name with the generated bucket name.

```hcl
backend "s3" {
    bucket         = "tfstate-12345678"
    key            = "backend/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
}
```

Run terraform init again to use the remote backend.

```bash
terraform init
```

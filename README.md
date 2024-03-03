# About

This Terraform script will create an [S3 backend](https://developer.hashicorp.com/terraform/language/settings/backends/s3) with file versioning enabled. Statefile locking will be handled in a DynamoDB table.

![](/tfstate.png)

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

## Requirements

| Name                                                                     | Version  |
| ------------------------------------------------------------------------ | -------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.7.4 |
| <a name="requirement_aws"></a> [aws](#requirement_aws)                   | ~> 5.0   |

## Providers

| Name                                                      | Version |
| --------------------------------------------------------- | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws)          | 5.38.0  |
| <a name="provider_random"></a> [random](#provider_random) | 3.6.0   |

## Modules

No modules.

## Resources

| Name                                                                                                                              | Type     |
| --------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [aws_dynamodb_table.terraform_locks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table)  | resource |
| [aws_s3_bucket.terraform_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)            | resource |
| [aws_s3_bucket_versioning.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [random_id.s3_bucket_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id)                   | resource |

## Inputs

| Name                                                | Description | Type     | Default       | Required |
| --------------------------------------------------- | ----------- | -------- | ------------- | :------: |
| <a name="input_region"></a> [region](#input_region) | AWS Region  | `string` | `"us-east-1"` |    no    |

## Outputs

| Name                                                                 | Description               |
| -------------------------------------------------------------------- | ------------------------- |
| <a name="output_bucket_name"></a> [bucket_name](#output_bucket_name) | Name of created S3 bucket |

# Cost Breakdown

Infracost price breakdown estimated monthly cost

```plaintext
tpulliam@lappy terraform-s3-backend % infracost breakdown --path .
Evaluating Terraform directory at .
  ✔ Downloading Terraform modules
  ✔ Evaluating Terraform directory
  ✔ Retrieving cloud prices to calculate costs

Project: Timothy-Pulliam/terraform-s3-backend

 Name                                                   Monthly Qty  Unit                    Monthly Cost

 aws_dynamodb_table.terraform_locks
 ├─ Write request unit (WRU)                      Monthly cost depends on usage: $0.00000125 per WRUs
 ├─ Read request unit (RRU)                       Monthly cost depends on usage: $0.00000025 per RRUs
 ├─ Data storage                                  Monthly cost depends on usage: $0.25 per GB
 ├─ Point-In-Time Recovery (PITR) backup storage  Monthly cost depends on usage: $0.20 per GB
 ├─ On-demand backup storage                      Monthly cost depends on usage: $0.10 per GB
 ├─ Table data restored                           Monthly cost depends on usage: $0.15 per GB
 └─ Streams read request unit (sRRU)              Monthly cost depends on usage: $0.0000002 per sRRUs

 aws_s3_bucket.terraform_state
 └─ Standard
    ├─ Storage                                    Monthly cost depends on usage: $0.023 per GB
    ├─ PUT, COPY, POST, LIST requests             Monthly cost depends on usage: $0.005 per 1k requests
    ├─ GET, SELECT, and all other requests        Monthly cost depends on usage: $0.0004 per 1k requests
    ├─ Select data scanned                        Monthly cost depends on usage: $0.002 per GB
    └─ Select data returned                       Monthly cost depends on usage: $0.0007 per GB

 OVERALL TOTAL                                                                                      $0.00
──────────────────────────────────
3 cloud resources were detected:
∙ 2 were estimated, all of which include usage-based costs, see https://infracost.io/usage-file
∙ 1 was free, rerun with --show-skipped to see details

┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━┓
┃ Project                                            ┃ Monthly cost ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╋━━━━━━━━━━━━━━┫
┃ Timothy-Pulliam/terraform-s3-backend               ┃ $0.00        ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┻━━━━━━━━━━━━━━┛
```

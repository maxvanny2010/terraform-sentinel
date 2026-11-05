# Terraform Digital Sovereignty

## Overview

Policy-as-Code framework using Terraform and HashiCorp Sentinel to enforce digital sovereignty and infrastructure security requirements.

## Technologies

- Terraform
- HashiCorp Sentinel
- HCP Terraform
- AWS
- GitHub

## Terraform Setup

- Terraform 1.15+
- AWS Provider 6.x
- Provider version locked in `.terraform.lock.hcl`

### Validation

- `terraform init` — passed
- `terraform validate` — passed

## AWS Configuration

AWS region and resource tags are configured using Terraform variables.

Default tags:
- Project
- Environment
- Owner
- ManagedBy

Input variables are validated to prevent empty values.

## EC2 Infrastructure

The Terraform configuration defines an EC2 instance with:

- Configurable AMI and instance type
- Encrypted gp3 root volume
- IMDSv2 enabled
- Standard resource tags

These settings will be checked by Sentinel policies.

## AMI Version Pinning

The EC2 instance uses a fixed Amazon Linux 2023 AMI for the Ireland region (`eu-west-1`).

The AMI ID was retrieved from AWS Systems Manager Parameter Store and is configured through the `ami_id` variable.

Pinning the AMI prevents unexpected image changes during future deployments. Image updates must be reviewed and applied explicitly.
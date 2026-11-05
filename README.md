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
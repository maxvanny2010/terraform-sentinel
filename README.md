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

## Network Infrastructure

The infrastructure uses a dedicated VPC instead of the AWS Default VPC.

- VPC CIDR: `10.0.0.0/16`
- DNS support and hostnames enabled
- Standard resource tags

### Private Network

- Private subnet CIDR: `10.0.1.0/24`
- Dedicated route table with local VPC routing only
- No automatic public IP assignment
- No Internet Gateway or NAT Gateway

### Security Group

The EC2 instance uses a dedicated Security Group with least-privilege network rules.

- No inbound traffic is permitted.
- SSH access from `0.0.0.0/0` is prohibited.
- Outbound traffic is restricted to HTTPS (TCP 443).
- Security Group rules are managed using separate Terraform resources.

Sentinel will validate the network security configuration.

### EC2 Network Integration

The EC2 instance is deployed into the dedicated private subnet and uses the project Security Group.

- Private subnet attachment
- Dedicated Security Group
- Public IPv4 assignment disabled
- No direct internet connectivity

Terraform manages resource dependencies automatically.

### Terraform Plan Validation

The Terraform plan was successfully generated for AWS Ireland (`eu-west-1`).

Validation results:
- 7 resources to add
- 0 resources to change
- 0 resources to destroy
- EC2 root EBS encryption enabled
- IMDSv2 required
- Public IP assignment disabled
- Private subnet and dedicated Security Group configured

The complete plan output is available in [Terraform Plan Evidence](evidence/terraform-plan.txt).
No AWS resources were deployed.
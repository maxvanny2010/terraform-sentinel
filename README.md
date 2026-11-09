# Terraform Digital Sovereignty

## Overview

Policy-as-Code framework using Terraform and HashiCorp Sentinel to enforce digital sovereignty and infrastructure
security requirements.

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

Pinning the AMI prevents unexpected image changes during future deployments. Image updates must be reviewed and applied
explicitly.

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

## Sentinel CLI Setup

HashiCorp Sentinel CLI v0.41.0 is installed locally on Windows.

Installation:

- Download the Sentinel CLI ZIP from HashiCorp.
- Extract `sentinel.exe` to `C:\Tools\Sentinel`.
- Add `C:\Tools\Sentinel` to the system PATH.

Validation:

- `sentinel version` — passed (v0.41.0).

Sentinel CLI will be used to develop and test policies locally.

## AWS Region Policy

The `aws-region.sentinel` policy restricts AWS resource deployment to approved regions.

- Approved regions are configured through `allowed_regions`.
- The policy checks planned AWS resource creation and updates.
- Unknown or unapproved regions are rejected.
- Plans without relevant changes are allowed.
- Enforcement level: `hard-mandatory`.

### Local Testing

Validated using Sentinel CLI v0.41.0:

- Approved region: PASS
- Unapproved region: PASS (rejected as expected)
- Unknown region: PASS (rejected as expected)
- Resource replacement: PASS
- No changes: PASS

All five test scenarios passed using `sentinel test -verbose`.

## EC2 Security Policy

The `ec2-security.sentinel` policy enforces security requirements for AWS EC2 instances before deployment.

### Security Controls

- **Instance Type:** Only approved EC2 instance types are permitted.
- **EBS Encryption:** Root EBS volumes must be encrypted.
- **IMDSv2:** Instance metadata must require IMDSv2 (`http_tokens = "required"`).
- **Missing Configuration:** Empty root block device or metadata settings are rejected.
- **Enforcement:** `hard-mandatory`.

Approved instance types are configured through the `allowed_instance_types` parameter in `sentinel.hcl`.

### Testing and Validation

Validated locally using Sentinel CLI v0.41.0.

| Test Scenario             | Expected Policy Result | Test Status |
|---------------------------|------------------------|-------------|
| Secure EC2 configuration  | Allow                  | PASS        |
| Unencrypted EBS volume    | Deny                   | PASS        |
| Unapproved instance type  | Deny                   | PASS        |
| IMDSv1 permitted          | Deny                   | PASS        |
| Missing security settings | Deny                   | PASS        |

All five EC2 Security Policy tests passed using `sentinel test -verbose`.

HCP Terraform integration will be validated separately.

## Terraform Supply Chain Security

The `terraform-supply-chain.sentinel` policy validates Terraform provider sources to reduce supply chain risks.

### Provider Source Validation

- Only approved Terraform provider sources are permitted.
- Approved sources are configured through `allowed_provider_sources`.
- The policy requires providers to declare version constraints.
- Enforcement level: `hard-mandatory`.

### Testing and Validation

Validated locally using Sentinel CLI v0.41.0.

| Test Scenario              | Expected Result | Status |
|----------------------------|-----------------|--------|
| Approved AWS provider      | Allow           | PASS   |
| Unapproved provider source | Deny            | PASS   |

Both providers source validation tests passed using `sentinel test -verbose`.

Provider version validation and Terraform module controls will be added in the next development increment.

### Provider Version Validation

- Terraform providers must declare version constraints.
- Providers without version constraints are rejected.

### Module Source and Version Validation

- Only approved Terraform module sources are permitted.
- Approved sources are configured through `allowed_module_sources`.
- External modules must declare version constraints.
- Unapproved module sources and missing version constraints are rejected.
- Configurations without module calls are permitted.

### Additional Testing and Validation

| Test Scenario                           | Expected Result | Status |
|-----------------------------------------|-----------------|--------|
| Provider without version constraint     | Deny            | PASS   |
| Approved module with version constraint | Allow           | PASS   |
| Unapproved module source                | Deny            | PASS   |
| Module without version constraint       | Deny            | PASS   |

All six Terraform Supply Chain test scenarios passed using `sentinel test -verbose`.

HCP Terraform integration will be validated separately.
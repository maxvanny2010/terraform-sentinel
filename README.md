### Policy-as-Code Framework for Digital Sovereignty and IaC Supply Chain Security

**Atlantic Technological University (ATU)**

**Programme:** Postgraduate Diploma in Computing in DevOps<br/>
**Module:** Infrastructure as Code for DevOps Pipelines<br/>
**Lecturer:** Ruth Lennon<br/>
**Student:** Maksym Voronianskyi<br/>
**Student Number:** L00213593<br/>
**Academic Year:** 2026/2027

**Technologies:** Terraform, HashiCorp Sentinel, HCP Terraform, AWS, GitHub

---

### Overview

Terraform and HashiCorp Sentinel are used to check AWS infrastructure security<br/>
requirements before deployment.

#### Technologies

- Terraform
- HashiCorp Sentinel
- HCP Terraform
- AWS
- GitHub

#### Terraform Setup

- Terraform 1.15+
- AWS Provider 6.x
- Provider version locked in `.terraform.lock.hcl`

The committed `.terraform.lock.hcl` records selected provider versions and<br/>
checksums. This follows the dependency-locking recommendation in<br/>
[Terraform Best Practices for AWS: 2026 Guide][itmagic].

##### Validation

| Command              | Result        |
|----------------------|---------------|
| `terraform init`     | ![PASS][pass] |
| `terraform validate` | ![PASS][pass] |

#### AWS Configuration

AWS region and resource tags are configured using Terraform variables.

Default tags:

- Project
- Environment
- Owner
- ManagedBy

Input variables are validated to prevent empty values.

The use of provider-level `default_tags` follows the tagging practice<br/>
discussed in [Terraform Best Practices for AWS: 2026 Guide][itmagic].

#### EC2 Infrastructure

The Terraform configuration defines an EC2 instance with:

- Configurable AMI and instance type
- Encrypted gp3 root volume
- IMDSv2 enabled
- Standard resource tags

These settings are checked by Sentinel policies.

#### AMI Version Pinning

The EC2 instance uses a fixed Amazon Linux 2023 AMI for the Ireland region<br/>
(`eu-west-1`).

The AMI ID was retrieved from AWS Systems Manager Parameter Store and is<br/>
configured through the `ami_id` variable.

Pinning the AMI prevents unexpected image changes during future deployments.<br/>
Image updates must be reviewed and applied explicitly.

#### Network Infrastructure

The infrastructure uses a dedicated VPC instead of the AWS Default VPC.

- VPC CIDR: `10.0.0.0/16`
- DNS support and hostnames enabled
- Standard resource tags

##### Private Network

- Private subnet CIDR: `10.0.1.0/24`
- Dedicated route table with local VPC routing only
- No automatic public IP assignment
- No Internet Gateway or NAT Gateway

##### Security Group

The EC2 instance uses a dedicated Security Group with least-privilege network<br/>
rules.

- No inbound traffic is permitted.
- SSH access from `0.0.0.0/0` is prohibited.
- Outbound traffic is restricted to HTTPS (TCP 443).
- Security Group rules are managed using separate Terraform resources.

Sentinel validates the network security configuration.

##### EC2 Network Integration

The EC2 instance is deployed into the dedicated private subnet and uses the<br/>
project Security Group.

- Private subnet attachment
- Dedicated Security Group
- Public IPv4 assignment disabled
- No direct internet connectivity

Terraform manages resource dependencies automatically.

##### Terraform Plan Validation

The Terraform plan was successfully generated for AWS Ireland (`eu-west-1`).

Validation results:

- 7 resources to add
- 0 resources to change
- 0 resources to destroy
- EC2 root EBS encryption enabled
- IMDSv2 required
- Public IP assignment disabled
- Private subnet and dedicated Security Group configured

The complete plan output is available in<br/>
[Terraform Plan Evidence](evidence/terraform-plan.txt).

Reviewing Terraform plans before deployment is consistent with the workflow<br/>
practices described in<br/>
[Terraform Best Practices for AWS: 2026 Guide][itmagic]. This local plan did<br/>
not deploy AWS resources.

#### Sentinel CLI Setup

HashiCorp Sentinel CLI v0.41.0 is installed locally on Windows.

Installation:

- Download the Sentinel CLI ZIP from HashiCorp.
- Extract `sentinel.exe` to `C:\Tools\Sentinel`.
- Add `C:\Tools\Sentinel` to the system PATH.

Validation:

| Command            | Version | Result        |
|--------------------|---------|---------------|
| `sentinel version` | v0.41.0 | ![PASS][pass] |

Sentinel CLI was used to develop and test policies locally.

#### AWS Region Policy

The `aws-region.sentinel` policy restricts AWS resource deployment to approved<br/>
regions.

- Approved regions are configured through `allowed_regions`.
- The policy checks planned AWS resource creation and updates.
- Unknown or unapproved regions are rejected.
- Plans without relevant changes are allowed.
- Enforcement level: `hard-mandatory`.

##### Local Testing

Validated using Sentinel CLI v0.41.0:

| Test Scenario        | Expected Policy Result | Test Status   |
|----------------------|------------------------|---------------|
| Approved region      | Allow                  | ![PASS][pass] |
| Unapproved region    | Deny                   | ![PASS][pass] |
| Unknown region       | Deny                   | ![PASS][pass] |
| Resource replacement | Allow                  | ![PASS][pass] |
| No changes           | Allow                  | ![PASS][pass] |

All five test scenarios passed using `sentinel test -verbose`.

##### Negative Test Evidence

The AWS Region Policy was tested against a non-compliant configuration using<br/>
`us-east-1`, while only `eu-west-1` is permitted.

The Sentinel test passed because the policy correctly rejected the unapproved<br/>
region (`main = false`).

![AWS Region Policy - Non-Compliant Configuration Rejected](evidence/hcp-terraform/sentinel-region-denied.png)

#### Digital Sovereignty: Decisions and Limitations

The infrastructure is restricted to AWS Ireland (`eu-west-1`) to support the<br/>
digital sovereignty requirements of this project.

**Decisions:**

- **Region restriction:** The Sentinel AWS Region Policy rejects<br/>
  infrastructure changes targeting unapproved regions.
- **Data residency:** Deploying resources in Ireland supports geographical<br/>
  control over infrastructure and data storage.
- **Policy enforcement:** The `hard-mandatory` enforcement level prevents<br/>
  deployment when a policy check fails.

**Limitations:**

- **Data replication and backups:** Restricting the AWS region does not<br/>
  automatically prevent data replication or backups outside Ireland.
- **Administrative access:** Region restrictions do not control where<br/>
  administrators or external service providers access infrastructure from.
- **Jurisdiction:** Hosting infrastructure in Ireland does not eliminate<br/>
  jurisdictional or legal dependencies on cloud service providers.
- **Runtime changes:** Sentinel evaluates Terraform plans but does not<br/>
  prevent changes made directly in AWS outside the Terraform workflow.

**Recommendation:**

Additional controls should be considered for data residency, backup locations,<br/>
access management, and continuous compliance monitoring.

#### Design Decisions and Justifications

<table>
  <thead>
    <tr><th>Design Decision</th><th>Purpose</th><th>Justification</th></tr>
  </thead>
  <tbody>
    <tr>
      <td>
        Restrict AWS deployments to<br/>
        <code>eu-west-1</code>
      </td>
      <td>
        Digital Sovereignty
      </td>
      <td>
        Keeps planned infrastructure deployments<br/>
        within the approved Ireland region and<br/>
        rejects deployments to unapproved regions.
      </td>
    </tr>
    <tr>
      <td>
        Enforce AWS region restrictions with<br/>
        Sentinel
      </td>
      <td>
        Digital Sovereignty
      </td>
      <td>
        Prevents non-compliant Terraform plans from<br/>
        being applied through the HCP Terraform<br/>
        workflow.
      </td>
    </tr>
    <tr>
      <td>
        Use a private subnet without a public IP<br/>
        address
      </td>
      <td>
        Infrastructure Security
      </td>
      <td>
        Reduces direct exposure of the EC2 instance<br/>
        to the public internet.
      </td>
    </tr>
    <tr>
      <td>
        Require encrypted EBS volumes
      </td>
      <td>
        Infrastructure Security
      </td>
      <td>
        Protects stored data against certain risks<br/>
        associated with unencrypted storage.
      </td>
    </tr>
    <tr>
      <td>
        Require IMDSv2
      </td>
      <td>
        Infrastructure Security
      </td>
      <td>
        Reduces risks associated with unauthorized<br/>
        access to EC2 instance metadata.
      </td>
    </tr>
    <tr>
      <td>
        Restrict Terraform provider sources and<br/>
        versions
      </td>
      <td>
        IaC Supply Chain Security
      </td>
      <td>
        Reduces the risk of using unapproved<br/>
        providers and makes dependency changes more<br/>
        predictable.
      </td>
    </tr>
    <tr>
      <td>
        Restrict external Terraform module sources<br/>
        and require version constraints
      </td>
      <td>
        IaC Supply Chain Security
      </td>
      <td>
        The Sentinel policy validates module sources<br/>
        and version constraints when external<br/>
        modules are used.<br/>
        This project does not use external Terraform<br/>
        modules; the policy was verified using<br/>
        positive and negative test scenarios.
      </td>
    </tr>
    <tr>
      <td>
        Use <code>.terraform.lock.hcl</code>
      </td>
      <td>
        IaC Supply Chain Security
      </td>
      <td>
        Records selected provider versions and<br/>
        checksums to support reproducible dependency<br/>
        installation.
      </td>
    </tr>
    <tr>
      <td>
        Use <code>hard-mandatory</code> Sentinel<br/>
        policies
      </td>
      <td>
        Policy Enforcement
      </td>
      <td>
        Prevents infrastructure changes through HCP<br/>
        Terraform when mandatory security<br/>
        requirements are not satisfied.
      </td>
    </tr>
    <tr>
      <td>
        Use separate AWS IAM roles for Plan and<br/>
        Apply
      </td>
      <td>
        Access Control
      </td>
      <td>
        Separates read-only planning permissions<br/>
        from infrastructure modification<br/>
        permissions.
      </td>
    </tr>
    <tr>
      <td>
        Use GitHub Pull Requests
      </td>
      <td>
        Change Management
      </td>
      <td>
        Provides version history and a reviewable<br/>
        record of infrastructure changes.
      </td>
    </tr>
  </tbody>
</table>

#### Terraform Architecture and Best Practices

The Terraform configuration is separated by responsibility (`network.tf`,<br/>
`providers.tf`, `variables.tf`, and other files), making the small<br/>
infrastructure easier to maintain.

Reusable child modules were considered but not introduced: this project<br/>
manages only seven AWS resources in one development environment, so additional<br/>
module boundaries would introduce unnecessary complexity. The Terraform<br/>
directory is itself the root module; no external child modules are called by<br/>
the infrastructure.

This project uses **HCP Terraform (HashiCorp Cloud Platform)** to run<br/>
Terraform, store its state in the `ATU-LABS / terraform-sentinel-dev`<br/>
workspace, and enforce Sentinel policies before Apply. This matched the<br/>
assignment's focus on Terraform and Sentinel without requiring a separate AWS<br/>
S3 state backend. See [HCP Terraform state documentation][hcp-state].

**Alternative approach (not implemented):**<br/>
GitHub Actions -> Terraform Plan -> Checkov or OPA/Conftest -> reviewed Apply -> AWS.<br/>
Terraform State could be stored in an S3 backend.<br/>
This approach would require separate state storage, locking, AWS authentication,<br/>
and security checks. It is not the HCP Terraform and Sentinel workflow used here.<br/>
See [Terraform S3 backend][s3-backend], [GitHub Actions OIDC for AWS][github-oidc],<br/>
and [Checkov GitHub Action][checkov].

The choice to keep a small root module and use managed state reflects the<br/>
principles discussed in<br/>
[Terraform Best Practices for AWS: 2026 Guide][itmagic]. The guide describes<br/>
general practices; the implementation details above come from the linked<br/>
official documentation.

#### EC2 Security Policy

The `ec2-security.sentinel` policy enforces security requirements for AWS EC2<br/>
instances before deployment.

##### Security Controls

- **Instance Type:** Only approved EC2 instance types are permitted.
- **EBS Encryption:** Root EBS volumes must be encrypted.
- **IMDSv2:** Instance metadata must require IMDSv2<br/>
  (`http_tokens = "required"`).
- **Missing Configuration:** Empty root block device or metadata settings<br/>
  are rejected.
- **Enforcement:** `hard-mandatory`.

Approved instance types are configured through the `allowed_instance_types`<br/>
parameter in `sentinel.hcl`.

##### Testing and Validation

Validated locally using Sentinel CLI v0.41.0.

| Test Scenario             | Expected Policy Result | Test Status   |
|---------------------------|------------------------|---------------|
| Secure EC2 configuration  | Allow                  | ![PASS][pass] |
| Unencrypted EBS volume    | Deny                   | ![PASS][pass] |
| Unapproved instance type  | Deny                   | ![PASS][pass] |
| IMDSv1 permitted          | Deny                   | ![PASS][pass] |
| Missing security settings | Deny                   | ![PASS][pass] |

All five EC2 Security Policy tests passed using `sentinel test -verbose`.

Cloud-based validation is documented in the HCP Terraform section below.

#### Terraform Supply Chain Security

The `terraform-supply-chain.sentinel` policy validates Terraform provider<br/>
sources to reduce supply chain risks.

Provider version locking and reviewing dependencies align with the<br/>
dependency-management guidance in<br/>
[Terraform Best Practices for AWS: 2026 Guide][itmagic].

##### Provider Source Validation

- Only approved Terraform provider sources are permitted.
- Approved sources are configured through `allowed_provider_sources`.
- The policy requires providers to declare version constraints.
- Enforcement level: `hard-mandatory`.

##### Testing and Validation

Validated locally using Sentinel CLI v0.41.0.

| Test Scenario              | Expected Result | Status        |
|----------------------------|-----------------|---------------|
| Approved AWS provider      | Allow           | ![PASS][pass] |
| Unapproved provider source | Deny            | ![PASS][pass] |

Both provider source validation tests passed using `sentinel test -verbose`.

Provider version validation and Terraform module controls were added in a<br/>
subsequent development increment, as documented below.

##### Provider Version Validation

- Terraform providers must declare version constraints.
- Providers without version constraints are rejected.

##### Module Source and Version Validation

- Only approved Terraform module sources are permitted.
- Approved sources are configured through `allowed_module_sources`.
- External modules must declare version constraints.
- Unapproved module sources and missing version constraints are rejected.
- Configurations without module calls are permitted.

##### Additional Testing and Validation

| Test Scenario                           | Expected Result | Status        |
|-----------------------------------------|-----------------|---------------|
| Provider without version constraint     | Deny            | ![PASS][pass] |
| Approved module with version constraint | Allow           | ![PASS][pass] |
| Unapproved module source                | Deny            | ![PASS][pass] |
| Module without version constraint       | Deny            | ![PASS][pass] |

All six Terraform Supply Chain test scenarios passed using<br/>
`sentinel test -verbose`.

Cloud-based validation is documented in the HCP Terraform section below.

##### Supply Chain Security Limitations

The Sentinel policy checks approved provider and module sources and requires<br/>
version constraints before Apply. It does not control the earlier dependency<br/>
installation performed during `terraform init`.

Terraform uses `.terraform.lock.hcl` to record provider versions and<br/>
checksums. Provider packages are checked against the recorded checksums;<br/>
registry-supplied signing information is also verified when available.<br/>
See [Dependency Lock File][dependency-lock] and<br/>
[Plugin Signatures][plugin-signing].

For a production environment, additional supply chain controls could include:

- Installing providers through an approved private mirror.<br/>
  See [Terraform CLI Configuration][provider-installation].
- Reviewing provider signing information and package checksums.<br/>
  See [Plugin Signatures][plugin-signing].
- Requiring review and approval before updating dependency versions.<br/>
  See [Dependency Lock File][dependency-lock].

An approved provider mirror and a separate dependency approval process were<br/>
not implemented in this academic project. It uses the official HashiCorp AWS<br/>
provider and manages seven AWS resources. The implemented controls focus on<br/>
Sentinel policy enforcement and reproducible provider installation.

#### Network Security Policy

The Network Security Policy enforces secure inbound access to AWS Security<br/>
Groups using HashiCorp Sentinel and Terraform plan data (`tfplan/v2`).

**Security controls:**

- Blocks public SSH access (TCP port 22) from `0.0.0.0/0` and `::/0`.
- Blocks unrestricted public access using protocol `-1`.
- Validates standalone `aws_vpc_security_group_ingress_rule` resources.
- Validates inline `ingress` rules within `aws_security_group` resources.
- Evaluates managed resources being created or updated.
- Allows public HTTPS (TCP port 443).

**Enforcement:** `hard-mandatory`

Blocking insecure public SSH ingress at plan time follows the policy-as-code<br/>
security principle discussed in
[Terraform Best Practices for AWS: 2026 Guide][itmagic].</br> The article uses OPA as an example; this project uses
Sentinel.

**Testing and validation:**

- 7 Network Security Policy test scenarios passed.
- 23 Sentinel test scenarios passed across all four policies.
- Positive and negative test cases validate allowed and prohibited<br/>
  configurations.

**Scope:** The policy covers the resource types and ingress configurations<br/>
listed above. Legacy `aws_security_group_rule` resources are not currently<br/>
evaluated.

#### HCP Terraform Integration and Deployment

The Terraform infrastructure and Sentinel policies were connected to HCP<br/>
Terraform through GitHub. Infrastructure was defined and validated locally<br/>
before cloud deployment. AWS IAM access was configured for remote execution;<br/>
an initial plan-only run verified the proposed changes, and a later apply run<br/>
created the resources.

##### 1. HCP Terraform Workspace and Sentinel Policy Set

| Component                   | Configuration                          |
|-----------------------------|----------------------------------------|
| HCP organization            | `ATU-LABS`                             |
| Workspace                   | `terraform-sentinel-dev`               |
| GitHub repository           | `maxvanny2010/terraform-sentinel`      |
| VCS branch                  | `master`                               |
| Terraform working directory | `terraform`                            |
| Policy set                  | `atu-lab-policies-vcs`                 |
| Sentinel policies directory | `sentinel`                             |
| Execution mode              | Remote                                 |
| Policy enforcement          | `hard-mandatory`                       |
| AWS region                  | `eu-west-1`                            |
| AWS authentication          | OIDC and temporary AWS STS credentials |

The VCS-backed Sentinel policy set evaluates Terraform runs before deployment.<br/>
GitHub stores the `.tf` files and Sentinel policy source; HCP Terraform stores<br/>
the workspace state and executes remote runs; AWS hosts the resulting<br/>
infrastructure.

**State location:** HCP Terraform -> organization `ATU-LABS` -> workspace<br/>
`terraform-sentinel-dev` -> **States**. The States tab provides current and<br/>
historical state versions; the Resources view shows managed resources in the<br/>
current state.

![VCS-backed Sentinel Policy Set](evidence/hcp-terraform/policy-set.png)

##### 2. AWS IAM Authentication for Remote Execution

HCP Terraform authenticates to AWS using **OpenID Connect (OIDC)** and<br/>
temporary **AWS STS credentials**, without storing permanent AWS access keys.<br/>
AWS IAM permissions are separated by run phase:

- **Plan:** `hcp-terraform-sentinel-plan` - AWS-managed<br/>
  `AmazonEC2ReadOnlyAccess`.
- **Apply:** `hcp-terraform-sentinel-apply` - custom<br/>
  `TerraformSentinelApplyPolicy` for project-scoped changes.

The Apply role's permissions were tested with the AWS IAM Policy Simulator<br/>
(see the evidence below). This follows the least-privilege and<br/>
temporary-credentials principles in<br/>
[Terraform Best Practices for AWS: 2026 Guide][itmagic].<br/> The implementation
follows [HashiCorp's AWS dynamic credentials documentation][hcp-aws-oidc].
![AWS IAM Plan Role](evidence/hcp-terraform/aws-plan-role.png)

##### 3. HCP Terraform Plan and Sentinel Validation

A **plan-only** run used Terraform v1.17.1 to inspect the proposed<br/>
infrastructure without deploying it.

- 7 resources to add
- 0 resources to change
- 0 resources to destroy
- 4 of 4 Sentinel policy checks ![PASS][pass]

| Sentinel policy               | Result        |
|-------------------------------|---------------|
| AWS Region Policy             | ![PASS][pass] |
| EC2 Security Policy           | ![PASS][pass] |
| Terraform Supply Chain Policy | ![PASS][pass] |
| Network Security Policy       | ![PASS][pass] |

At this stage, no AWS infrastructure had been created by HCP Terraform.

![HCP Terraform Plan and Sentinel Validation](evidence/hcp-terraform/terraform-plan.png)

##### 4. Apply Role Permission Validation

Before Apply, AWS IAM policy simulation was used to test the permissions of<br/>
`hcp-terraform-sentinel-apply`.

| Simulated request                                                      | Decision       |
|------------------------------------------------------------------------|----------------|
| `ec2:CreateVpc`<br/>`Project=terraform-sentinel`<br/>`Environment=dev` | `allowed`      |
| `ec2:CreateVpc`<br/>`Project=other-project`                            | `implicitDeny` |
| `ec2:RunInstances`<br/>`t3.micro` with approved tags                   | `allowed`      |
| `ec2:RunInstances`<br/>`t3.large` with approved tags                   | `implicitDeny` |

These simulations validated specific IAM policy decisions; they were not a<br/>
complete test of every AWS API operation needed for deployment.

![AWS IAM Policy Simulation](evidence/hcp-terraform/check_simulator.png)

##### 5. Successful Terraform Apply

A subsequent HCP Terraform run passed all four Sentinel policy checks and<br/>
completed **Apply** successfully.

- 7 resources added
- 0 resources changed
- 0 resources destroyed
- HCP Terraform state version created

![Successful HCP Terraform Apply](evidence/hcp-terraform/terraform-apply.png)

The following managed Terraform resources were created:

1. `aws_vpc.main`
2. `aws_subnet.private`
3. `aws_route_table.private`
4. `aws_route_table_association.private`
5. `aws_security_group.web`
6. `aws_vpc_security_group_egress_rule.https`
7. `aws_instance.web`

![Seven Terraform Resources Created](evidence/hcp-terraform/terraform-apply_resources.png)

##### 6. AWS Infrastructure Verification

###### VPC and Resource Tags

The VPC was created in `eu-west-1` with CIDR `10.0.0.0/16`. Its tags include<br/>
`Project=terraform-sentinel`, `Environment=dev`, `Owner=ATU-LABS`, and<br/>
`ManagedBy=Terraform`.

![Deployed VPC and Tags](evidence/hcp-terraform/vpc.png)

###### Network Architecture

The VPC contains a dedicated private subnet and route table. The route table<br/>
is configured for local VPC routing only; no Internet Gateway or NAT Gateway<br/>
was provisioned by this configuration.

![AWS VPC Resource Map](evidence/hcp-terraform/vpc_route-table.png)

###### Private Subnet

- Subnet CIDR: `10.0.1.0/24`
- Availability Zone: `eu-west-1a`
- Automatic public IPv4 assignment: Disabled
- Dedicated route table associated with the subnet

![AWS Private Subnet](evidence/hcp-terraform/subnet.png)

###### EC2 Security Group

- Inbound rules: None
- Outbound rule: HTTPS, TCP 443, destination `0.0.0.0/0`

The Security Group restricts permitted outbound traffic to TCP port 443. It<br/>
does not by itself provide internet connectivity; the private subnet has no<br/>
configured internet route.

![AWS Security Group Egress Rule](evidence/hcp-terraform/security-group.png)

###### EC2 Instance

- Instance ID: `i-0cc04f19dc3c8d213`
- Instance type: `t3.micro`
- OS image: Amazon Linux 2023
- State at verification: Running
- Private IPv4: `10.0.1.107`
- Public IPv4: None
- Subnet: Dedicated private subnet
- IMDSv2: Required
- SSH key pair: None
- Root EBS: Encrypted gp3 (specified in the Terraform configuration)

![AWS EC2 Instance Verification](evidence/hcp-terraform/ec2.png)

##### 7. Deployment Outcome

The project demonstrated a version-controlled Terraform workflow with local<br/>
Sentinel testing, HCP Terraform plan validation, IAM-based separation of Plan<br/>
and Apply permissions, mandatory Sentinel policy checks, and successful AWS<br/>
resource provisioning.

All seven planned Terraform resources were created and their main security<br/>
settings were verified in the AWS Console. The screenshots above document the<br/>
configuration, policy evaluation, deployment and resulting infrastructure.

#### Infrastructure Cleanup and Terraform Destroy

After successful deployment and security validation, the test infrastructure<br/>
was removed using HCP Terraform.

The destroy operation was executed through the HCP Terraform workspace<br/>
`terraform-sentinel-dev`.

##### Destroy Results

- 0 resources added
- 0 resources changed
- 7 resources destroyed
- 4 of 4 Sentinel policies ![PASS][pass]
- 0 managed resources remaining in the workspace

The destroy operation completed successfully without manually deleting<br/>
individual AWS resources.

![HCP Terraform Destroy](evidence/hcp-terraform/destroy-apply.png)

##### AWS Verification

The AWS EC2 console confirmed that the project instance<br/>
`terraform-sentinel-dev-web` was terminated.

![AWS EC2 Instance Terminated](evidence/hcp-terraform/ec2-terminated.png)

##### Conclusion

The complete infrastructure lifecycle was validated:

1. Terraform configuration and validation
2. Sentinel policy enforcement
3. Infrastructure planning
4. Infrastructure deployment
5. AWS security verification
6. Controlled infrastructure destruction

All seven Terraform-managed resources were successfully removed. The HCP<br/>
Terraform workspace retains its state history, but the last verified state<br/>
contained zero managed resources.

---

#### References

- Abgaryan, A. (2026) *Terraform Best Practices for AWS: 2026 Guide*.<br/>
  IT-Magic, 4 July. Available at: [Source][itmagic] (Accessed: 13 November<br/>
  2026).
- HashiCorp. *Manage workspace state in HCP Terraform*.<br/>
  [Source][hcp-state] (Accessed: 13 November 2026).
- HashiCorp. *Use dynamic credentials with the AWS provider in HCP<br/>
  Terraform*. [Source][hcp-aws-oidc] (Accessed: 13 November 2026).
- HashiCorp. *Terraform S3 backend (state storage and locking)*.<br/>
  [Source][s3-backend] (Accessed: 13 November 2026).
- GitHub. *Configuring OpenID Connect in Amazon Web Services*.<br/>
  [Source][github-oidc] (Accessed: 13 November 2026).
- Bridgecrew. *Checkov GitHub Action*. [Source][checkov] (Accessed: 13<br/>
  November 2026).
- AWS. *Terraform security best practices*. [Source][aws-security]<br/>
  (Accessed: 13 November 2026).
- HashiCorp. *Terraform CLI Configuration and Provider Installation*.<br/>
  [Source][provider-installation] (Accessed: 13 November 2026).
- HashiCorp. *Terraform Plugin Signatures*.<br/>
  [Source][plugin-signing] (Accessed: 13 November 2026).
- HashiCorp. *Terraform Dependency Lock File*.<br/>
  [Source][dependency-lock] (Accessed: 13 November 2026).

#### Development Tools and AI Assistance

The Terraform and Sentinel implementation was developed using official<br/>
HashiCorp and AWS documentation, practical testing, and AI-assisted<br/>
development.

**AI Tool:** ChatGPT (OpenAI).

ChatGPT assisted with Terraform configuration, Sentinel policy development,<br/>
troubleshooting, security reviews, and README documentation. Suggestions were<br/>
reviewed and adapted against the assignment requirements and validated through<br/>
Terraform commands, Sentinel tests, HCP Terraform policy checks, and AWS<br/>
infrastructure verification.

The final design decisions were based on the assignment requirements,<br/>
technical documentation, and practical testing results.

[pass]: https://img.shields.io/badge/PASS-2ea44f?style=flat-square

[itmagic]: https://itmagic.pro/blog/terraform-best-practices-for-aws-2026-guide

[hcp-state]: https://developer.hashicorp.com/terraform/cloud-docs/workspaces/state

[s3-backend]: https://developer.hashicorp.com/terraform/language/backend/s3

[github-oidc]: https://docs.github.com/en/actions/how-tos/secure-your-work/security-harden-deployments/oidc-in-aws

[checkov]: https://github.com/bridgecrewio/checkov-action

[hcp-aws-oidc]: https://developer.hashicorp.com/terraform/cloud-docs/dynamic-provider-credentials/aws-configuration

[aws-security]:
https://docs.aws.amazon.com/prescriptive-guidance/latest/terraform-aws-provider-best-practices/security.html

[provider-installation]: https://developer.hashicorp.com/terraform/cli/config/config-file

[plugin-signing]: https://developer.hashicorp.com/terraform/cli/plugins/signing

[dependency-lock]: https://developer.hashicorp.com/terraform/language/files/dependency-lock

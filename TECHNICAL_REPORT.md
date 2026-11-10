###### ATLANTIC TECHNOLOGICAL UNIVERSITY
### Cloud Infrastructure Security
###### Technical Report | Terraform & Sentinel

---

#### Project Objective

The aim of this work was to create a system for automatically checking cloud infrastructure before its deployment. For this I used Terraform, HashiCorp Sentinel, HCP Terraform and AWS.

#### Infrastructure Configuration

Seven AWS resources were described using Terraform configuration files. The infrastructure includes a virtual network (VPC), a private subnet, a route table, a security group and an EC2 instance. Security settings were applied such as no public IP address, disk encryption and required IMDSv2.

#### Security Policies

Four security policies were described using HashiCorp Sentinel. The first policy checks the AWS region where the infrastructure is deployed. The second checks EC2 security settings. The third checks the sources of Terraform providers and modules. The fourth blocks insecure network access settings.

#### Testing

Positive and negative test scenarios were created to check these policies. In total 23 local tests were run. All of them passed successfully.

#### HCP Terraform and AWS Integration

The next step was to connect GitHub to HCP Terraform. For secure access to AWS, OIDC authentication was configured and two IAM roles with different permissions were created. One role was used for planning changes and the other for applying them. IAM restrictions were also checked using the AWS IAM Policy Simulator. These tests showed that the roles allowed approved AWS actions and denied actions that did not meet the configured conditions.

### Deployment and Verification

After running Terraform Plan all four Sentinel policies passed their checks for infrastructure deployment.

Then I ran Terraform Apply and seven AWS resources were successfully created in the Ireland region. I checked the EC2, VPC, subnet and security group settings directly in the AWS Console.

### Infrastructure Cleanup

After checking the infrastructure I ran Terraform Destroy. All seven resources managed by Terraform were deleted and the EC2 instance received the status Terminated.

---
### Conclusion

As a result of this work I was able to complete the full process of managed cloud infrastructure deployment from creating the configuration and testing it to deployment and deletion. I think the main result of this work was that I could automatically check security requirements before creating resources in AWS.
###### ATLANTIC TECHNOLOGICAL UNIVERSITY

### Cloud Infrastructure Security

###### Technical Report | Terraform & Sentinel

---

#### Project Objective

The aim of this project was to automatically check cloud infrastructure security requirements before deployment using
Terraform, HashiCorp Sentinel, HCP Terraform and AWS.

#### Infrastructure Configuration

Seven AWS resources were defined, including a VPC, private subnet, route table, security group and EC2 instance.
Security measures included no public IP address, encrypted EBS storage and mandatory IMDSv2.

#### Security Policies

Four Sentinel policies were implemented to check AWS region restrictions, EC2 security settings, trusted Terraform
provider and module sources, and insecure network configurations.

#### Testing and Validation

All 23 local Sentinel tests passed, including positive and negative scenarios. HCP Terraform successfully evaluated all
four mandatory policies.

The infrastructure was deployed in AWS Ireland (`eu-west-1`), verified in the AWS Console and subsequently removed using
Terraform Destroy. All seven resources were destroyed.

#### Limitations and Recommendations

Sentinel evaluates Terraform plans but cannot prevent infrastructure changes made directly in AWS. Region restrictions
alone do not guarantee digital sovereignty because backups, data replication, administrative access and cloud provider
jurisdiction require additional controls.

Provider and module source restrictions reduce supply chain risks but cannot guarantee dependency integrity.

I would recommend restricting direct infrastructure changes through AWS IAM, introducing continuous compliance
monitoring, and strengthening data residency and dependency verification controls.

#### Conclusion

This project demonstrated that Terraform and Sentinel can enforce infrastructure security requirements before
deployment. However, effective protection also requires access controls, monitoring and additional supply chain security
measures.

policy "aws-region" {
  source            = "./aws-region.sentinel"
  enforcement_level = "hard-mandatory"

  params = {
    allowed_regions = ["eu-west-1"]
  }
}
policy "ec2-security" {
  source            = "./ec2-security.sentinel"
  enforcement_level = "hard-mandatory"

  params = {
    allowed_instance_types = ["t3.micro"]
  }
}
policy "terraform-supply-chain" {
  source            = "./terraform-supply-chain.sentinel"
  enforcement_level = "hard-mandatory"

  params = {
    allowed_provider_sources = [
      "registry.terraform.io/hashicorp/aws"
    ]
  }
}
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
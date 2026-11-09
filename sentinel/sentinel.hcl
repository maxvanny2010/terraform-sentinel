policy "aws-region" {
  source            = "./aws-region.sentinel"
  enforcement_level = "hard-mandatory"

  params = {
    allowed_regions = ["eu-west-1"]
  }
}
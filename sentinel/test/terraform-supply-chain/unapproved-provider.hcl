param "allowed_provider_sources" {
  value = ["registry.terraform.io/hashicorp/aws"]
}
param "allowed_module_sources" {
  value = ["terraform-aws-modules/vpc/aws"]
}

mock "tfconfig/v2" {
  module {
    source = "../../testdata/provider-unapproved.sentinel"
  }
}

test {
  rules = {
    main = false
  }
}
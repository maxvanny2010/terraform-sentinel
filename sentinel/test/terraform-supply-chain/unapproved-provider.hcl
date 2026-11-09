param "allowed_provider_sources" {
  value = ["registry.terraform.io/hashicorp/aws"]
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
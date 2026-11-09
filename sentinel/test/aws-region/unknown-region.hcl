param "allowed_regions" {
  value = ["eu-west-1"]
}

mock "tfplan/v2" {
  data = {
    resource_changes = {
      "aws_instance.web" = {
        mode          = "managed"
        provider_name = "registry.terraform.io/hashicorp/aws"

        change = {
          actions = ["create"]

          after = {}

          after_unknown = {
            region = true
          }
        }
      }
    }
  }
}

test {
  rules = {
    main = false
  }
}
param "allowed_instance_types" {
  value = ["t3.micro"]
}

mock "tfplan/v2" {
  module {
    source = "../../testdata/ec2-pass.sentinel"
  }
}

test {
  rules = {
    main = true
  }
}
mock "tfplan/v2" {
  module {
    source = "../../testdata/inline-all-ipv6.sentinel"
  }
}

test {
  rules = {
    main = false
  }
}

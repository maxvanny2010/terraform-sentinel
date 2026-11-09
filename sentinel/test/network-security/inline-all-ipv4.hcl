mock "tfplan/v2" {
  module {
    source = "../../testdata/inline-all-ipv4.sentinel"
  }
}

test {
  rules = {
    main = false
  }
}

mock "tfplan/v2" {
  module {
    source = "../../testdata/network-safe.sentinel"
  }
}

test {
  rules = {
    main = true
  }
}
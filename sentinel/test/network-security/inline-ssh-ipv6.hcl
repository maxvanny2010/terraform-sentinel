mock "tfplan/v2" {
  module {
    source = "../../testdata/inline-ssh-ipv6.sentinel"
  }
}

test {
  rules = {
    main = false
  }
}

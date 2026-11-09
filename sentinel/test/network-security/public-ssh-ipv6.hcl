mock "tfplan/v2" {
  module {
    source = "../../testdata/network-public-ssh-ipv6.sentinel"
  }
}

test {
  rules = {
    main = false
  }
}
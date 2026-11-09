mock "tfplan/v2" {
  module {
    source = "../../testdata/network-public-ssh.sentinel"
  }
}

test {
  rules = {
    main = false
  }
}
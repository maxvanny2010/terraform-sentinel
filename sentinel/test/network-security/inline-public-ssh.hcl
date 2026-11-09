mock "tfplan/v2" {
  module {
    source = "../../testdata/network-inline-ssh.sentinel"
  }
}

test {
  rules = {
    main = false
  }
}
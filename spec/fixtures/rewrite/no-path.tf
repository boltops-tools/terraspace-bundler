module "consul" {
  source = "hashicorp/consul/aws"
  version = "0.1.0"
}

module "example" {
  source = "github.com/hashicorp/example"
}

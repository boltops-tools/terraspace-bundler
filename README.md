# terraspace-bundler

[![Gem Version](https://badge.fury.io/rb/terraspace-bundler.png)](http://badge.fury.io/rb/terraspace-bundler)

[![BoltOps Badge](https://img.boltops.com/boltops/badges/boltops-badge.png)](https://www.boltops.com)

Bundles terraform modules based on a `Terrafile` to the `vendor/modules` folder. Used by the [Terraspace Terraform Framework](https://terraspace.cloud/).

## Usage

Create a `Terrafile` file:

```ruby
org "boltops-tools" # set default org

# GitHub repo with default org
mod "s3", source: "terraform-aws-s3", version: "master"

# GitHub repo with explicit org
# mod "elasticache", source: "boltopspro/terraform-aws-elasticache"

# Terraform registry
mod "sg", source: "terraform-aws-modules/security-group/aws", version: "3.10.0"
```

## Install

Running `terraspace bundle` creates the `Terrafile.lock` file, which locks the versions.

    terraspace bundle

For more detailed usage instructions refer to the [Terraspace Terrafile docs](https://terraspace.cloud/docs/terrafile/options/)

## Installation

To install:

    gem install terraspace-bundler

## Notes

* This is a simple implementation for [Terraspace](https://terraspace.cloud/) use.
* Handles updating the `Terrafile.lock` based on the `Terrafile`
* Others running the `terraspace bundle install` will install the exact same module versions based the `Terrafile.lock`.
* To update `Terraform.lock` run `terraspace bundle update`.
* The repos are downloaded to the `/tmp/terraspace-bundler` area as a cache. Delete the cache by running `terraspace bundle purge_cache`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/boltops-tools/terraspace-bundler.

# terraspace-bundler

Bundles terraform modules based on a `Terrafile` to the `vendor/modules` folder.

## Installation

To install:

    gem install terraspace-bundler

## Usage

Create a `Terrafile` file:

```ruby
org "boltopspro" # set default org

# GitHub repo with default org
mod "elb", source: "terraform-aws-elb", version: "master"
mod "ec2", source: "terraform-aws-ec2", version: "branch-name"

# GitHub repo with explicit org
mod "rds", source: "boltopspro/terraform-aws-rds", version: "v0.1.0"

# Terraform registry
mod "sg", source: "terraform-aws-modules/security-group/aws", version: "3.10.0"
```

Running `terraspace bundle` creates the `Terrafile.lock` file, which locks the downloaded versions.

    terraspace bundle

## Updating

To update all the locked versions in `Terrafile.lock` run `terraspace bundle update`. You can also simply delete the `Terrafile.lock` file.

    terraspace bundle update

You can selectively update only one module:

    terraspace bundle update MOD

## Removing vendor/modules

The `terraspace bundle` commands will only update the modules it knows about in `Terrafile`. To clear out old modules, delete them from `vendor/modules`. You can clean them all out like so:

    rm -rf vendor/modules
    terraspace bundle update

## base url

The base url used for clone is `git@github.com:`. You can change it with `base_url`, example:

```ruby
org "boltops-tools" # set default org
base_url "https://github.com/"  # default base url for git clone

mod "s3", source: "terraform-aws-s3", version: "master"
```

## export_path

The default export path is `vendor/modules`, you can change it:

```ruby
org "boltops-tools" # set default org
export_path "app/modules"

mod "s3", source: "terraform-aws-s3", version: "master"
```

## Notes

* Simple implementation for [Terraspace](https://terraspace.cloud/) use.
* Handles updating the `Terrafile.lock` based on the `Terrafile`
* Others running the `terraspace bundle install` will install the exact same module versions based the `Terrafile.lock`.
* To update `Terraform.lock` run `terraspace bundle update`.
* The repos are downloaded to `/tmp/terraspace-bundler` area as a cache. Delete the cache by running `terraspace bundle clean`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/boltops-tools/terraspace-bundler.

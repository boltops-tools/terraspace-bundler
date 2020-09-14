# terraspace-bundler

Bundles terraform modules based on a `Terrafile` to the `vendor/modules` folder. Used by the [Terraspace Terraform Framework](https://terraspace.cloud/).

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

## Install

Running `terraspace bundle` creates the `Terrafile.lock` file, which locks the versions.

    terraspace bundle

## Updating

To update all the locked versions in `Terrafile.lock` run `terraspace bundle update`. You can also delete the `Terrafile.lock` file first.

    terraspace bundle update

You can selectively update multiple modules:

    terraspace bundle update MODS
    terraspace bundle update mod1 mod2

## List & Info

    terraspace bundle list
    terraspace bundle info mod1

## DSL Methods

Some of these are methods that apply globally at the Terrafile level. Some of these are options that apply the at the mod method level.

### Terrafile level

Name | Description | Default
--- |  --- | ---
base_clone_url | Base clone url to use | git@gihtub.com:
export_path |  Where the modules get exported to saved to. | vendor/modules
export_purge | Where or not to clean up all existing exported modules folder first. | true

### Mod Method level

Name | Description | Default
--- |  --- | ---
subfolder | The subfolder where the module lives within the repo. | nil
export_to | Overrides the export_path Terrafile level option. With this one-off option, other modules in this folder will not be purged. | nil

Examples of some of the options are below:

### base url

The base url used for clone is `git@github.com:`. You can change it with `base_url`, example:

```ruby
base_url "https://github.com/"  # default base url for git clone
# ...
```

### export_path

The default export path is `vendor/modules`, you can change it:

```ruby
export_path "app/modules"
# ...
```

## prune

The `terraspace bundle` commands removes all files in the export_path, `vendor/modules`, by default. You can disable this behavior with:

```ruby
export_purge false
# ...
```

### subfolder

The default export path is `vendor/modules`, you can change it:

```ruby
# ...
mod "s3", source: "terraform-aws-s3", subfolder: "path/to/module/s3"
```

## Config Options

You can also configure some behavior with `TB.config`. IE: `TB.config.terrafile = "/path/to/Terrafile"`

Name | Description | Default
--- | --- | ---
base_clone_url | Base git url to use for cloning | git@github.com:
export_path | Where to export the modules to. Can also be set with the env var TB_EXPORT_PATH | vendor/modules
export_purge | Whether or not to prune all the modules | true
logger | Logger instance
terrafile | The Terrafile path. Can also be set with the env TB_TERRAFILE || "Terrafile"

## Installation

To install:

    gem install terraspace-bundler

## Notes

* This is a simple implementation for [Terraspace](https://terraspace.cloud/) use.
* Handles updating the `Terrafile.lock` based on the `Terrafile`
* Others running the `terraspace bundle install` will install the exact same module versions based the `Terrafile.lock`.
* To update `Terraform.lock` run `terraspace bundle update`.
* The repos are downloaded to `/tmp/terraspace-bundler` area as a cache. Delete the cache by running `terraspace bundle purge_cache`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/boltops-tools/terraspace-bundler.

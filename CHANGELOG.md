# Change Log

All notable changes to this project will be documented in this file.
This project *loosely tries* to adhere to [Semantic Versioning](http://semver.org/), even before v1.0.

## [0.5.0] - 2022-01-15
- [#17](https://github.com/boltops-tools/terraspace-bundler/pull/17) ssh notation support

## [0.4.3] - 2021-11-20
- [#14](https://github.com/boltops-tools/terraspace-bundler/pull/14) get version and use only that part of api since the latest version is currently down with a 502
- [#15](https://github.com/boltops-tools/terraspace-bundler/pull/15) terraspace bundle example command

## [0.4.2] - 2021-10-02
- stack src option: also understand example and name

## [0.4.1] - 2021-09-30
- [#13](https://github.com/boltops-tools/terraspace-bundler/pull/13) fix stacks Array option

## [0.4.0] - 2021-08-10
- [#10](https://github.com/boltops-tools/terraspace-bundler/pull/10) terraspace bundle info: warning when no lockfile
- [#12](https://github.com/boltops-tools/terraspace-bundler/pull/12) support for: private registry, s3, gcs, local

## [0.3.4] - 2021-04-15
- [#11](https://github.com/boltops-tools/terraspace-bundler/pull/11) improve registry dectection and gitlab repository support

## [0.3.3] - 2021-02-24
- [#8](https://github.com/boltops-tools/terraspace-bundler/pull/8) fix https sources
- [#9](https://github.com/boltops-tools/terraspace-bundler/pull/9) Git checkout retry with v

## [0.3.2]
- #4 only purge and export explicit mods
- are you sure prompt for purge_cache
- clean up update mode

## [0.3.1]
- #3 all_stacks: only consider dirs

## [0.3.0]
- #2 bundle improvements
- change `base_clone_url` default from `git@github.com:` to `https://github.com/`
- mod-level stack option
- terrafile-level stack_options
- rename terrafile-level option to export_to

## [0.2.0]
- #1 Rework implementation. Better Terrafile syncing
- clearer implementation: Terrafile and Lockfile classes build standard mods object.
- add commands: info, list
- sync of Terrafile with vendor/modules
- rename command: terraspace bundle purge_cache
- rename option to relative_root for modules within a subfolder within a repo
- prune exported modules by default
- export_prune option
- Allow configuring the logger formatter
- validate org is set if used
- mod export_to option

## [0.1.0]
- Initial release.

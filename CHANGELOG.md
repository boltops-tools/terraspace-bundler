# Change Log

All notable changes to this project will be documented in this file.
This project *loosely tries* to adhere to [Semantic Versioning](http://semver.org/), even before v1.0.

## [0.3.0 UNRELEASED]
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

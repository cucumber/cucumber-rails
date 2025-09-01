# Changelog

All notable changes to this project will be documented in this file. For older versions see the [changelog archive](./CHANGELOG.old.md)

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

This file is intended to be modified using the [`changelog`](https://github.com/cucumber/changelog) command-line tool.

## [Unreleased]

## [4.0.0] - 2025-09-01
### Changed
- In-line with minimum ruby / rails, a lot of internal non-breaking refactors have been done to remove legacy code

### Removed
- Removed support for Ruby 2.6 - 3.1 (Ruby 3.2 is now the lowest version)
- Removed support for Rails 5.2 and 6.0 (6.1 is still supported and 7.0+ is preferred)

## [3.1.1] - 2025-01-30
### Changed
- Updated some dev dependencies and improved some dev rake tasks to make testing leaner

## [3.1.0] - 2024-11-25
### Added
- Add support for Rails 8.0 (No code changes required) [#590](https://github.com/cucumber/cucumber-rails/pull/590)

## [3.0.1] - 2024-11-05
### Added
- Add support for Rails 7.2 / Ruby 3.3 (No code changes required) [#586](https://github.com/cucumber/cucumber-rails/pull/586) [#588](https://github.com/cucumber/cucumber-rails/pull/588)

### Fixed
- Internal testing code has been refactored to handle older ruby/rails installs [#583](https://github.com/cucumber/cucumber-rails/pull/583)

## [3.0.0] - 2023-11-01
### Added
- Add support for Rails 7.1 [#575](https://github.com/cucumber/cucumber-rails/pull/575)
- Added new rubocop sub-gems (rails / rake) and updated repo to be rubocop 2.6 conformant [#581](https://github.com/cucumber/cucumber-rails/pull/581)

### Fixed
- Some of the rails 5.2 tests were installing lots of old conflicting gems ([luke-hill](https://github.com/luke-hill))
- Generator updates (Updated the install locations for some scripts from `script/` to `bin/` and remove some legacy items)
([luke-hill](https://github.com/luke-hill))
- Update minimum versions of several gems: capybara must be `v3.11+` and cucumber must be `v5+` (cucumber v9 is also permissible)
([luke-hill](https://github.com/luke-hill))
- Fixed an issue where the World instantiation didn't re-run the inherited classes initializer ([luke-hill](https://github.com/luke-hill))

## [3.0.0.rc.1] - 2023-09-15
### Removed
- Removed runtime dependencies: `mime-types`, `rexml`, and `webrick` [#559](https://github.com/cucumber/cucumber-rails/pull/559)
- Removed support for Ruby 2.5 [#558](https://github.com/cucumber/cucumber-rails/pull/558)
- Removed support for Rails 5.0 and 5.1 (5.2 is still supported and 6.0+ is now expected) [#565](https://github.com/cucumber/cucumber-rails/pull/565)

## [2.6.1] - 2022-10-12
### Changed
- Automate release process [#554](https://github.com/cucumber/cucumber-rails/pull/554)

## [2.6.0] - 2022-10-07
### Changed
- Gem update: allowed cucumber 8 ([#538](https://github.com/cucumber/cucumber-rails/pull/538) / [#541](https://github.com/cucumber/cucumber-rails/pull/541) [mattwynne](https://github.com/mattwynne))
- New release process. Older releases are in [this changelog](./CHANGELOG.old.md)

### Fixed
- Some bugs with dev dependencies have now been fixed externally, so these have been unrestricted
([#552](https://github.com/cucumber/cucumber-rails/pull/552) [BrianHawley](https://github.com/BrianHawley))
- Fixed up some rubocop offenses from updated `rubocop-performance`
([#550](https://github.com/cucumber/cucumber-rails/pull/550) [olleolleolle](https://github.com/olleolleolle))

[Unreleased]: https://github.com/cucumber/cucumber-rails/compare/v4.0.0...HEAD
[4.0.0]: https://github.com/cucumber/cucumber-rails/compare/v3.1.1...v4.0.0
[3.1.1]: https://github.com/cucumber/cucumber-rails/compare/v3.1.0...v3.1.1
[3.1.0]: https://github.com/cucumber/cucumber-rails/compare/v3.0.1...v3.1.0
[3.0.1]: https://github.com/cucumber/cucumber-rails/compare/v3.0.0...v3.0.1
[3.0.0]: https://github.com/cucumber/cucumber-rails/compare/v3.0.0.rc.1...v3.0.0
[3.0.0.rc.1]: https://github.com/cucumber/cucumber-rails/compare/v2.6.1...v3.0.0.rc.1
[2.6.1]: https://github.com/cucumber/cucumber-rails/compare/v2.6.0...v2.6.1
[2.6.0]: https://github.com/cucumber/cucumber-rails/compare/v2.5.1...v2.6.0

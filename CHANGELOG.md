# ChangeLog

All notable changes to this project will be documented in this file.

## [Unreleased]

## [0.4.25]

### Added

- Add GitLab JUnit reporter. [#163](https://github.com/IBDecodable/IBLinter/pull/163)
- Add `stackview_backgroundcolor` rule, which detects background color definition for `UIStackView` to keep appearance compatibility between iOS 14 and less than iOS 13. [#165](https://github.com/IBDecodable/IBLinter/pull/165)
- Add `use_trait_collections` rule, which checks if a document `useTraitCollections` is enabled or disabled. [#164](https://github.com/IBDecodable/IBLinter/pull/164)

## [0.4.24]

### Added

- Support Linux platform. [#160](https://github.com/IBDecodable/IBLinter/pull/160)

### Fixed

- Fix cache file name issue. [#157](https://github.com/IBDecodable/IBLinter/pull/157)
- Fix duplicated constraints for multiplier. [#161](https://github.com/IBDecodable/IBLinter/pull/161)

## [0.4.23]

### Added

- Support `UICollectionReusableView` for `reuse_identifier` rule. [#152](https://github.com/IBDecodable/IBLinter/pull/152)

### Fixed

- Respect `verifyAmbiguity` for `ambiguous` rule [#154](https://github.com/IBDecodable/IBLinter/pull/154)

## [0.4.22]

### Added

- Add rule `color_resources`, which detect missing named colors similar to image_resources rule. [#141](https://github.com/IBDecodable/IBLinter/pull/141)
- Support custom symbol image for `image_resources` rule. [#142](https://github.com/IBDecodable/IBLinter/pull/142)

## [0.4.21]

### Added

- Add rule `duplicate_id`, which detect xml element duplicate id [#126](https://github.com/IBDecodable/IBLinter/pull/126)
- Add rule `reuse_identifier` which checks that ReuseIdentifier same as class name. [#137](https://github.com/IBDecodable/IBLinter/pull/137)

### Fixed

- Do not detect violations for system images for `image_resources` rule. [#131](https://github.com/IBDecodable/IBLinter/pull/131)

## [0.4.20]

### Fixed

- Add cache system and significantly improve performance when running with a large number files. [#124](https://github.com/IBDecodable/IBLinter/pull/124)

## [0.4.19]

### Fixed

- Remove platform parameter from podspec to fix installation failure for CocoaPods. [#121](https://github.com/IBDecodable/IBLinter/pull/121)

## [0.4.18]

### Fixed

- Fix `custom_module` rule logic to check all candidates of module which matches class name. [#114](https://github.com/IBDecodable/IBLinter/pull/114)

## [0.4.17]

### Added

- Add support validating placeholder and viewController module [#109](https://github.com/IBDecodable/IBLinter/pull/109)

## [0.4.16]
### Fixed
Fix bug where IBLinter ignores to validate UICollectionViewCell. [#97](https://github.com/IBDecodable/IBLinter/pull/97)

## [0.4.15]
### Fixed
- XIB files were not validated since 0.4.14. [#94](https://github.com/IBDecodable/IBLinter/pull/94)
- Fix `custom_module` to support relative paths. [#95](https://github.com/IBDecodable/IBLinter/pull/95)
## [0.4.14]
### Added
- Add this `CHANGELOG.md`
- Add `CheckstyleReporter` [#92](https://github.com/IBDecodable/IBLinter/pull/92)
### Removed
- Remove `IBLinterfile` feature until module ABI stability
## [0.4.13] - 2019-3-30
### Added
- Add `view_as_device` rule [#86](https://github.com/IBDecodable/IBLinter/pull/86)
## [0.4.12] - 2019-3-13
### Added
- Add `use_base_class` rule [#84](https://github.com/IBDecodable/IBLinter/pull/84)
- Add `disable_while_building_for_ib` option to skip validation while `@IBDesignable`. [#85](https://github.com/IBDecodable/IBLinter/pull/85)
### Fixed
- Fix config included behavior [#81](https://github.com/IBDecodable/IBLinter/issues/81)
## [0.4.11] - 2018-12-20
### Fixed
- Support Xcode 10 [#78](https://github.com/IBDecodable/IBLinter/pull/78)
## [0.4.10] - 2018-11-21
## [0.4.9] - 2018-10-24
## [0.4.8] - 2018-10-23
## [0.4.7] - 2018-10-23
## [0.4.6] - 2018-10-16
## [0.4.4] - 2018-9-27
## [0.4.3] - 2018-9-2
## [0.4.2] - 2018-8-14
## [0.4.1] - 2018-8-14
## [0.4.0] - 2018-8-13
## [0.3.0] - 2018-5-17
## [0.2.0] - 2018-2-7
## [0.1.5] - 2018-1-5
## [0.1.4] - 2017-12-23
## [0.1.3] - 2017-12-23
## [0.1.2] - 2017-12-15
## [0.1.1] - 2017-12-15

## 0.1.0 - 2017-12-15
### Added
- First version


[Unreleased]: https://github.com/IBDecodable/IBLinter/compare/0.4.25...HEAD
[0.4.25]: https://github.com/IBDecodable/IBLinter/compare/0.4.24...0.4.25
[0.4.24]: https://github.com/IBDecodable/IBLinter/compare/0.4.23...0.4.24
[0.4.23]: https://github.com/IBDecodable/IBLinter/compare/0.4.22...0.4.23
[0.4.22]: https://github.com/IBDecodable/IBLinter/compare/0.4.21...0.4.22
[0.4.21]: https://github.com/IBDecodable/IBLinter/compare/0.4.20...0.4.21
[0.4.20]: https://github.com/IBDecodable/IBLinter/compare/0.4.19...0.4.20
[0.4.19]: https://github.com/IBDecodable/IBLinter/compare/0.4.18...0.4.19
[0.4.18]: https://github.com/IBDecodable/IBLinter/compare/0.4.17...0.4.18
[0.4.17]: https://github.com/IBDecodable/IBLinter/compare/0.4.16...0.4.17
[0.4.16]: https://github.com/IBDecodable/IBLinter/compare/0.4.15...0.4.16
[0.4.15]: https://github.com/IBDecodable/IBLinter/compare/0.4.14...0.4.15
[0.4.14]: https://github.com/IBDecodable/IBLinter/compare/0.4.13...0.4.14
[0.4.13]: https://github.com/IBDecodable/IBLinter/compare/0.4.12...0.4.13
[0.4.12]: https://github.com/IBDecodable/IBLinter/compare/0.4.11...0.4.12
[0.4.11]: https://github.com/IBDecodable/IBLinter/compare/0.4.10...0.4.11
[0.4.10]: https://github.com/IBDecodable/IBLinter/compare/0.4.9...0.4.10
[0.4.9]: https://github.com/IBDecodable/IBLinter/compare/0.4.8...0.4.9
[0.4.8]: https://github.com/IBDecodable/IBLinter/compare/0.4.7...0.4.8
[0.4.7]: https://github.com/IBDecodable/IBLinter/compare/0.4.6...0.4.7
[0.4.6]: https://github.com/IBDecodable/IBLinter/compare/0.4.5...0.4.6
[0.4.5]: https://github.com/IBDecodable/IBLinter/compare/0.4.4...0.4.5
[0.4.4]: https://github.com/IBDecodable/IBLinter/compare/0.4.3...0.4.4
[0.4.3]: https://github.com/IBDecodable/IBLinter/compare/0.4.2...0.4.3
[0.4.2]: https://github.com/IBDecodable/IBLinter/compare/0.4.1...0.4.2
[0.4.1]: https://github.com/IBDecodable/IBLinter/compare/0.4.0...0.4.1
[0.4.0]: https://github.com/IBDecodable/IBLinter/compare/0.3.0...0.4.0
[0.3.0]: https://github.com/IBDecodable/IBLinter/compare/0.2.0...0.3.0
[0.2.0]: https://github.com/IBDecodable/IBLinter/compare/v0.1.5...0.2.0
[0.1.5]: https://github.com/IBDecodable/IBLinter/compare/v0.1.4...v0.1.5
[0.1.4]: https://github.com/IBDecodable/IBLinter/compare/v0.1.3...v0.1.4
[0.1.3]: https://github.com/IBDecodable/IBLinter/compare/v0.1.2...v0.1.3
[0.1.2]: https://github.com/IBDecodable/IBLinter/compare/v0.1.1...v0.1.2
[0.1.1]: https://github.com/IBDecodable/IBLinter/compare/v0.1.0...v0.1.1

# IBLinter
[![Build Status](https://travis-ci.org/IBDecodable/IBLinter.svg?branch=master)](https://travis-ci.org/IBDecodable/IBLinter)
[![Swift 4.0](https://img.shields.io/badge/Swift-4.0-orange.svg?style=flat)](https://developer.apple.com/swift/)

A linter tool to normalize `.xib` and `.storyboard` files. Inspired by [realm/SwiftLint](https://github.com/realm/SwiftLint)

![](assets/warning.png)

## Installation

### Using [Homebrew](http://brew.sh/)

```sh
$ brew install IBDecodable/homebrew-tap/iblinter
```

### Using [CocoaPods](https://cocoapods.org)

```sh
pod 'IBLinter'
```

This will download the IBLinter binaries and dependencies in `Pods/` during your next
`pod install` execution and will allow you to invoke it via `${PODS_ROOT}/IBLinter/bin/iblinter`
in your Script Build Phases.

### Compiling from source

You can build from source by cloning this repository and running
```
$ make install
```
`iblinter` will be installed in `/usr/local/bin`.

## Usage

You can see all description by `iblinter help`

```
$ iblinter help
Available commands:

   help      Display general or command-specific help
   lint      Print lint warnings and errors (default command)
   version   Display the current version of SwiftLint
```

### Xcode

Add a `Run Script Phase` to integrate IBLinter with Xcode

```sh
if which iblinter >/dev/null; then
  iblinter lint
else
  echo "warning: IBLinter not installed, download from https://github.com/IBDecodable/IBLinter"
fi
```

Alternatively, if you've installed IBLinter via CocoaPods the script should look like this:

```sh
"${PODS_ROOT}/IBLinter/bin/iblinter"
```

## Rules

| Rule id                        | description                                                                    |
|:-------------------------------|:-------------------------------------------------------------------------------|
| `custom_class_name`            | Custom class name of ViewController in storyboard should be same as file name. |
| `relative_to_margin`           | Forbid to use `relative to margin` option.                                     |
| `misplaced`                    | Display error when views are misplaced.                                        |
| `ambiguous`                    | Display error when views are ambiguous.                                        |
| `enable_autolayout`            | Force to use `useAutolayout` option                                            |
| `duplicate_constraint`         | Display warning when view has duplicated constraint.                           |
| `storyboard_viewcontroller_id` | Check that Storyboard ID same as ViewController class name.                    |
| `image_resources`              | Check if image resources are valid.                                            |
| `custom_module`                | Check if custom class match custom module by `custom_module_rule` config.      |
| `use_base_class`               | Check if custom class is in base classes by `use_base_class_rule` config.      |
| `view_as_device`               | Check `View as:` set as a device specified by `view_as_device_rule` config.    |


Pull requests are encouraged.


## Configuration

You can configure IBLinter by adding a `.iblinter.yml` file from project root directory.


| key                  | description                 |
|:---------------------|:--------------------------- |
| `enabled_rules`      | Enabled rules id.           |
| `disabled_rules`     | Disabled rules id.          |
| `excluded`           | Path to ignore for lint.    |
| `included`           | Path to include for lint.   |
| `custom_module_rule` | Custom module rule configs. |
| `use_base_class_rule`| Use base class rule configs.|
| `view_as_device_rule`| View as device rule configs.|

### CustomModuleConfig

You can configure `custom_module` rule by `CustomModuleConfig` list.

| key        | description                                                                  |
|:-----------|:---------------------------------------------------------------------------- |
| `module`   | Module name.                                                                 |
| `included` | Path to `*.swift` classes of the module for `custom_module` lint.            |
| `excluded` | Path to ignore for `*.swift` classes of the module for `custom_module` lint. |

### UseBaseClassConfig

You can configure `use_base_class` rule by `UseBaseClassConfig` list.

| key               | description                        |
|:------------------|:---------------------------------- |
| `element_class`   | Element class name.                |
| `base_classes`    | Base classes of the element class. |

**Note:** UseBaseClassRule does not work for classes that inherit base class. You need to add all classes to `base_classes` to check.

### ViewAsDeviceConfig

You can configure `view_as_device` rule by `ViewAsDeviceConfig`. If there are no config, `device_id` is set as `retina4_7`.  

| key               | description                        |
|:------------------|:---------------------------------- |
| `device_id`       | Device id for device.              |

**appx.** Table of mapping device name to `device_id` (on `Xcode 10.2`) 

| device name       | device id            |
|:------------------|:-------------------- |
| `iPhone 4s`       | `retina3_5`          |
| `iPhone SE`       | `retina4_0`          |
| `iPhone 8`        | `retina4_7`          |
| `iPhone 8 Plus`   | `retina5_5`          |
| `iPhone XS`       | `retina5_9`          |
| `iPhone XR`       | `retina6_1`          |
| `iPhone XS Max`   | `retina6_5`          |


```yaml
enabled_rules:
  - relative_to_margin
disabled_rules:
  - custom_class_name
excluded:
  - Carthage
  - App
included:
  - App/Views
custom_module_rule:
  - module: UIComponents
    included:
      - UIComponents/Classes
    excluded:
      - UIComponents/Classes/Config/Generated
use_base_class_rule:
  - element_class: UILabel
    base_classes:
      - PrimaryLabel
      - SecondaryLabel
view_as_device_rule:
  device_id: retina4_0
```

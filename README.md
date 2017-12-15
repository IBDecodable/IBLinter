# IBLinter

A linter tool to normarize `.xib` and `.storyboard` files. Inspired by [realm/SwiftLint](https://github.com/realm/SwiftLint)

![](assets/warning.png)

## Installation

```
$ brew install kateinoigakukun/homebrew-tap/iblinter
```

## Usage

You can see all description by `iblinter help`

- `lint` Print lint warnings and errors (default command)
	- `--path` default is current directory.



### Xcode

Add a `Run Script Phase` to integrate IBLinter with Xcode

```sh
if which iblinter >/dev/null; then
  iblinter lint
fi
```


## Rules

| Rule id              | description                                                                    |
|:---------------------|:-------------------------------------------------------------------------------|
| `custom_class_name`  | Custom class name of ViewController in storyboard should be same as file name. |
| `relative_to_margin` | Forbid to use `relative to margin` option.                                     |
| `misplaced`          | Display error when views are misplaced.                                        |
| `enable_autolayout`  | Force to use `useAutolayout` option                                            |


Pull requests are encouraged.


## Configuration

You can configure IBLinter by adding a `.iblinter.yml` file from project root directory.


| key              | description              |
|:-----------------|:-------------------------|
| `enabled_rules`  | Enabled rules id.        |
| `disabled_rules` | Disabled rules id.       |
| `excluded`       | Path to ignore for lint. |


```yaml
enabled_rules:
  - relative_to_margin
disabled_rules:
  - custom_class_name
excluded:
  - Carthage
```

# IBLinter

A linter tool to normarize `.xib` and `.storyboard` files. Inspired by [realm/SwiftLint](https://github.com/realm/SwiftLint)

![](assets/warning.png)

## Installation

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

Pull requests are encouraged.


## Configuration

You can configure IBLinter by adding a `.iblinter` file from project root directory.

|key|description|
|-::|-::|
|`enabled_rules` | Enable rules.|
|`disabled_rules`| Disable rules.
|`excluded`	  	 | Path to ignore for lint.|

```yaml
enabled_rules:
  - relative_to_margin
disabled_rules:
  - custom_class_name
excluded:
  - Carthage
```
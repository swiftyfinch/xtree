<div align="center">
  <br />
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://github.com/swiftyfinch/xtree/assets/64660122/f05e9f11-8876-49bd-90b4-ab8c89ead850" width=200>
    <source media="(prefers-color-scheme: light)" srcset="https://github.com/swiftyfinch/xtree/assets/64660122/972080ab-e35d-47d9-816d-264aff4770dd" width=200>
    <img src="https://user-images.githubusercontent.com/25423296/163456779-a8556205-d0a5-45e2-ac17-42d089e3c3f8.png">
  </picture>
  <p align="center">
    <img src="https://img.shields.io/badge/Platform-macOS-2679eb" />
    <img src="https://img.shields.io/badge/Swift-5.10-ea5a44" />
    <img src="https://komarev.com/ghpvc/?username=swiftyfinch-xtree&label=Views&format=true&base=0" />
    <br />
    <img src="https://img.shields.io/badge/Press_★_to_pay_respects-fff?logo=github&logoColor=black" />
  </p>
  <img src="https://github.com/swiftyfinch/xtree/assets/64660122/3fdef9d7-a211-4834-8382-05620cb368a8" width=400>
</div>

# Motivation

Sometimes, we need to analyze different tree structures for research purposes.\
Usually, I would write some simple scripts to accomplish these goals.\
However, after thinking about it, I decided to create a small utility with a set of useful commands.\
And I am sharing it with you right here.

<br>

# How to use 🌳

Right now, it supports the following inputs:
- Standard Xcode project: `*.xcodeproj`
- [CocoaPods](https://cocoapods.org): `Podfile.lock`
- YAML file with [a specific format](docs/inputs/yaml.md): `*.yml`/`*.yaml`

###### 📖 Commands Help
```sh
> xtree --help

 🌳 Printing and analyzing trees in a handy way.
╭─────────────┬────────────────────────────────────────────╮
│ > print     │ * Print a tree with children statistics.   │
│ > frequency │ * Calculate a frequency of each node.      │
│ > parents   │ * Find all parents of nodes.               │
│ > update    │ * Download and install the latest version. │
│             │                                            │
│ --version   │ * Show the version.                        │
│ --help, -h  │ * Show help information.                   │
╰─────────────┴────────────────────────────────────────────╯
```
- [`print`](docs/commands-help/print.md)
- [`frequency`](docs/commands-help/frequency.md)
- [`parents`](docs/commands-help/parents.md)

<br>

# How to install 📦

###### First Install

For simplicity, you don't need to install a package manager.\
Just run the short script provided below and it will install `xtree` in your `$HOME/.local/bin` directory.
```sh
curl -Ls https://swiftyfinch.github.io/xtree/install.sh | bash
```

###### Self-Update

Please note that the `xtree update` command will also install the latest version in your `$HOME/.local/bin` directory.
```sh
> xtree update
```

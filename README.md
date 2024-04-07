<div align="center">
  <br />
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://github.com/swiftyfinch/xtree-staging/assets/64660122/72ad45fc-6f5b-4601-918a-f720dea97372" width=200>
    <source media="(prefers-color-scheme: light)" srcset="https://github.com/swiftyfinch/xtree-staging/assets/64660122/cbe39ab2-3ad7-465c-9097-f30ccd52e2cb" width=200>
    <img src="https://user-images.githubusercontent.com/25423296/163456779-a8556205-d0a5-45e2-ac17-42d089e3c3f8.png">
  </picture>
  <p align="center">
    <img src="https://img.shields.io/badge/Platform-macOS-2679eb" />
    <img src="https://img.shields.io/badge/Swift-5.10-ea5a44" />
    <img src="https://komarev.com/ghpvc/?username=swiftyfinch-xtree&label=Views&format=true&base=0" />
    <br />
    <img src="https://img.shields.io/badge/Press_★_to_pay_respects-fff?logo=github&logoColor=black" />
  </p>
</div>

<p align="center">
  <img src="https://github.com/swiftyfinch/xtree-staging/assets/64660122/a690f33c-34de-40a2-8ac5-24a9dfb9623f" width=400>
</p>

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

```sh
curl -Ls https://swiftyfinch.github.io/xtree/install.sh | bash
```

###### Self-Update

```sh
> xtree update
```

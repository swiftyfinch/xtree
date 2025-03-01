<div align="center">
  <br />
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://github.com/swiftyfinch/xtree/assets/64660122/f05e9f11-8876-49bd-90b4-ab8c89ead850" width=200>
    <source media="(prefers-color-scheme: light)" srcset="https://github.com/swiftyfinch/xtree/assets/64660122/972080ab-e35d-47d9-816d-264aff4770dd" width=200>
    <img src="https://user-images.githubusercontent.com/25423296/163456779-a8556205-d0a5-45e2-ac17-42d089e3c3f8.png">
  </picture>
  <p>Printing and analyzing trees in a handy way</p>
  <p align="center">
    <a href="https://swiftpackageindex.com/swiftyfinch/xtree"><img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fswiftyfinch%2Fxtree%2Fbadge%3Ftype%3Dplatforms" /></a>
    <a href="https://swiftpackageindex.com/swiftyfinch/xtree"><img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fswiftyfinch%2Fxtree%2Fbadge%3Ftype%3Dswift-versions" /></a>
    <img src="https://komarev.com/ghpvc/?username=swiftyfinch-xtree&label=Views&format=true&base=0" />
    <br />
    <img src="https://img.shields.io/badge/Press_★_to_pay_respects-fff?logo=github&logoColor=black" />
    <a href="https://tooomm.github.io/github-release-stats/?username=swiftyfinch&repository=xtree"><img src="https://img.shields.io/github/downloads/swiftyfinch/xtree/total?label=Downloads&logo=github"></a>
  </p>
  
  <img src="https://github.com/swiftyfinch/xtree/assets/64660122/9c4405b9-e03b-499c-8174-c94e2a5a4981" width=700>
</div>

<br>

# How to use 🌳

🎬 Demonstrations: https://github.com/swiftyfinch/xtree/discussions/4

## Inputs

- Standard Xcode project: `*.xcodeproj`
- [CocoaPods](https://cocoapods.org): `Podfile.lock`
- YAML file with [a specific format](docs/inputs/yaml.md): `*.yml`/`*.yaml`
- Feel free to suggest other common input files

## Commands Help (Terminal CLI)

```sh
> xtree --help

 🌳 Printing and analyzing trees in a handy way.
╭─────────────┬────────────────────────────────────────────────────────────╮
│ > print     │ * Print a tree with children statistics.                   │
│ > frequency │ * Calculate a frequency of each node.                      │
│ > parents   │ * Find all parents of nodes.                               │
│ > impact    │ * Find affected parent nodes and print them out as a tree. │
│ > update    │ * Download and install the latest version.                 │
│             │                                                            │
│ --version   │ * Show the version.                                        │
│ --help, -h  │ * Show help information.                                   │
╰─────────────┴────────────────────────────────────────────────────────────╯
```
- [`print`](docs/commands-help/print.md)
- [`frequency`](docs/commands-help/frequency.md)
- [`parents`](docs/commands-help/parents.md)
- [`impact`](docs/commands-help/impact.md)

<br>

# How to install 📦

- [Terminal CLI](#terminal-cli)
- [Application (macOS)](#application-macos)

## Terminal CLI

For simplicity, you don't need to install a package manager.\
Just run the short script provided below and it will install `xtree` in your `$HOME/.local/bin` directory.
```sh
curl -Ls https://swiftyfinch.github.io/xtree/install.sh | bash
```

If you already have an installed one, you can update it with this command:
```sh
xtree update
```

## Application (macOS)

**Requirements**: macOS Ventura 13.0 and above.\
Use [Homebrew](https://brew.sh) and commands provided below:
```sh
brew tap swiftyfinch/xtree https://github.com/swiftyfinch/xtree.git
brew install --cask xtree --no-quarantine
```

If you already have an installed one, you can update it with this command:
```sh
brew update && brew upgrade --cask xtree
```

<br>

## 🤝 Contribution

Feel free [to open a pull request](https://github.com/swiftyfinch/xtree/contribute) or a discussion.

## 📮 Support

If you want to support this project, you can do some of these:\
`1)` <ins><b>Press</b></ins> ⭐️. It's a nice mark which means that it is useful;\
`2)` <ins><b>Share</b></ins> the project 🌍 somewhere with somebody;\
`3)` <ins><b>Leave feedback</b></ins> in the discussions 💬 section.

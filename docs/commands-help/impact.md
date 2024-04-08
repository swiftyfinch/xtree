```sh
> xtree impact --help

 🌳 Find affected parent nodes and print them out as a tree.
    Each node can contain:
    ╰─ Name height:explicit_children/children info?
╭───────────────────┬────────────────────────────────────────────────────────────╮
│ --input, -i       │ * (required) The path to the suitable file (*.xcodeproj,   │
│                   │   Podfile.lock, *.yml/*.yaml), which will be the tree      │
│                   │   input source.                                            │
│ --names, -n []    │ * (required) The names of the nodes that will be the       │
│                   │   leaves of the tree.                                      │
│ --roots, -r []    │ * Keep only subtrees where the root node contains the      │
│                   │   passed string with wildcards (*, ?).                     │
│ --contains, -c [] │ * Keep only the nodes that contain the passed strings with │
│                   │   wildcards (*, ?).                                        │
│ --except, -e []   │ * Exclude nodes that contain any of the passed strings     │
│                   │   with wildcards (*, ?).                                   │
│ --depth, -d       │ * Limit the maximum depth of the tree.                     │
│ --sort, -s        │ * Select the sorting method: by name, by number of         │
│                   │   children or by height.                                   │
│                   │                                                            │
│ --help, -h        │ * Show help information.                                   │
╰───────────────────┴────────────────────────────────────────────────────────────╯
```

## Example

```sh
> xtree impact -n Alamofire --input example.yaml
```

<img width="260" src="https://github.com/swiftyfinch/xtree/assets/64660122/de327838-ad62-4427-8e86-e1f00221c17c">

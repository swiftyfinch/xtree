```sh
> xtree print --help

 🌳 Print a tree with children statistics.
    Each node can contain:
    ╰─ Name height:explicit_children/children info?
╭───────────────────┬────────────────────────────────────────────────────────────╮
│ --input, -i       │ * (require) The path to the suitable file (*.xcodeproj,    │
│                   │   Podfile.lock, *.yml/*.yaml), which will be the tree      │
│                   │   input source.                                            │
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
> xtree --input example.yaml
```

<img width="349" src="https://github.com/swiftyfinch/xtree/assets/64660122/d167fafd-3dc6-41bc-88cb-5319d4ca3636">

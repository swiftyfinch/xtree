```sh
> xtree parents --help 

 🌳 Find all parents of nodes.
╭─────────────┬─────────────────────────────────────────────────────────────╮
│ --input, -i │ * (require) The path to the suitable file (*.xcodeproj,     │
│             │   Podfile.lock, *.yml/*.yaml), which will be the tree input │
│             │   source.                                                   │
│ --name, -n  │ * The name of the node to display its parents.              │
│             │                                                             │
│ --help, -h  │ * Show help information.                                    │
╰─────────────┴─────────────────────────────────────────────────────────────╯
```

## Example

```sh
> xtree parents --name Alamofire --input example.yaml
```

<img width="100" src="https://github.com/swiftyfinch/xtree/assets/64660122/604ebbb7-e20b-4f5e-92d8-cbf689f451bc">

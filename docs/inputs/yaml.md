# YAML Format

#### Structure:

- `Array`
  - `Map`
    - `id`: `String`
    - `info`: `String?`
    - `nodes`: `[String]`

###### Example

```sh
> xtree --input example.yaml
```

<img width="349" src="https://github.com/swiftyfinch/xtree/assets/64660122/75c46871-e72a-461d-9ceb-3cd643749e74">

```yaml
# example.yaml
- id: Alamofire
  info: 5.8.0
  nodes: []
- id: Keyboard+LayoutGuide
  info: 1.6.0
  nodes: []
- id: Kingfisher
  info: 7.9.1
  nodes: []
- id: LocalPod
  info: 1.0.0
  nodes:
  - LocalPod-LocalPodResources
  - Moya
- id: LocalPod-LocalPodResources
  info: 1.0.0
  nodes: []
- id: Moya
  info: 15.0.0
  nodes:
  - Alamofire
- id: SnapKit
  info: 5.6.0
  nodes: []
```

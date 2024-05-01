# YAML Format

- [Structure](#structure)
- [Example](#example)
  - [Terminal CLI](#terminal-cli)
  - [Application (macOS)](#application-macos)

<br>

## Structure

- `Array`
  - `Map`
    - `id`: `String`
    - `info`: `String?`
    - `nodes`: `[String]`
    - `icon`: `Map?` (macOS Application)
      - `sfSymbol`: `String`
      - `primaryColor`: `UInt`
      - `secondaryColor`: `UInt?`

<br>

## Example

```yaml
# example.yaml
- id: Alamofire
  info: 5.8.0
  icon:
    sfSymbol: shippingbox.fill
    primaryColor: 0xbd923e
  nodes: []
- id: Keyboard+LayoutGuide
  info: 1.6.0
  icon:
    sfSymbol: shippingbox.fill
    primaryColor: 0xbd923e
  nodes: []
- id: Kingfisher
  info: 7.9.1
  icon:
    sfSymbol: shippingbox.fill
    primaryColor: 0xbd923e
  nodes: []
- id: LocalPod
  info: 1.0.0
  icon:
    sfSymbol: folder.fill
    primaryColor: 0x666666
  nodes:
  - LocalPod-LocalPodResources
  - Moya
- id: LocalPod-LocalPodResources
  info: 1.0.0
  icon:
    sfSymbol: folder.fill
    primaryColor: 0x666666
  nodes: []
- id: Moya
  info: 15.0.0
  icon:
    sfSymbol: shippingbox.fill
    primaryColor: 0xbd923e
  nodes:
  - Alamofire
- id: SnapKit
  info: 5.6.0
  icon:
    sfSymbol: shippingbox.fill
    primaryColor: 0xbd923e
  nodes: []
```

<br>

#### Terminal CLI

```sh
> xtree --input example.yaml
```

<img width="350" src="https://github.com/swiftyfinch/xtree/assets/64660122/d167fafd-3dc6-41bc-88cb-5319d4ca3636">

<br><br>

#### Application (macOS)

<img width="363" alt="Screenshot 2024-05-02 at 00 06 56" src="https://github.com/swiftyfinch/xtree/assets/64660122/140e13fc-d3de-42da-a786-8df13b9c1ccb">

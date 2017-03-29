# Tentacle [![MIT license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/mdiep/Tentacle/master/LICENSE.md)
A Swift framework for the GitHub API

```swift
let client = Client(.dotCom, token: "…")
client
    .release(forTag: "tag-name", in: Repository(owner: "ReactiveCocoa", name: "ReactiveCocoa"))
    .startWithResult { result in
        switch result {
        case let .success(response, release):
            print("Downloaded release: \(release)")
        case let .failure(error):
            print("An error occured: \(error)")
        }
    }
```

Tentacle is built with [ReactiveSwift](https://github.com/ReactiveCocoa/ReactiveSwift).

## License
Tentacle is available under the [MIT License](LICENSE.md)

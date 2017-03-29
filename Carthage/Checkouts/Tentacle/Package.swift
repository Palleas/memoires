import PackageDescription

let package = Package(
    name: "Tentacle",
    dependencies: [
        .Package(url: "https://github.com/thoughtbot/Argo.git", versions: Version(4, 1, 2)..<Version(4, .max, .max)),
        .Package(url: "https://github.com/thoughtbot/Curry.git", majorVersion: 3),
        .Package(url: "https://github.com/ReactiveCocoa/ReactiveSwift.git", versions: Version(1, 1, 0)..<Version(1, .max, .max)),
    ]
)

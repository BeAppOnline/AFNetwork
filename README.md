# AFNetworks

### Swift Package Manager
```
import PackageDescription

let package = Package(
    name: "AFNetworks",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "AFNetworks",
            targets: ["AFNetworks"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: https://github.com/afdetails/AFNetwork.git, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "AFNetworks",
            dependencies: []),
        .testTarget(
            name: "AFNetworksTests",
            dependencies: ["AFNetworks"]),
    ]
)
```
And then import wherever needed: `import AFNetwork`


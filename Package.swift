// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CollectionPickerView",
    products: [
        .library(name: "CollectionPickerView", targets: ["CollectionPickerView"]),
    ],
    targets: [
        .target(name: "CollectionPickerView")
    ]
)

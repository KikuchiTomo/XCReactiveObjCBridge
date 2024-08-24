// swift-tools-version:5.5
import PackageDescription

let package = Package(
  name: "ReactiveObjCBridge",
  platforms: [.iOS(.v15), .macOS(.v10_14)],
  products: [
    .library(
      name: "ReactiveObjCBridge",
      targets: ["ReactiveObjCBridge"])     
  ],
  dependencies: [
    .package(url: "https://github.com/ReactiveCocoa/ReactiveSwift.git", from: "6.4.0"),
    .package(url: "https://github.com/KikuchiTomo/XCReactiveObjC.git", branch: "ReactiveObjC")    
  ],
  targets: [
     .binaryTarget(
      name: "ReactiveObjCBridge",
      url: "https://github.com/KikuchiTomo/XCReactiveObjC/releases/download/v1.0.0/ReactiveObjCBridge.xcframework.zip",
      checksum: "57a0b762b357cb222c95993d1d5be70678e3696daa9cb176b6675a59d9a25306"
     )       
  ]
)

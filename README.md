# react-native-swift-base

Re-bases a react native project into a Swift-centric one.

# Usage

```
yarn add react-native-swift-base
react-native link
```

# What it does

Replaces the `main.m`, `AppDelegate.m`, and `AppDelegate.h` files with the necessary Swift-base components `AppDelegate.swift` (established as main entry point) and `swift-Bridging-Header` (for the ObjC->Swift bridge)

# Why this matters

This is table-setting for editing the core application in Swift, which is frankly easier for a lot of folks than ObjC!

**Note** This does _not_ replace the `react-native-swift` package, which relates to the compatibility of statically-linked libraries.

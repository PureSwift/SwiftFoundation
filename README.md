# SwiftFoundation #
[![Swift](https://img.shields.io/badge/swift-5.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Platforms](https://img.shields.io/badge/platform-osx%20%7C%20ios%20%7C%20watchos%20%7C%20tvos%20%7C%20linux%20%7C%20wasm-lightgrey.svg)](https://developer.apple.com/swift/)
[![Release](https://img.shields.io/github/release/pureswift/swiftfoundation.svg)](https://github.com/PureSwift/SwiftFoundation/releases)
[![License](https://img.shields.io/badge/license-MIT-71787A.svg)](https://tldrlegal.com/license/mit-license)
[![Build Status](https://travis-ci.org/PureSwift/SwiftFoundation.svg?branch=develop)](https://travis-ci.org/PureSwift/SwiftFoundation)

Cross-Platform, Protocol-Oriented Programming base library to complement the Swift Standard Library.

## Goals

- Provide a cross-platform *interface* that mimics Apple's Foundation framework.
- Provide a POSIX-based *implementation* for maximum portability.
- *Rewrite* Foundation with Protocol-Oriented Programming principals.
- Long-term Pure Swift *replacement* for the Cocoa frameworks.

## Problems with [Apple's Foundation](https://github.com/apple/swift-corelibs-foundation)

- **Objective-C** - Apple's Foundation is an old API designed for Objective-C. While it works great (on Apple's platforms) and has a nice API for Objective-C programming, when imported into Swift, you can see the shortcomings of its 20+ year old API. 
- **Unimplemented** - The [open source version](https://github.com/apple/swift-corelibs-foundation) of Apple's Foundation is severly lacking implementation. Most methods are marked with ```NSUnimplemented()```. Only a small subset of Foundation based on CoreFoundation is implemented (e.g. ```NSArray```, ```NSString```, ```NSDictionary```). Basic Functionality like JSON, Base64, and even HTTP requests are not implemented.
- **Portability** - Since Apple's Foundation is backed by CoreFoundation, the only supported platforms are currently Linux, Darwin, and (potentially) Windows. Supporting other platforms (e.g. ARM Linux, BSD, SunOS) would require changes to the CoreFoundation codebase, written in C, which is not good for a long term Swift base library. We want all of our code to be understood by any Swift programmer.
- **Protocol Oriented Programming** - Perhaps the biggest reason to use this library, is to break free from the old *Object-Oriented Programming* paradigms. Swift structures and protocols free you from pointers and memory management, along with bugs related to multithreaded environments. Creating structs for basic types like ```Date``` and ```UUID``` allows you to use ```let``` and ```var``` correctly. Structs also bring huge performance improvements since the compiler can perform more optimizations and doesn't have to create all the metadata needed for the Swift class runtime.

## Targeted Platforms

- Darwin (macOS, iOS, watchOS, tvOS)
- Linux (Ubuntu x86_64, [Debian Armv7](https://github.com/uraimo/buildSwiftOnARM))
- [WebAssembly](https://swiftwasm.org) (wasm32)

## Implemented
To see what parts of Foundation are implemented, just look at the unit tests. Completed functionality will be fully unit tested. Note that there is some functionality that is written as a protocol only, that will not be included on this list.

- [x] Base64
- [x] Data
- [x] Date
- [ ] FileManager
- [ ] JSON
- [ ] RegularExpression (POSIX, not ICU)
- [x] Thread
- [x] URL
- [x] UUID

# License

This program is free software; you can redistribute it and/or modify it under the terms of the MIT License.

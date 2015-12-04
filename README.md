# SwiftFoundation #
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![Join the chat at https://gitter.im/PureSwift/SwiftFoundation](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/PureSwift/SwiftFoundation?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Cross-Platform, Protocol-Oriented Programming base library to complement the Swift Standard Library.

## Goals

- Provide a cross-platform *interface* that mimics Apple's Foundation framework.
- Provide a POSIX-based *implementation* for maximum portablility.
- *Rewrite* Foundation with Protocol-Oriented Programming principals.
- Long-term Pure Swift *replacement* for the Cocoa frameworks.

## Targeted Platforms

- LLVM Compiler
   - Darwin (OS X, iOS, WatchOS)
   - Linux

## Dependencies
- Linux (use distribution's package manager)
	- json-c
	- [libb64](http://libb64.sourceforge.net) (Build from source)
- Darwin (uses [Carthage](https://github.com/Carthage/Carthage))
	- [json-c](https://github.com/PureSwift/json-c)
	- [libb64](https://github.com/PureSwift/libb64)

## Compiling on Ubuntu

Install Swift from [here](https://swift.org/download/).

Install the required dependencies with:

```sudo apt-get install libb64-dev libjson-c-dev libjson0-dev```

Try compiling the [example project](https://github.com/PureSwift/SwiftFoundationExample).

## Implemented
To see what parts of Foundation are implemented, just look at the unit tests. Completed functionality will be fully unit tested. Note that there are some functionality that is written as a protocol only, that will not be included on this list.

- [x] Date
- [x] Null
- [x] Order (equivalent to ```NSComparisonResult```)
- [x] SortDescriptor
- [x] UUID
- [x] FileManager
- [x] Data
- [x] URL
- [X] RegularExpression (POSIX, not ICU)
- [x] JSON
- [x] Base64

# License

This program is free software; you can redistribute it and/or modify it under the terms of the MIT License.

- [json-c](https://github.com/json-c/json-c/wiki#license) - MIT License
- [libb64](http://sourceforge.net/p/libb64/git/ci/master/tree/LICENSE) - Public Domain

# See Also

- [cURLSwift](https://github.com/PureSwift/cURLSwift) - Swift wrapper for cURL
- [SwiftCF](https://github.com/PureSwift/SwiftCF) - Swift Protocol-Oriented Structs for CoreFoundation

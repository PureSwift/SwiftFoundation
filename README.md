# SwiftFoundation #
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Cross-Platform, Protocol-Oriented Programming base library to complement the Swift Standard Library.

## Goals

- Provide a cross-platform *interface* that mimics Apple's Foundation framework.
- Provide a POSIX-based *implementation* for maximum .portablility
- *Rewrite* Foundation with Protocol-Oriented Programming principals.
- Long-term Pure Swift *replacement* for the Cocoa frameworks.

## Targeted Platforms

- LLVM Compiler
   - Darwin (OS X, iOS, WatchOS)
   - Linux

## Dependencies
- Linux (use distribution's package manager)
	- ICU
	- CFLite
	- json-c
	- [libb64](http://libb64.sourceforge.net) (Build from source)
- Darwin (uses [Carthage](https://github.com/Carthage/Carthage))
	- [json-c](https://github.com/PureSwift/json-c)
	- [libb64](https://github.com/PureSwift/libb64)

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
- [x] DateFormatter (uses ```CFDateFormatter```)
- [x] Locale (uses ```CFLocale```)
- [X] RegularExpression (POSIX, not ICU)
- [x] JSON
- [x] Base64
- [ ] Decimal
- [ ] OperationQueue
- [ ] NotificationCenter

# License

This program is free software; you can redistribute it and/or modify it under the terms of the MIT License.

- [json-c](https://github.com/json-c/json-c/wiki#license) - MIT License
- [libb64](http://sourceforge.net/p/libb64/git/ci/master/tree/LICENSE) - Public Domain
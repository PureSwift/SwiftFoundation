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
- Linux
	- ICU
	- CFLite
	- curl
	- json-c
- Darwin (uses [Carthage](https://github.com/Carthage/Carthage))
	- [curl](https://github.com/PureSwift/curl)
	- [json-c](https://github.com/PureSwift/json-c)

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
- [x] HTTPClient (equivalent to ```NSURLConnection```)
- [X] RegularExpression (POSIX, not ICU)
- [x] JSON
- [x] Base64
- [ ] Decimal
- [ ] OperationQueue
- [ ] NotificationCenter

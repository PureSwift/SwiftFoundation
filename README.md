# SwiftFoundation #

[![Join the chat at https://gitter.im/PureSwift/SwiftFoundation](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/PureSwift/SwiftFoundation?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
Cross-Platform, Protocol-Oriented Programming base library to complement the Swift Standard Library.

## Goals

- Provide a cross-platform *interface* that mimics Apple's Foundation framework.
- Provide a base POSIX-based *implementation* for maximum portablility
- *Rewrite* Foundation with Protocol-Oriented Programming principals
- Long-term Pure Swift *replacement* for the Cocoa frameworks.
- Toll-free *Bridges* to Foundation, Java, Andriod, and .NET (thanks to Protocol Oriented Programming)
- *Pure Swift* implementation only linking against the Swift and C Standard libraries.

## Targeted Platforms

- LLVM Compiler
   - Darwin (OS X, iOS, WatchOS)
   - Linux
- [Silver Compiler](http://elementscompiler.com/elements/silver/)
   - Java 
   - Andriod
   - .NET

## Implemented
To see what parts of Foundation are implemented, just look at the unit tests. Completed functionality will be fully unit tested. Note that there are some functionality that is written as a protocol only, that will not be included on this list.

- [x] Date
- [x] Null
- [x] Order (```NSComparisonResult```)
- [x] SortDescriptor
- [x] UUID
- [x] FileManager
- [ ] NotificationCenter
- [ ] OperationQueue
- [ ] RegularExpression
- [ ] Data
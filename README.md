# SwiftFoundation #
Cross-Platform, Protocol-Oriented Programming base library to complement the Swift Standard Library.

## Goals

- Provide a cross-platform *interface* that mimics Apple's Foundation framework.
- Provide a base POSIX-based *implementation* for maximum portablility
- *Rewrite* Foundation with Protocol-Oriented Programming principals
- Long-term Pure Swift *replacement* for the Cocoa frameworks.

## Targeted Platforms

- LLVM Compiler
   - Darwin (OS X, iOS, WatchOS)
   - Linux

## Implemented
To see what parts of Foundation are implemented, just look at the unit tests. Completed functionality will be fully unit tested. Note that there are some functionality that is written as a protocol only, that will not be included on this list.

- [x] Date
- [x] Null
- [x] Order (```NSComparisonResult```)
- [x] SortDescriptor
- [x] UUID
- [x] FileManager
- [ ] URL
- [ ] NotificationCenter
- [ ] OperationQueue
- [ ] RegularExpression
- [ ] Data
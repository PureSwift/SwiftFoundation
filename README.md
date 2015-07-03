# SwiftFoundation #
Protocol-Oriented Programming base library to complement the Swift Standard Library.

## Goals

- Provide a cross-platform *interface* that mimics Apple's Foundation framework.
- Provide a base POSIX-based *implementation* for maximum portablility
- *Rewrite* Foundation with Protocol-Oriented Programming principals
- Long-term Pure Swift *replacement* for the Cocoa frameworks.
- Toll-free *Bridges* to Foundation, Andriod SDK, and .NET (thanks to Protocol Oriented Programming)
- Pure Swift implementation only linking against the Swift and C Standard libraries.

## Targeted Platforms

- LLVM Compiler
   - Darwin (OS X, iOS, WatchOS)
   - Linux
- Silver Compiler
   - Andriod
   - .NET
//
//  FileDescriptor.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 8/10/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    import Darwin
#elseif os(Linux)
    import Glibc
    import CStatfs
#endif

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)

/// POSIX File Descriptor
public typealias FileDescriptor = CInt

public extension FileDescriptor {
    
    // MARK: - Singletons
    
    /// Returns the file handle associated with the standard input file.
    /// Conventionally this is a terminal device on which the user enters a stream of data. 
    /// There is one standard input file handle per process; it is a shared instance.
    /// When using this method to create a file handle object, the file handle owns its associated 
    /// file descriptor and is responsible for closing it.
    ///
    /// - returns: The shared file handle associated with the standard input file.
    ///
    public static let standardInput: FileDescriptor = 0
    
    /// Returns the file handle associated with the standard output file.
    /// Conventionally this is a terminal device that receives a stream of data from a program. 
    /// There is one standard output file handle per process; it is a shared instance.
    /// When using this method to create a file handle object, the file handle owns its associated 
    /// file descriptor and is responsible for closing it.
    ///
    /// - returns: The shared file handle associated with the standard output file.
    ///
    public static let standardOutput: FileDescriptor = 1
    
    /// Returns the file handle associated with the standard error file.
    /// Conventionally this is a terminal device to which error messages are sent. 
    /// There is one standard error file handle per process; it is a shared instance.
    /// When using this method to create a file handle object, the file handle owns its associated file
    /// descriptor and is responsible for closing it.
    ///
    /// - returns: The shared file handle associated with the standard error file.
    ///
    public static let standardError: FileDescriptor = 2
    
    /// Returns a file handle associated with a null device.
    /// You can use null-device file handles as “placeholders” for standard-device file handles 
    /// or in collection objects to avoid exceptions and other errors resulting from messages being 
    /// sent to invalid file handles. Read messages sent to a null-device file handle return an 
    /// end-of-file indicator (empty Data) rather than raise an exception. 
    /// Write messages are no-ops, whereas fileDescriptor returns an illegal value. 
    /// Other methods are no-ops or return “sensible” values.
    /// When using this method to create a file handle object, 
    /// the file handle owns its associated file descriptor and is responsible for closing it.
    ///
    /// - returns: A file handle associated with a null device.
    ///
    public static let nullDevice: FileDescriptor = open("/dev/null", O_RDWR | O_BINARY)
}

public let O_BINARY: Int32 = 0

#endif


//
//  FileManager.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    import Darwin.C
#elseif os(Linux)
    import Glibc
    import CStatfs
#endif

public typealias FileSystemAttributes = statfs

public typealias FileAttributes = stat

/// Type for interacting with the file system.
public struct FileManager {
    
    // MARK: - Determining Access to Files
    
    /// Determines whether a file descriptor exists at the specified path. Can be regular file, directory, socket, etc.
    public static func itemExists(at path: String) -> Bool {
        
        var inodeInfo = stat()
        
        guard stat(path, &inodeInfo) == 0
            else { return false }
        
        return true
    }
    
    /// Determines whether a file exists at the specified path.
    public static func fileExists(at path: String) -> Bool {
        
        var inodeInfo = stat()
        
        guard stat(path, &inodeInfo) == 0
            else { return false }
        
        guard (inodeInfo.st_mode & S_IFMT) == S_IFREG
            else { return false }
        
        return true
    }
    
    /// Determines whether a directory exists at the specified path.
    public static func directoryExists(at path: String) -> Bool {
        
        var inodeInfo = stat()
        
        guard stat(path, &inodeInfo) == 0
            else { return false }
        
        guard (inodeInfo.st_mode & S_IFMT) == S_IFDIR
            else { return false }
        
        return true
    }
    
    // MARK: - Managing the Current Directory
    
    /// Attempts to change the current directory
    public static func changeCurrentDirectory(_ newCurrentDirectory: String) throws {
        
        guard chdir(newCurrentDirectory) == 0
            else { throw POSIXError.fromErrno! }
    }
    
    /// Gets the current directory
    public static var currentDirectory: String {
        
        let stringBufferSize = Int(PATH_MAX)
        
        let path = UnsafeMutablePointer<CChar>.allocate(capacity: stringBufferSize)
        
        defer { path.deallocate(capacity: stringBufferSize) }
        
        getcwd(path, stringBufferSize - 1)
        
        return String(validatingUTF8: path)!
    }
    
    // MARK: - Creating and Deleting Items
    
    public static func createFile(at path: String, contents data: Data? = nil, attributes: FileAttributes = FileAttributes()) throws {
        
        // get file descriptor for path (open file)
        let file = open(path, O_CREAT, DefaultFileMode)
        
        guard file != -1 else { throw POSIXError.fromErrno! }
        
        // close file
        defer { guard close(file) != -1 else { fatalError("Could not close file: \(path)") } }
        
        // write data
        if let data = data {
            
            try self.set(contents: data, at: path)
        }
        
        // TODO: set attributes
        
    }
    
    public static func createDirectory(at path: String, createIntermediateDirectories: Bool = false, attributes: FileAttributes = FileAttributes()) throws {
        
        if createIntermediateDirectories {
            
            fatalError("Create Intermediate Directories Not Implemented")
        }
        
        guard mkdir(path, attributes.st_mode) == 0 else { throw POSIXError.fromErrno! }
    }
    
    public static func removeItem(path: String) throws {
        
        guard remove(path) == 0 else { throw POSIXError.fromErrno! }
    }
    
    // MARK: - Creating Symbolic and Hard Links
    
    public static func createSymbolicLink(at path: String, to destinationPath: String) throws {
        
        fatalError()
    }
    
    public static func linkItem(at path: String, to destinationPath: String) throws {
        
        fatalError()
    }
    
    public static func destinationOfSymbolicLink(at path: String) throws -> String {
        
        fatalError()
    }
    
    // MARK: - Moving and Copying Items
    
    public static func copy(_ sourcePath: String, to destinationPath: String) throws {
        
        fatalError()
    }
    
    public static func move(_ sourcePath: String, to destinationPath: String) throws {
        
        fatalError()
    }
    
    // MARK: - Getting and Setting Attributes
    
    public static func attributes(at path: String) throws -> FileAttributes {
        
        return try FileAttributes(path: path)
    }
    
    public static func set(attributes: FileAttributes, at path: String) throws {
        
        // let originalAttributes = try self.attributesOfItem(atPath: path)
        
        fatalError("Not Implemented")
    }
    
    public static func fileSystemAttributes(at path: String) throws -> FileSystemAttributes {
        
        return try FileSystemAttributes(path: path)
    }
    
    // MARK: - Getting and Comparing File Contents
    
    /// Reads the contents of a file.
    public static func contents(at path: String) throws -> Data {
        
        // get file descriptor for path (open file)
        let file = open(path, O_RDONLY)
        
        guard file != -1 else { throw POSIXError.fromErrno! }
        
        // close file
        defer { guard close(file) != -1 else { fatalError("Could not close file: \(path)") } }
        
        // get file size
        let attributes = try FileAttributes(path: path)
        
        let fileSize = attributes.fileSize
        
        #if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
        
        assert(fileSize <= SSIZE_MAX, "File size (\(fileSize)) is larger than the max number of bytes allowed (\(SSIZE_MAX))")
            
        #endif
        
        let memoryPointer = UnsafeMutablePointer<Byte>.allocate(capacity: fileSize)
        
        defer { memoryPointer.deallocate(capacity: fileSize) }
        
        let readBytes = read(file, memoryPointer, fileSize)
        
        guard readBytes != -1 else { throw POSIXError.fromErrno! }
        
        //guard readBytes == fileSize else { fatalError() }
        
        let data = Data(bytes: memoryPointer, count: readBytes)
        
        return data
    }
    
    /// Sets the contents of an existing file.
    public static func set(contents data: Data, at path: String) throws {
        
        // get file descriptor for path (open file)
        let file = open(path, O_TRUNC | O_WRONLY)
        
        guard file != -1 else { throw POSIXError.fromErrno! }
        
        // close file
        defer { guard close(file) != -1 else { fatalError("Could not close file: \(path)") } }
        
        let writtenBytes = write(file, data.bytes, data.count)
        
        guard writtenBytes != -1 else { throw POSIXError.fromErrno! }
    }
}

public let DefaultFileMode = S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH | S_IWOTH



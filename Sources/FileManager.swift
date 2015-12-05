//
//  FileManager.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    import Darwin
#elseif os(Linux)
    import Glibc
#endif

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)


public typealias FileSystemAttributes = statfs

public typealias FileAttributes = stat

/// Class for interacting with the file system.
///
/// Only availible on Darwin (```open``` has been marked as unavailible).
public final class FileManager {
    
    // MARK: - Determining Access to Files
    
    /// Determines whether a file descriptor exists at the specified path. Can be regular file, directory, socket, etc.
    public static func itemExists(path: String) -> Bool {
        
        return (stat(path, nil) == 0)
    }
    
    /// Determines whether a file exists at the specified path.
    public static func fileExists(path: String) -> Bool {
        
        var inodeInfo = stat()
        
        guard stat(path, &inodeInfo) == 0
            else { return false }
        
        guard (inodeInfo.st_mode & S_IFMT) == S_IFREG
            else { return false }
        
        return true
    }
    
    /// Determines whether a directory exists at the specified path.
    public static func directoryExists(path: String) -> Bool {
        
        var inodeInfo = stat()
        
        guard stat(path, &inodeInfo) == 0
            else { return false }
        
        guard (inodeInfo.st_mode & S_IFMT) == S_IFDIR
            else { return false }
        
        return true
    }
    
    // MARK: - Managing the Current Directory
    
    /// Attempts to change the current directory
    public static func changeCurrentDirectory(newCurrentDirectory: String) throws {
        
        guard chdir(newCurrentDirectory) == 0
            else { throw POSIXError.fromErrorNumber! }
    }
    
    /// Gets the current directory
    public static var currentDirectory: String {
        
        let stringBufferSize = Int(PATH_MAX)
        
        let path = UnsafeMutablePointer<CChar>.alloc(stringBufferSize)
        
        defer { path.dealloc(stringBufferSize) }
        
        getcwd(path, stringBufferSize - 1)
        
        return String.fromCString(path)!
    }
    
    // MARK: - Creating and Deleting Items
    
    public static func createFile(path: String, contents data: Data? = nil, attributes: FileAttributes = FileAttributes()) throws {
        
        // get file descriptor for path (open file)
        let file = open(path, O_CREAT, DefaultFileMode)
        
        guard file != -1 else { throw POSIXError.fromErrorNumber! }
        
        // close file
        defer { guard close(file) != -1 else { fatalError("Could not close file: \(path)") } }
        
        // write data
        if let data = data {
            
            try self.setContents(path, data: data)
        }
        
        // TODO: set attributes
        
    }
    
    public static func createDirectory(path: String, withIntermediateDirectories createIntermediates: Bool = false, attributes: FileAttributes = FileAttributes()) throws {
        
        if createIntermediates {
            
            fatalError("Create Intermediate Directories Not Implemented")
        }
        
        guard mkdir(path, attributes.st_mode) == 0 else { throw POSIXError.fromErrorNumber! }
    }
    
    public static func removeItem(path: String) throws {
        
        guard remove(path) == 0 else { throw POSIXError.fromErrorNumber! }
    }
    
    // MARK: - Creating Symbolic and Hard Links
    
    public static func createSymbolicLink(path: String, withDestinationPath destinationPath: String) throws {
        
        fatalError()
    }
    
    public static func linkItem(path: String, toPath destinationPath: String) throws {
        
        fatalError()
    }
    
    public static func destinationOfSymbolicLink(path: String) throws -> String {
        
        fatalError()
    }
    
    // MARK: - Moving and Copying Items
    
    public static func copyItem(sourcePath: String, toPath destinationPath: String) throws {
        
        fatalError()
    }
    
    public static func moveItem(sourcePath: String, toPath destinationPath: String) throws {
        
        fatalError()
    }
    
    // MARK: - Getting and Setting Attributes
    
    public static func attributesOfItem(path: String) throws -> FileAttributes {
        
        return try FileAttributes(path: path)
    }
    
    public static func setAttributes(attributes: FileAttributes, ofItemAtPath path: String) throws {
        
        // let originalAttributes = try self.attributesOfItem(atPath: path)
        
        fatalError("Not Implemented")
    }
    
    public static func attributesOfFileSystem(forPath path: String) throws -> FileSystemAttributes {
        
        return try FileSystemAttributes(path: path)
    }
    
    // MARK: - Getting and Comparing File Contents
    
    /// Reads the contents of a file.
    public static func contents(path: String) throws -> Data {
        
        // get file descriptor for path (open file)
        let file = open(path, O_RDONLY)
        
        guard file != -1 else { throw POSIXError.fromErrorNumber! }
        
        // close file
        defer { guard close(file) != -1 else { fatalError("Could not close file: \(path)") } }
        
        // get file size
        let attributes = try FileAttributes(path: path)
        
        let fileSize = attributes.fileSize
        
        assert(fileSize <= SSIZE_MAX, "File size (\(fileSize)) is larger than the max number of bytes allowed (\(SSIZE_MAX))")
        
        let memoryPointer = UnsafeMutablePointer<Byte>.alloc(fileSize)
        
        defer { memoryPointer.dealloc(fileSize) }
        
        let readBytes = read(file, memoryPointer, fileSize)
        
        guard readBytes != -1 else { throw POSIXError.fromErrorNumber! }
        
        //guard readBytes == fileSize else { fatalError() }
        
        var data = Data()
        
        for i in 0...readBytes - 1 {
            
            let byte = memoryPointer[i]
            
            data.append(byte)
        }
        
        return data
    }
    
    /// Sets the contents of an existing file.
    public static func setContents(path: String, data: Data) throws {
        
        // get file descriptor for path (open file)
        let file = open(path, O_WRONLY)
        
        guard file != -1 else { throw POSIXError.fromErrorNumber! }
        
        // close file
        defer { guard close(file) != -1 else { fatalError("Could not close file: \(path)") } }
        
        let writtenBytes = write(file, data, data.count)
        
        guard writtenBytes != -1 else { throw POSIXError.fromErrorNumber! }
    }
}

public let DefaultFileMode = S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH | S_IWOTH

#endif


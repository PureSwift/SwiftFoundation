//
//  FileManager.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

/// Class for interacting with the file system.
public final class FileManager {
    
    // MARK: - Determining Access to Files
    
    /// Determines whether a file descriptor exists at the specified path. Can be regular file, directory, socket, etc.
    public static func itemExists(atPath path: String) -> Bool {
        
        return (stat(path, nil) == 0)
    }
    
    /// Determines whether a file exists at the specified path.
    public static func fileExists(atPath path: String) -> Bool {
        
        var inodeInfo = stat()
        
        guard stat(path, &inodeInfo) == 0
            else { return false }
        
        guard (inodeInfo.st_mode & S_IFMT) == S_IFREG
            else { return false }
        
        return true
    }
    
    /// Determines whether a directory exists at the specified path.
    public static func directoryExists(atPath path: String) -> Bool {
        
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
        
        guard chdir(newCurrentDirectory) == 0 else {
            
            throw POSIXError.fromErrorNumber!
        }
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
    
    public static func createFileAtPath(path: String, contents: Data?, attributes: FileAttributes?) throws {
        
        
    }
    
    public static func removeItem(atPath path: String) throws {
        
        
    }
    
    // MARK: - Moving and Copying Items
    
    
    
    // MARK: - Getting and Setting Attributes
    
    public static func attributesOfItem(atPath path: String) throws -> FileAttributes {
        
        
    }
    
    public static func setAttributes(attributes: FileAttributes, ofItemAtPath path: String) throws {
        
        
    }
    
    public static func attributesOfFileSystem(forPath path: String) throws -> FileSystemAttributes {
        
    
    }
    
}
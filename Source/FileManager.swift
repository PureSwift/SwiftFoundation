//
//  FileManager.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

/// Class for interacting with the file system.
public final class FileManager {
    
    // MARK: - Class Methods
    
    /// Determines whether a file descriptor exists at the specified path. Can be regular file, directory, socket, etc.
    public static func itemExists(atPath path: String) -> Bool {
        
        return (stat(path, nil) == 0)
    }
    
    /// Determines whether a file exists at the specified path.
    public static func fileExists(atPath path: String) -> Bool {
        
        var inodeInfo = stat()
        
        guard stat(path, &inodeInfo) == 0 else {
            
            return false
        }
        
        guard (inodeInfo.st_mode & S_IFMT) == S_IFREG else {
            
            return false
        }
        
        return true
    }
    
    /// Determines whether a directory exists at the specified path.
    public static func directoryExists(atPath path: String) -> Bool {
        
        var inodeInfo = stat()
        
        guard stat(path, &inodeInfo) == 0  else {
            
            return false
        }
        
        guard (inodeInfo.st_mode & S_IFMT) == S_IFDIR else {
            
            return false
        }
        
        return true
    }
    
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
    
    /*
    public func attributesOfFileSystem(forPath path: String) throws -> FileAttributes {
        
        
    }
    */
    
}
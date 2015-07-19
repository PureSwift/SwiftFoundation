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
    
    /// Determines whether a file exists at the specified path.
    static func fileExists(atPath path: String) -> Bool {
        
        let inodeInfo = UnsafeMutablePointer<stat>.alloc(1)
        
        defer { inodeInfo.dealloc(1) }
        
        guard stat(path, inodeInfo) == 0  else {
            
            return false
        }
        
        guard (inodeInfo.memory.st_mode | S_IFMT) != S_IFDIR else {
            
            return false
        }
        
        return true
    }
    
    /// Determines whether a directory exists at the specified path.
    static func directoryExists(atPath path: String) -> Bool {
        
        let inodeInfo = UnsafeMutablePointer<stat>.alloc(1)
        
        defer { inodeInfo.dealloc(1) }
        
        guard stat(path, inodeInfo) == 0  else {
            
            return false
        }
        
        guard (inodeInfo.memory.st_mode | S_IFMT) == S_IFDIR else {
            
            return false
        }
        
        return true
    }
    
    static func changeCurrentDirectory(newCurrentDirectory: String) throws {
        
        guard chdir(newCurrentDirectory) == 0 else {
            
            errno
        }
    }
    
    static var currentDirectory: String {
        
        let path = UnsafeMutablePointer<UInt8>.alloc(Int(PATH_MAX))
        
        
    }
}
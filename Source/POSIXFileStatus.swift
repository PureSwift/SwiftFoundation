//
//  POSIXFileStatus.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/22/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

public extension stat {
    
    // MARK: - Properties
    
    var fileType: FileType {
        
        get { return st_mode.fileType }
        set { st_mode.fileType = fileType }
    }
    
    // MARK: - Initialization
    
    init(path: String) throws {
        
        var fileStatus = stat()
        
        guard stat(path, &fileStatus) == 0 else {
            
            throw POSIXError.fromErrorNumber!
        }
        
        self = fileStatus
    }
}

public typealias POSIXFileTypeBitMask = UInt16

public extension mode_t {
    
    /// Extracts the FileType from the bitmask. Fatal error occurs for invalid bitmasks.
    var fileType: FileType {
        
        get {
            
            switch (self & S_IFMT) {
                
            case S_IFBLK: return .BlockSpecial
            case S_IFCHR: return .CharacterSpecial
            case S_IFDIR: return .Directory
            case S_IFIFO: return .Fifo
            case S_IFREG: return .Regular
            case S_IFLNK: return .SymbolicLink
            case S_IFSOCK: return .Socket
                
            default: fatalError("Unknown POSIX FileType Bitmask \(self)")
            }
        }
        
        set {
            
            var fileTypeMask: POSIXFileTypeBitMask!
            
            switch fileType {
                
            case .BlockSpecial: fileTypeMask =  S_IFBLK
            case .CharacterSpecial: fileTypeMask = S_IFCHR
            case .Directory: fileTypeMask = S_IFDIR
            case .Fifo: fileTypeMask = S_IFIFO
            case .Regular: fileTypeMask = S_IFREG
            case .SymbolicLink: fileTypeMask = S_IFLNK
            case .Socket: fileTypeMask = S_IFSOCK
            }
            
            self = (self | fileTypeMask)
        }
    }
    
    /*
    var fileMode: FileMode {
        
        
    }
    */
}


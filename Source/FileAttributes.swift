//
//  FileAttributes.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/19/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//


public struct FileAttributes {
    
    // MARK: - Properties
    
    public var appendOnly: Bool = false
    
    public var busy: Bool = false
    
    public var size: UInt
    
    public var type: FileType
    
    public var creationDate: Date
    
    public var modificationDate: Date
    
    public var ownerAccountName: String
    
    public var fileSystemFileNumber: Int
    
    public var fileGroupOwnerAccountID: Int
    
    // MARK: - Initialization
    
    public init(fileAttributes: stat) {
        
        self.modificationDate = Date(timeIntervalSinceReference1970: fileAttributes.st_mtimespec.time)
    }
}


public enum FileType {
    
    case Regular
    case Directory
    case BlockSpecial
    case CharacterSpecial
    case Fifo
    case Socket
    case SymbolicLink
    
    public init() { self = .Regular }
    
    public init(fileAttribute: mode_t) {
        
        switch (fileAttribute & S_IFMT) {
            
        case S_IFBLK: self = .BlockSpecial
        case S_IFCHR: self = .CharacterSpecial
        case S_IFDIR: self = .Directory
        case S_IFIFO: self = .Fifo
        case S_IFREG: self = .Regular
        case S_IFLNK: self = .SymbolicLink
        case S_IFSOCK: self = .Socket
        
        default: self = FileType()
        }
    }
}
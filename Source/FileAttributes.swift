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
    
    // public init() { }
    
    /*
    public init(fileAttributes: stat) {
        
        self.modificationDate = Date(timeIntervalSince1970: fileAttributes.st_mtimespec.timeIntervalValue)
        self.creationDate = Date(timeIntervalSince1970: fileAttributes.st_ctimespec.timeIntervalValue)
    }
    */
}
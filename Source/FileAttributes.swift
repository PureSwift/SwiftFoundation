//
//  FileAttributes.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/19/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//


public struct FileAttributes {
    
    // MARK: - Properties
    
    /// The identifier for the device on which the file resides.
    public var deviceID: dev_t
    
    /// File's filesystem file number.
    public var fileSystemFileNumber: ino_t
    
    /// POSIX file type and permissions bit mask
    public var fileMode: mode_t
    
    /// File size, in bytes
    public var size: off_t
    
    /// Date the file was created
    public var creationDate: Date
    
    /// Date the file was modified
    public var modificationDate: Date
    
    // User ID of the file
    public var ownerAccountID: uid_t
    
    // Group ID of the file
    public var groupOwnerAccountID: gid_t
    
    // MARK: - Initialization
    
    public init(attributesOfFileAtPath path: String) throws {
        
        let fileStatus = try stat(path: path)
        
        self.init(fileStatus: fileStatus)
    }
    
    init(fileStatus: stat) {
        
        self.deviceID = fileStatus.st_dev
        self.fileSystemFileNumber = fileStatus.st_ino
        self.fileMode = fileStatus.st_mode
        self.size = fileStatus.st_size
        //self.creationDate = fileStatus.la
        self.
    }
}
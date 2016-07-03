//
//  POSIXFileStatus.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/22/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    import Darwin
#elseif os(Linux)
    import Glibc
    import CStatfs
#endif

public extension stat {
    
    // MARK: - Initialization
    
    init(path: String) throws {
        
        var fileStatus = stat()
        
        guard stat(path, &fileStatus) == 0 else {
            
            throw POSIXError.fromErrno!
        }
        
        self = fileStatus
    }
    
    // MARK: - Properties
    
    #if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    
    /// Date of last access. Date of ```st_atimespec``` or ```st_atime```.
    ///
    /// The field ```st_atime``` is changed by file accesses, for example, by ```execve```, ```mknod```, ```pipe```, ```utime```, and ```read``` (of more than zero bytes).
    /// Other routines, like ```mmap```, may or may not update ```st_atime```.
    var lastAccessDate: Date {
        
        get { return Date(timeIntervalSince1970: st_atimespec.timeInterval) }
        set { st_atimespec = timespec(timeInterval: lastDataModificationDate.timeIntervalSince1970) }
    }
    
    /// Date of last data modification. Date of ```st_mtimespec``` or ```st_mtime```.
    ///
    /// The field ```st_mtime``` is changed by file modifications, for example, by ```mknod```, ```truncate```, ```utime```, and ```write``` (of more than zero bytes).
    /// Moreover, ```st_mtime``` of a directory is changed by the creation or deletion of files in that directory.
    /// The ```st_mtime``` field is not changed for changes in owner, group, hard link count, or mode.
    var lastDataModificationDate: Date {
        
        get { return Date(timeIntervalSince1970: st_mtimespec.timeInterval) }
        set { st_mtimespec = timespec(timeInterval: lastDataModificationDate.timeIntervalSince1970) }
    }
    
    /// Date of last status change. Date of ```st_ctimespec``` or ```st_ctime```.
    ///
    /// The field ```st_ctime``` is changed by writing or by setting inode information (i.e., owner, group, link count, mode, etc.).
    var lastStatusChangeDate: Date {
        
        get { return Date(timeIntervalSince1970: st_ctimespec.timeInterval) }
        set { st_ctimespec = timespec(timeInterval: lastDataModificationDate.timeIntervalSince1970) }
    }
    
    /// Date file was created. Date of ```st_birthtimespec``` or ```st_birthtime```.
    var creationDate: Date {
        
        get { return Date(timeIntervalSince1970: st_birthtimespec.timeInterval) }
        set { st_birthtimespec = timespec(timeInterval: lastDataModificationDate.timeIntervalSince1970) }
    }
    
    #endif
    
    var fileSize: Int {
        
        get { return Int(st_size) }
        set { st_size = off_t(fileSize) }
    }
}

public extension mode_t {
    
    /// Extracts the FileType from the bitmask.
    var fileType: FileType? {
        
        get {
            
            switch (self & S_IFMT) {
                
            case S_IFBLK:   return .BlockSpecial
            case S_IFCHR:   return .CharacterSpecial
            case S_IFDIR:   return .Directory
            case S_IFIFO:   return .FIFO
            case S_IFREG:   return .Regular
            case S_IFLNK:   return .SymbolicLink
            case S_IFSOCK:  return .Socket
                
            default: return nil
            }
        }
        
        set {
            
            guard let fileType = fileType else {
                
                self = (self | 0)
                return
            }
            
            var fileTypeMask: mode_t!
            
            switch fileType {
                
            case .BlockSpecial:     fileTypeMask =  S_IFBLK
            case .CharacterSpecial: fileTypeMask = S_IFCHR
            case .Directory:        fileTypeMask = S_IFDIR
            case .FIFO:             fileTypeMask = S_IFIFO
            case .Regular:          fileTypeMask = S_IFREG
            case .SymbolicLink:     fileTypeMask = S_IFLNK
            case .Socket:           fileTypeMask = S_IFSOCK
            }
            
            self = (self | fileTypeMask)
        }
    }
}

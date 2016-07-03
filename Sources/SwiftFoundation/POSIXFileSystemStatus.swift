//
//  POSIXFileSystemStatus.swift
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

public extension statfs {
    
    // MARK: - Initialization
    
    init(path: String) throws {
        
        var fileSystemStatus = statfs()
        
        guard statfs(path, &fileSystemStatus) == 0 else {
            
            throw POSIXError.fromErrno!
        }
        
        self = fileSystemStatus
    }
}
